/**
 * Load FU-2 WRA Pregnancy Assessment.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 14.03.25
 * @since 0.0.1
 * @alias Load WRA Pregnancy Assessment FU-2
 */
DROP PROCEDURE IF EXISTS `Load_WRA_Pregnancy_Assessment_Overview_V3`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_Pregnancy_Assessment_Overview_V3()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load FU-2 WRA Pregnancy Assessment Overview;', @errno, '(',
                              @sqlstate, '):',
                              @text);
            SELECT @full_error;
            RESIGNAL;
        END;
    -- Op matrices
    SET @v_tx_pre_pa_v3 := 0; -- Initial count
    SET @v_tx_pro_pa_v3 := 0; -- After count

    START TRANSACTION;
    TRUNCATE arch_etl_db.crt_wra_visit_3_pregnancy_assessments_overview;
    SET @v_tx_pre_pa_v3 = (SELECT COUNT(pa.root_id) FROM wrafu_pregnancy_assessments_2 pa);
    INSERT INTO arch_etl_db.crt_wra_visit_3_pregnancy_assessments_overview(record_id,
                                                                           wra_ptid,
                                                                           member_id,
                                                                           screening_id,
                                                                           age,
                                                                           ra,
                                                                           visit_number,
                                                                           visit_name,
                                                                           visit_date)
    SELECT v3.record_id,
           v3.wra_ptid,
           v3.member_id,
           v3.screening_id,
           v3.age,
           v3.ra,
           v3.visit_number,
           v3.visit_name,
           v3.visit_date
    FROM crt_wra_visit_3_overview v3
    WHERE v3.record_id IN (SELECT DISTINCT a.record_id
                           FROM wrafu_pregnancy_assessments_2 a
                           WHERE (a.np_fu_zapps_scorres_f2 IS NOT NULL OR a.np_fu_anc_mhyn_f2 IS NOT NULL)
                             AND a.fu_name_veri_f2 IS NOT NULL)
    ORDER BY v3.visit_date DESC;

    UPDATE crt_wra_visit_3_pregnancy_assessments_overview v3
        LEFT JOIN wrafu_pregnancy_assessments_2 pa ON v3.record_id = pa.record_id
        LEFT JOIN crt_wra_point_of_collection_overview poc ON v3.record_id = poc.record_id
        LEFT JOIN wrafu_pregnancy_surveillance_2 ps ON v3.record_id = ps.record_id
    SET v3.visit_date                                 = COALESCE(pa.pa_fu_visit_date_f2, v3.visit_date),
        v3.pregnancy_id                               = poc.pregnancy_id,
        v3.upt_result                                 = IF(poc.upt_result IS NULL OR poc.upt_result = '', NULL,
                                                           poc.upt_result),
        v3.zapps_enrollment_status                    = pa.np_fu_zapps_scorres_f2_label,
        v3.zapps_ptid                                 = useAutoTrimmer(pa.np_fu_zapps_ptid_f2),
        v3.zapps_ptid_source                          = pa.np_fu_zapps_id_src_f2_label,
        v3.pregnancy_identified_by_arch               = IF(pa.np_fu_ident_arch_f2 = 1, 'Yes',
                                                           IF(pa.np_fu_ident_arch_f2 = 0, 'No', pa.np_fu_ident_arch_f2)),
        v3.pregnancy_has_antenatal_care               = IF(pa.np_fu_anc_mhyn_f2 = 1, 'Yes',
                                                           IF(pa.np_fu_anc_mhyn_f2 = 0, 'No', pa.np_fu_anc_mhyn_f2)),
        v3.anc_visit_count                            = CAST(pa.np_fu_anc_num_mh_f2 AS UNSIGNED),
        v3.anc_attendance_plan                        = IF(pa.np_fu_anc_plan_obsloc_f2 = 1, 'Yes',
                                                           IF(pa.np_fu_anc_plan_obsloc_f2 = 0, 'No', NULL)),
        v3.planned_place_for_birth                    = (
            CASE
                WHEN pa.fu_birth_plan_fac_obsloc_f2 = 1 THEN pa.fu_facility_other_f2_label
                WHEN pa.fu_birth_plan_fac_obsloc_f2 = 2 THEN pa.fu_birth_plan_fac_obsloc_f2_label
                WHEN pa.fu_birth_plan_fac_obsloc_f2 = 88 THEN UCASE(useAutoTrimmer(pa.fu_birth_other_loc_f2))
                ELSE NULLIF(pa.np_fu_anc_plan_obsloc_f2, NULL)
                END
            ),

        v3.place_for_birth_planner                    = (
            CASE
                WHEN pa.np_fu_del_decide_scorres_f2 BETWEEN 1 AND 5 THEN pa.np_fu_del_decide_scorres_f2_label
                WHEN pa.fu_birth_plan_fac_obsloc_f2 = 88
                    THEN UCASE(useAutoTrimmer(pa.np_fu_del_decide_scorres_f2_label))
                ELSE NULLIF(pa.np_fu_del_decide_scorres_f2, NULL)
                END
            ),
        v3.alcoholic_consumption_during_pregnancy     = IF(pa.np_fu_alc_suyn_f2 = 1, 'Yes',
                                                           IF(pa.np_fu_alc_suyn_f2 = 0, 'No', pa.np_fu_alc_suyn_f2)),
        v3.alcoholic_consumption_frequency            = pa.np_fu_alc_cons_f2_label,
        v3.tobacco_consumption_during_pregnancy       = IF(pa.np_fu_tob_suyn_f2 = 1, 'Yes',
                                                           IF(pa.np_fu_tob_suyn_f2 = 0, 'No', pa.np_fu_tob_suyn_f2)),
        v3.tobacco_consumption_frequency              = pa.np_fu_tob_curr_sudosfrq_f2_label,
        v3.other_tobacco_consumption_during_pregnancy = use_OtherTobaccoConsumedTransformer_V3(pa.record_id),
        v3.street_drugs_consumption_during_pregnancy  = IF(pa.np_fu_drug_suyn_f2 = 1, 'Yes',
                                                           IF(pa.np_fu_drug_suyn_f2 = 0, 'No', pa.np_fu_drug_suyn_f2)),
        v3.street_drug_consumption_frequency          = pa.np_fu_drug_usage_f2_label,
        v3.drugs_consumed_during_pregnancy            = useOtherDrugsConsumedTransformer_V3(pa.record_id),
        v3.zapps_referral_outcome                     = IF(pa.fu_ref_likely_scorres_f2 = 1, 'Accepted',
                                                           IF(pa.fu_ref_likely_scorres_f2 = 0, 'Declined',
                                                              pa.fu_ref_likely_scorres_f2)),
        v3.zapps_referral_declined_reasons            = use_ZAPPS_RefDeclinedReasonsTransformer_V3(pa.record_id),
        v3.preferred_zapps_clinic                     = pa.zr_fu_pref_zapps_scorres_f2_label,
        v3.preferred_zapps_appointment_date           = pa.zr_fu_apnt_dat_scorres_f2,
        v3.pregnancy_identifier                       = ps.fu_np_pregid_mhyn_f2,
        v3.first_positive_upt_date                    = COALESCE(getFirstPositive_UPT_Date_V3(ps.record_id),
                                                                 poc.visit_date, v3.visit_date),
        v3.first_ultra_sound_date                     = use_ISO_DateTrimmer(TRIM(ps.fu_np_us_test_dat_f2)),
        v3.first_ultra_sound_by_edd                   = ps.fu_np_us_edd_dat_f2,
        v3.lmp_date                                   = COALESCE(ps.fu_lmp_scdat_f2, getEstimated_LMP_V3(pa.record_id)),
        v3.ega_by_lmp                                 = getEstimatedGestationalAge_V3(ps.record_id),
        v3.edd_by_ega                                 = getEstimatedDateOfDelivery_V3(pa.record_id),
        v3.zapps_referral_comments                    = pa.zr_fu_comments_f2
    WHERE v3.record_id = pa.record_id
      AND poc.visit_number = v3.visit_number;
    COMMIT;

    -- Process Metrics
    SET @v_tx_pro_pa_v3 = (SELECT COUNT(pa_v3.record_id) FROM crt_wra_visit_3_pregnancy_assessments_overview pa_v3);
    SET @v_load_metrics = CONCAT_WS(' of ', @v_tx_pro_pa_v3, @v_tx_pre_pa_v3);
    SET @v_load_info = CONCAT('WRA-Pregnancy-Assessment-V3-Data: LOADING COMPLETE. ', @v_load_metrics);
    SELECT @v_load_info as `|_________________| Operation_Summary |_________________|`;

END $$

DELIMITER ;
