/**
 * Load WRA-MH Patient Health Questionnaire - 9 (PHQ-9). PHQ-9 provides a
 * reliable and valid measure of depression severity and also yields a DSM-IV
 * criteria based diagnosis of a depressive disorder.
 * The WRA PHQ9 is captured bi-annually starting at the baseline visit(1.0),
 * second(3.0) and fourth(5.0) follow-up visit Mental Health(MH) Assessment instruments.
 * @author Gift Jr <muyembegift@gmail.com> | 24.03.25
 * @since 0.0.1
 * @alias Load WRA PHQ9
 * @reference CDISC | https://www.cdisc.org/standards/foundational/qrs/patient-health-questionnaire-9
 */
DROP PROCEDURE IF EXISTS `Load_WRA_MH_DepressionScreening`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_MH_DepressionScreening()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to run proc; [Load_WRA_MH_Depression_Screening]', @errno, '(',
                              @sqlstate,
                              '):',
                              @text);
            SELECT @full_error;
            RESIGNAL;
        END;
    -- Op matrices
    SET @v_tx_pre_ds := 0; -- Initial count
    SET @v_tx_pro_ds := 0; -- After count

    START TRANSACTION;
    TRUNCATE arch_etl_db.crt_wra_mh_depression_screening_overview;
    SET @v_tx_pre_ds = (SELECT COUNT(ds.root_id)
                        FROM wra_mental_health_assessment ds
                        WHERE ds.phq9_interest_scorres IN (0, 1, 2, 3, 4));

    INSERT INTO arch_etl_db.crt_wra_mh_depression_screening_overview(mh_depression_severity_id,
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
    WITH phq9_v1_depression_screening AS (SELECT mh.wra_mental_health_assessment_id                 as mh_depression_severity_id,
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
                                                   LEFT JOIN wra_mental_health_assessment mh
                                                             ON v1.record_id = CAST(mh.record_id AS UNSIGNED)
                                          WHERE mh.redcap_event_name = 'wra_baseline_arm_1'
                                          ORDER BY v1.visit_date, v1.screening_id DESC),
         phq9_v3_depression_screening AS (SELECT mh.wra_mental_health_assessment_id                 as mh_depression_severity_id,
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
                                          WHERE mh.redcap_event_name = 'wra_followup_visit_arm_1b'
                                          ORDER BY v3.visit_date, v3.screening_id DESC),
         phq9_v5_depression_screening AS (SELECT mh.wra_mental_health_assessment_id                 as mh_depression_severity_id,
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
                                          WHERE mh.redcap_event_name = 'wra_followup_visit_arm_1d'
                                          ORDER BY v5.visit_date, v5.screening_id DESC)
         -- Combine the expressed MH datasets for v1, v3 and v5
        ((SELECT * FROM phq9_v1_depression_screening)
         UNION
         (SELECT * FROM phq9_v3_depression_screening)
         UNION
         (SELECT * FROM phq9_v5_depression_screening));

    -- update common table overviews using source meta data from the Mental Health (MH) Assessment instrument
    UPDATE crt_wra_mh_depression_screening_overview ds
        LEFT JOIN wra_mental_health_assessment mh ON ds.record_id = CAST(mh.record_id AS UNSIGNED)
        JOIN visit v ON mh.redcap_event_name = v.visit_name
    SET ds.mh_depression_severity_id = mh.wra_mental_health_assessment_id,
        ds.ra                        = mh.anx_interviewer_obsloc,
        ds.visit_date                = COALESCE(mh.mh_visit_date, mh.anx_visit_date, ds.visit_date)
    WHERE ds.visit_name = v.visit_name;

    -- PHQ9 Test
    UPDATE crt_wra_mh_depression_screening_overview ds
        LEFT JOIN wra_mental_health_assessment mh ON ds.record_id = mh.record_id
    SET ds.patient_health_problem_1  = mh.phq9_interest_scorres_label,
        ds.patient_health_problem_1  = mh.phq9_interest_scorres_label,
        ds.patient_health_problem_2  = mh.phq9_dprs_scorres_label,
        ds.patient_health_problem_3  = mh.phq9_sleep_scorres_label,
        ds.patient_health_problem_4  = mh.phq9_tired_scorres_label,
        ds.patient_health_problem_5  = mh.phq9_app_scorres_label,
        ds.patient_health_problem_6  = mh.phq9_bad_scorres_label,
        ds.patient_health_problem_7  = mh.phq9_conc_scorres_label,
        ds.patient_health_problem_8  = mh.phq9_slow_scorres_label,
        ds.patient_health_problem_9  = mh.phq9_hurt_scorres_label,
        ds.patient_health_problem_10 = (
            CASE mh.phq9_difficult_scorres
                WHEN 0 THEN 'Not difficult at all'
                WHEN 1 THEN 'Somewhat difficult'
                WHEN 2 THEN 'Very difficult'
                WHEN 3 THEN 'Extremely difficult'
                ELSE mh.phq9_difficult_scorres_label
                END
            )
    WHERE mh.phq9_interest_scorres IS NOT NULL;
    -- PHQ9 Score
    UPDATE crt_wra_mh_depression_screening_overview ds
        LEFT JOIN wra_mental_health_assessment mh ON ds.record_id = mh.record_id
    SET ds.phq_9_tx_score            = getDepressionScreeningScore(mh.wra_mental_health_assessment_id),
        ds.phq_9_depression_severity = getDepressionScreeningSeverity(getDepressionScreeningScore(mh.wra_mental_health_assessment_id))
    WHERE mh.phq9_interest_scorres IS NOT NULL;
    COMMIT;

    -- Operation Summary.
    SELECT COUNT(IF(ds.visit_number = 1.0, 1, NULL)) as 'TX_VISIT_1',
           COUNT(IF(ds.visit_number = 3.0, 1, NULL)) as 'TX_VISIT_3',
           COUNT(IF(ds.visit_number = 5.0, 1, NULL)) as 'TX_VISIT_5'
    FROM crt_wra_mh_depression_screening_overview ds;

END $$

DELIMITER ;
