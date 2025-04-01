/**
 * Load WRA-MH Perceived Stress Scale. PSS-10 is used to measure the
 * degree to which situations in one’s life are appraised as stressful.
  ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
 * The WRA PSS10 is captured bi-annually starting at the baseline visit(1.0),
 * second(3.0) and fourth(5.0) follow-up visit Mental Health(MH) Assessment instruments.
 * @author Gift Jr <muyembegift@gmail.com> | 01.04.25
 * @since 0.0.1
 * @alias Load WRA PSS-10
 * @reference NovoPsych | https://novopsych.com/assessments/well-being/perceived-stress-scale-pss-10/
 */
DROP PROCEDURE IF EXISTS `Load_WRA_MH_Stress_Assessment`;

DELIMITER $$
CREATE PROCEDURE arch_etl_db.Load_WRA_MH_Stress_Assessment()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to run proc; [Load_WRA_MH_Stress_Assessment]', @errno, '(',
                              @sqlstate,
                              '):',
                              @text);
            SELECT @full_error;
            RESIGNAL;
        END;
    -- Op matrices
    SET @v_tx_pre_sa := 0; -- Initial count
    SET @v_tx_pro_sa := 0; -- After count

    START TRANSACTION;
    TRUNCATE arch_etl_db.crt_wra_mh_stress_assessment_overview;
    SET @v_tx_pre_as = (SELECT COUNT(anx.root_id)
                        FROM arch_etl_db.wra_mental_health_assessment anx
                        WHERE anx.anx_comments_yn IN (0, 1));

    INSERT INTO arch_etl_db.crt_wra_mh_stress_assessment_overview(mh_pss_id,
                                                                  record_id,
                                                                  wra_ptid,
                                                                  member_id,
                                                                  screening_id,
                                                                  age,
                                                                  ra,
                                                                  visit_number,
                                                                  visit_name,
                                                                  visit_date,
                                                                  days_since_baseline)
    WITH pss10_v1_stress_assessment AS (SELECT mh.wra_mental_health_assessment_id                 as mh_pss_id,
                                               CAST(mh.record_id AS UNSIGNED)                     as record_id,
                                               v1.wra_ptid,
                                               v1.member_id,
                                               v1.screening_id,
                                               v1.age,
                                               v1.ra,
                                               v1.visit_number,
                                               v1.visit_name,
                                               COALESCE(mh.mh_visit_date, v1.visit_date)          as visit_date,
                                               getDaysSinceBaselineVisit(
                                                       v1.record_id,
                                                       COALESCE(mh.mh_visit_date, v1.visit_date)) as days_since_baseline
                                        FROM arch_etl_db.crt_wra_visit_1_overview v1
                                                 LEFT JOIN arch_etl_db.wra_mental_health_assessment mh
                                                           ON v1.record_id = CAST(mh.record_id AS UNSIGNED)
                                                 LEFT JOIN arch_etl_db.vw_wra_consent_overview ic
                                                           ON (v1.record_id = ic.record_id AND v1.visit_number = ic.visit_number)
                                        WHERE mh.redcap_event_name = 'wra_baseline_arm_1' -- got lazy :(, its not supposed to be hard-coded
                                        ORDER BY v1.visit_date, v1.screening_id DESC),
         pss10_v3_stress_assessment AS (SELECT mh.wra_mental_health_assessment_id                 as mh_pss_id,
                                               CAST(mh.record_id AS UNSIGNED)                     as record_id,
                                               v3.wra_ptid,
                                               v3.member_id,
                                               v3.screening_id,
                                               v3.age,
                                               v3.ra,
                                               v3.visit_number,
                                               v3.visit_name,
                                               COALESCE(mh.mh_visit_date, v3.visit_date)          as visit_date,
                                               getDaysSinceBaselineVisit(
                                                       CAST(mh.record_id AS UNSIGNED),
                                                       COALESCE(mh.mh_visit_date, v3.visit_date)) as days_since_baseline
                                        FROM arch_etl_db.crt_wra_visit_3_overview v3
                                                 LEFT JOIN wra_mental_health_assessment mh
                                                           ON v3.record_id = CAST(mh.record_id AS UNSIGNED)
                                                 LEFT JOIN arch_etl_db.vw_wra_consent_overview ic
                                                           ON (v3.record_id = ic.record_id AND v3.visit_number = ic.visit_number)
                                        WHERE mh.redcap_event_name = 'wra_followup_visit_arm_1b'
                                          AND v3.visit_outcome = 'Completed'
                                          AND ic.ongoing_consent_outcome = 'Accepted'
                                        ORDER BY v3.visit_date, v3.screening_id DESC),
         pss10_v5_stress_assessment AS (SELECT mh.wra_mental_health_assessment_id                 as mh_pss_id,
                                               CAST(mh.record_id AS UNSIGNED)                     as record_id,
                                               v5.wra_ptid,
                                               v5.member_id,
                                               v5.screening_id,
                                               v5.age,
                                               v5.ra,
                                               v5.visit_number,
                                               v5.visit_name,
                                               COALESCE(mh.mh_visit_date, v5.visit_date)          as visit_date,
                                               getDaysSinceBaselineVisit(
                                                       CAST(mh.record_id AS UNSIGNED),
                                                       COALESCE(mh.mh_visit_date, v5.visit_date)) as days_since_baseline
                                        FROM arch_etl_db.crt_wra_visit_5_overview v5
                                                 LEFT JOIN wra_mental_health_assessment mh
                                                           ON v5.record_id = CAST(mh.record_id AS UNSIGNED)
                                                 LEFT JOIN arch_etl_db.vw_wra_consent_overview ic
                                                           ON (v5.record_id = ic.record_id AND v5.visit_number = ic.visit_number)
                                        WHERE mh.redcap_event_name = 'wra_followup_visit_arm_1d'
                                          AND v5.visit_outcome = 'Completed'
                                          AND ic.ongoing_consent_outcome = 'Accepted'
                                        ORDER BY v5.visit_date, v5.screening_id DESC)
         -- Combine the expressed MH datasets for v1, v3 and v5
        ((SELECT * FROM pss10_v1_stress_assessment)
         UNION
         (SELECT * FROM pss10_v3_stress_assessment)
         UNION
         (SELECT * FROM pss10_v5_stress_assessment));

    -- update common table overviews using source meta data from the Mental Health (MH) Assessment
    -- instrument by WRA Visit.
    UPDATE arch_etl_db.crt_wra_mh_stress_assessment_overview sa
        LEFT JOIN wra_mental_health_assessment mh ON sa.record_id = CAST(mh.record_id AS UNSIGNED)
        JOIN visit v ON (mh.redcap_event_name = v.visit_name AND sa.visit_name = v.visit_alias)
    SET sa.mh_pss_id  = mh.wra_mental_health_assessment_id,
        sa.ra         = mh.anx_interviewer_obsloc,
        sa.visit_date = COALESCE(mh.anx_visit_date, sa.visit_date)
    WHERE sa.visit_name = v.visit_name;

    -- PSS-10 Test
    UPDATE arch_etl_db.crt_wra_mh_stress_assessment_overview sa
        LEFT JOIN wra_mental_health_assessment mh ON sa.record_id = CAST(mh.record_id AS UNSIGNED)
        JOIN visit v ON (mh.redcap_event_name = v.visit_name AND sa.visit_name = v.visit_alias)
    SET sa.stress_problem_1  = mh.pss_upset_scorres_label,
        sa.stress_problem_2  = mh.pss_no_ctrl_scorres_label,
        sa.stress_problem_3  = mh.pss_nervous_scorres_label,
        sa.stress_problem_4  = mh.pss_confid_scorres_label,
        sa.stress_problem_5  = mh.pss_yrway_scorres_label,
        sa.stress_problem_6  = mh.pss_cope_scorres_label,
        sa.stress_problem_7  = mh.pss_ctrl_scorres_label,
        sa.stress_problem_8  = mh.pss_ontop_scorres_label,
        sa.stress_problem_9  = mh.pss_anger_scorres_label,
        sa.stress_problem_10 = mh.pss_dfclt_scorres_label,
        sa.comments          = mh.ss_comments
    WHERE sa.visit_number = v.visit_number;
    -- PSS-10 Scoring
    UPDATE arch_etl_db.crt_wra_mh_stress_assessment_overview sa
        LEFT JOIN arch_etl_db.wra_mental_health_assessment mh ON sa.record_id = CAST(mh.record_id AS UNSIGNED)
        JOIN visit v ON (mh.redcap_event_name = v.visit_name AND sa.visit_name = v.visit_alias)
    SET sa.pss_10_tx_score = arch_etl_db.getStressAssessmentScore(mh.wra_mental_health_assessment_id),
        sa.pss10_severity  = arch_etl_db.getStressAssessmentSeverity(
                arch_etl_db.getStressAssessmentScore(mh.wra_mental_health_assessment_id))
    WHERE sa.visit_number = v.visit_number;
    COMMIT;

    -- Operation Summary.
    SELECT COUNT(IF(sa.visit_number = 1.0, 1, NULL)) as 'TX_PSS10_SA_VISIT_1',
           COUNT(IF(sa.visit_number = 3.0, 1, NULL)) as 'TX_PSS10_SA_VISIT_3',
           COUNT(IF(sa.visit_number = 5.0, 1, NULL)) as 'TX_PSS10_SA_VISIT_5'
    FROM arch_etl_db.crt_wra_mh_stress_assessment_overview sa;

END $$

DELIMITER ;
