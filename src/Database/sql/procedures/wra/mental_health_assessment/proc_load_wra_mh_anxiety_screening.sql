/**
 * Load WRA-MH Generalized Anxiety Disorder - 7 Item. GAD-7 scale is used to
 * screen for GAD in primary care.
 * The WRA PHQ9 is captured bi-annually starting at the baseline visit(1.0),
 * second(3.0) and fourth(5.0) follow-up visit Mental Health(MH) Assessment instruments.
 * @author Gift Jr <muyembegift@gmail.com> | 24.03.25
 * @since 0.0.1
 * @alias Load WRA GAD-7
 * @reference CDISC | https://www.cdisc.org/standards/foundational/qrs/generalized-anxiety-disorder-7-item
 */
DROP PROCEDURE IF EXISTS `Load_WRA_MH_AnxietyScreening`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_MH_AnxietyScreening()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to run proc; [Load_WRA_MH_AnxietyScreening]', @errno, '(',
                              @sqlstate,
                              '):',
                              @text);
            SELECT @full_error;
            RESIGNAL;
        END;
    -- Op matrices
    SET @v_tx_pre_as := 0; -- Initial count
    SET @v_tx_pro_as := 0; -- After count

    START TRANSACTION;
    TRUNCATE arch_etl_db.crt_wra_mh_anxiety_screening_overview;
    SET @v_tx_pre_as = (SELECT COUNT(anx.root_id)
                        FROM wra_mental_health_assessment anx
                        WHERE anx.anx_1 IN (0, 1, 2, 3, 4));

    INSERT INTO arch_etl_db.crt_wra_mh_anxiety_screening_overview(mh_anxiety_severity_id,
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
    WITH gad7_v1_anxiety_screening AS (SELECT mh.wra_mental_health_assessment_id                 as mh_anxiety_severity_id,
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
         gad7_v3_anxiety_screening AS (SELECT mh.wra_mental_health_assessment_id                 as mh_anxiety_severity_id,
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
         gad7_v5_anxiety_screening AS (SELECT mh.wra_mental_health_assessment_id                 as mh_anxiety_severity_id,
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
        ((SELECT * FROM gad7_v1_anxiety_screening)
         UNION
         (SELECT * FROM gad7_v3_anxiety_screening)
         UNION
         (SELECT * FROM gad7_v5_anxiety_screening));

    -- update common table overviews using source meta data from the Mental Health (MH) Assessment
    -- instrument by WRA Visit.
    UPDATE crt_wra_mh_anxiety_screening_overview anx
        LEFT JOIN wra_mental_health_assessment mh ON anx.record_id = CAST(mh.record_id AS UNSIGNED)
        JOIN visit v ON (mh.redcap_event_name = v.visit_name AND anx.visit_name = v.visit_alias)
    SET anx.mh_anxiety_severity_id = mh.wra_mental_health_assessment_id,
        anx.ra                     = mh.anx_interviewer_obsloc,
        anx.visit_date             = COALESCE(mh.anx_visit_date, anx.visit_date)
    WHERE anx.visit_name = v.visit_name;

    -- GAD-7 Test
    UPDATE crt_wra_mh_anxiety_screening_overview anx
        LEFT JOIN wra_mental_health_assessment mh ON anx.record_id = CAST(mh.record_id AS UNSIGNED)
        JOIN visit v ON (mh.redcap_event_name = v.visit_name AND anx.visit_name = v.visit_alias)
    SET anx.anxiety_problem_1 = mh.anx_1_label,
        anx.anxiety_problem_2 = mh.anx_2_label,
        anx.anxiety_problem_3 = mh.anx_3_label,
        anx.anxiety_problem_4 = mh.anx_4_label,
        anx.anxiety_problem_5 = mh.anx_5_label,
        anx.anxiety_problem_6 = mh.anx_6_label,
        anx.anxiety_problem_7 = mh.anx_7_label,
        anx.comments          = mh.anx_comments
    WHERE anx.visit_number = v.visit_number;
    -- GAD-7 Scoring
    UPDATE crt_wra_mh_anxiety_screening_overview anx
        LEFT JOIN wra_mental_health_assessment mh ON anx.record_id = CAST(mh.record_id AS UNSIGNED)
        JOIN visit v ON (mh.redcap_event_name = v.visit_name AND anx.visit_name = v.visit_alias)
    SET anx.gad_7_tx_score         = getAnxietyScreeningScore(mh.wra_mental_health_assessment_id),
        anx.gad_7_anxiety_severity = getAnxietyScreeningSeverity(getAnxietyScreeningScore(mh.wra_mental_health_assessment_id))
    WHERE anx.visit_number = v.visit_number;
    COMMIT;

    -- Operation Summary.
    SELECT COUNT(IF(anx.visit_number = 1.0, 1, NULL)) as 'TX_VISIT_1',
           COUNT(IF(anx.visit_number = 3.0, 1, NULL)) as 'TX_VISIT_3',
           COUNT(IF(anx.visit_number = 5.0, 1, NULL)) as 'TX_VISIT_5'
    FROM crt_wra_mh_anxiety_screening_overview anx;

END $$

DELIMITER ;
