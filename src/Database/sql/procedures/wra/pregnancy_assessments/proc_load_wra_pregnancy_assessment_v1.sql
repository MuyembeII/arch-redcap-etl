/**
 * Load WRA Baseline Pregnancy Assessment.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 26.01.25
 * @since 0.0.1
 * @alias Load WRA Pregnancy Assessment Baseline
 */
DROP PROCEDURE IF EXISTS `Load_WRA_Pregnancy_Assessment_Overview_V1`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_Pregnancy_Assessment_Overview_V1()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load WRA Pregnancy Assessment Overview;', @errno, '(',
                              @sqlstate, '):',
                              @text);
            SELECT @full_error;
            RESIGNAL;
        END;
    -- Op matrices
    SET @v_tx_pre_pa_v1 := 0; -- Initial count
    SET @v_tx_pro_pa_v1 := 0; -- After count

    START TRANSACTION;
    TRUNCATE arch_etl_db.crt_wra_visit_1_pregnancy_assessments_overview;
    SET @v_tx_pre_pa_v1 = (SELECT COUNT(pa.root_id) FROM wra_pregnancy_assessments pa);
    INSERT INTO arch_etl_db.crt_wra_visit_1_pregnancy_assessments_overview(record_id,
                                                                           wra_ptid,
                                                                           member_id,
                                                                           screening_id,
                                                                           age,
                                                                           ra,
                                                                           visit_number,
                                                                           visit_name,
                                                                           visit_date)
    SELECT v1.record_id,
           v1.wra_ptid,
           v1.member_id,
           v1.screening_id,
           v1.age,
           v1.ra,
           v1.visit_number,
           v1.visit_name,
           v1.visit_date
    FROM crt_wra_visit_1_overview v1
    WHERE v1.record_id IN (SELECT DISTINCT a.record_id
                           FROM wra_pregnancy_assessments a
                           WHERE (a.np_zapps_scorres IS NOT NULL OR a.np_anc_mhyn IS NOT NULL) AND a.name_veri IS NOT NULL)
    ORDER BY v1.visit_date DESC;

    UPDATE crt_wra_visit_1_pregnancy_assessments_overview v1
        LEFT JOIN wra_pregnancy_assessments pa ON v1.record_id = pa.record_id
        LEFT JOIN crt_wra_point_of_collection_overview poc ON v1.record_id = poc.record_id
    SET v1.visit_date                                = COALESCE(pa.pa_visit_date, v1.visit_date),
        v1.pregnancy_id                              = poc.pregnancy_id,
        v1.zapps_enrollment_status                   = pa.np_zapps_scorres_label,
        v1.zapps_ptid                                = useAutoTrimmer(pa.np_zapps_ptid),
        v1.zapps_ptid_source                         = pa.np_zapps_id_src_label,
        v1.pregnancy_identified_by_arch              = IF(pa.np_ident_arch = 1, 'Yes',
                                                          IF(pa.np_ident_arch = 0, 'No', pa.np_ident_arch)),
        v1.pregnancy_has_antenatal_care              = IF(pa.np_anc_mhyn = 1, 'Yes',
                                                          IF(pa.np_anc_mhyn = 0, 'No', pa.np_anc_mhyn)),
        v1.anc_visit_count                           = CAST(pa.np_anc_num_mh AS UNSIGNED),
        v1.anc_attendance_plan                       = IF(pa.np_anc_plan_obsloc = 1, 'Yes',
                                                          IF(pa.np_anc_plan_obsloc = 0, 'No', pa.np_anc_plan_obsloc)),
        v1.planned_place_for_birth                   = (
            CASE
                WHEN pa.birth_plan_fac_obsloc = 1 THEN pa.facility_other_label
                WHEN pa.birth_plan_fac_obsloc = 2 THEN pa.birth_plan_fac_obsloc_label
                WHEN pa.birth_plan_fac_obsloc = 88 THEN UCASE(useAutoTrimmer(pa.birth_other_loc))
                ELSE NULLIF(pa.np_anc_plan_obsloc, NULL)
                END
            ),

        v1.place_for_birth_planner                   = (
            CASE
                WHEN pa.np_del_decide_scorres BETWEEN 1 AND 5 THEN pa.np_del_decide_scorres_label
                WHEN pa.birth_plan_fac_obsloc = 88 THEN UCASE(useAutoTrimmer(pa.del_decide_spfy_scorres))
                ELSE NULLIF(pa.np_del_decide_scorres, NULL)
                END
            ),
        v1.alcoholic_consumption_during_pregnancy    = IF(pa.np_alc_suyn = 1, 'Yes',
                                                          IF(pa.np_alc_suyn = 0, 'No', pa.np_alc_suyn)),
        v1.alcoholic_consumption_frequency           = pa.np_alc_cons_label,
        v1.tobacco_consumption_during_pregnancy      = IF(pa.np_tob_suyn = 1, 'Yes',
                                                          IF(pa.np_tob_suyn = 0, 'No', pa.np_tob_suyn)),
        v1.tobacco_consumption_frequency             = pa.np_tob_cur_sudosfrq_label,
        v1.street_drugs_consumption_during_pregnancy = IF(pa.np_drug_suyn = 1, 'Yes',
                                                          IF(pa.np_drug_suyn = 0, 'No', pa.np_drug_suyn)),
        v1.street_drug_consumption_frequency         = pa.np_drug_usage_label,
        v1.zapps_referral_acceptance                 = IF(pa.ref_likely_scorres = 1, 'Yes',
                                                          IF(pa.ref_likely_scorres = 0, 'No', pa.ref_likely_scorres)),
        v1.preferred_zapps_clinic                    = pa.pref_zapps_scorres_label
    WHERE v1.record_id = pa.record_id
      AND poc.visit_number = v1.visit_number AND poc.upt_result = 'Positive';
    COMMIT;

    -- Process Metrics
    SET @v_tx_pro_pa_v1 = (SELECT COUNT(pa_v1.record_id) FROM crt_wra_visit_1_pregnancy_assessments_overview pa_v1);
    SET @v_load_metrics = CONCAT_WS(' of ', @v_tx_pro_pa_v1, @v_tx_pre_pa_v1);
    SET @v_load_info = CONCAT('WRA-Pregnancy-Assessment-V1-Data: LOADING COMPLETE. ', @v_load_metrics);
    SELECT @v_load_info as `|_________________| Operation_Summary |_________________|`;

END $$

DELIMITER ;
