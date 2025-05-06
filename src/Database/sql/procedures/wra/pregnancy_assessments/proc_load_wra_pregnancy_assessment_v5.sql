/**
 * Load FU-4 WRA Pregnancy Assessment.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 14.03.25
 * @since 0.0.1
 * @alias Load WRA Pregnancy Assessment FU-4
 */
DROP PROCEDURE IF EXISTS `Load_WRA_Pregnancy_Assessment_Overview_V5`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_Pregnancy_Assessment_Overview_V5()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load FU-4 WRA Pregnancy Assessment Overview;', @errno, '(',
                              @sqlstate, '):',
                              @text);
            SELECT @full_error;
            RESIGNAL;
        END;
    -- Op matrices
    SET @v_tx_pre_pa_v5 := 0; -- Initial count
    SET @v_tx_pro_pa_v5 := 0; -- After count

    START TRANSACTION;
    TRUNCATE arch_etl_db.crt_wra_visit_5_pregnancy_assessments_overview;
    SET @v_tx_pre_pa_v5 = (SELECT COUNT(pa.root_id) FROM wrafu_pregnancy_assessments_4 pa);
    INSERT INTO arch_etl_db.crt_wra_visit_5_pregnancy_assessments_overview(record_id,
                                                                           wra_ptid,
                                                                           member_id,
                                                                           screening_id,
                                                                           age,
                                                                           ra,
                                                                           visit_number,
                                                                           visit_name,
                                                                           visit_date)
    SELECT v5.record_id,
           v5.wra_ptid,
           v5.member_id,
           v5.screening_id,
           v5.age,
           v5.ra,
           v5.visit_number,
           v5.visit_name,
           v5.visit_date
    FROM crt_wra_visit_5_overview v5
    WHERE v5.record_id IN (SELECT DISTINCT a.record_id
                           FROM wrafu_pregnancy_assessments_4 a
                           WHERE (a.np_fu_zapps_scorres_f4 IS NOT NULL OR a.np_fu_anc_mhyn_f4 IS NOT NULL)
                             AND a.fu_name_veri_f4 IS NOT NULL)
    ORDER BY v5.visit_date DESC;

    UPDATE crt_wra_visit_5_pregnancy_assessments_overview v5
        LEFT JOIN wrafu_pregnancy_assessments_4 pa ON v5.record_id = pa.record_id
        LEFT JOIN crt_wra_point_of_collection_overview poc ON v5.record_id = poc.record_id
        LEFT JOIN wrafu_pregnancy_surveillance_4 ps ON v5.record_id = ps.record_id
    SET v5.visit_date                                 = COALESCE(pa.pa_fu_visit_date_f4, v5.visit_date),
        v5.pregnancy_id                               = poc.pregnancy_id,
        v5.upt_result                                 = IF(poc.upt_result IS NULL OR poc.upt_result = '', NULL,
                                                           poc.upt_result),
        v5.zapps_enrollment_status                    = pa.np_fu_zapps_scorres_f4_label,
        v5.zapps_ptid                                 = useAutoTrimmer(pa.np_fu_zapps_ptid_f4),
        v5.zapps_ptid_source                          = pa.np_fu_zapps_id_src_f4_label,
        v5.pregnancy_identified_by_arch               = IF(pa.np_fu_ident_arch_f4 = 1, 'Yes',
                                                           IF(pa.np_fu_ident_arch_f4 = 0, 'No', pa.np_fu_ident_arch_f4)),
        v5.pregnancy_has_antenatal_care               = IF(pa.np_fu_anc_mhyn_f4 = 1, 'Yes',
                                                           IF(pa.np_fu_anc_mhyn_f4 = 0, 'No', pa.np_fu_anc_mhyn_f4)),
        v5.anc_visit_count                            = CAST(pa.np_fu_anc_num_mh_f4 AS UNSIGNED),
        v5.anc_attendance_plan                        = IF(pa.np_fu_anc_plan_obsloc_f4 = 1, 'Yes',
                                                           IF(pa.np_fu_anc_plan_obsloc_f4 = 0, 'No', NULL)),
        v5.planned_place_for_birth                    = (
            CASE
                WHEN pa.fu_birth_plan_fac_obsloc_f4 = 1 THEN pa.fu_facility_other_f4_label
                WHEN pa.fu_birth_plan_fac_obsloc_f4 = 2 THEN pa.fu_birth_plan_fac_obsloc_f4_label
                WHEN pa.fu_birth_plan_fac_obsloc_f4 = 88 THEN UCASE(useAutoTrimmer(pa.fu_birth_other_loc_f4))
                ELSE NULLIF(pa.np_fu_anc_plan_obsloc_f4, NULL)
                END
            ),

        v5.place_for_birth_planner                    = (
            CASE
                WHEN pa.np_fu_del_decide_scorres_f4 BETWEEN 1 AND 5 THEN pa.np_fu_del_decide_scorres_f4_label
                WHEN pa.fu_birth_plan_fac_obsloc_f4 = 88
                    THEN UCASE(useAutoTrimmer(pa.np_fu_del_decide_scorres_f4_label))
                ELSE NULLIF(pa.np_fu_del_decide_scorres_f4, NULL)
                END
            ),
        v5.alcoholic_consumption_during_pregnancy     = IF(pa.np_fu_alc_suyn_f4 = 1, 'Yes',
                                                           IF(pa.np_fu_alc_suyn_f4 = 0, 'No', pa.np_fu_alc_suyn_f4)),
        v5.alcoholic_consumption_frequency            = pa.np_fu_alc_cons_f4_label,
        v5.tobacco_consumption_during_pregnancy       = IF(pa.np_fu_tob_suyn_f4 = 1, 'Yes',
                                                           IF(pa.np_fu_tob_suyn_f4 = 0, 'No', pa.np_fu_tob_suyn_f4)),
        v5.tobacco_consumption_frequency              = pa.np_fu_tob_curr_sudosfrq_f4_label,
        v5.other_tobacco_consumption_during_pregnancy = use_OtherTobaccoConsumedTransformer_V5(pa.record_id),
        v5.street_drugs_consumption_during_pregnancy  = IF(pa.np_fu_drug_suyn_f4 = 1, 'Yes',
                                                           IF(pa.np_fu_drug_suyn_f4 = 0, 'No', pa.np_fu_drug_suyn_f4)),
        v5.street_drug_consumption_frequency          = pa.np_fu_drug_usage_f4_label,
        v5.drugs_consumed_during_pregnancy            = useOtherDrugsConsumedTransformer_V5(pa.record_id),
        v5.zapps_referral_outcome                     = IF(pa.fu_ref_likely_scorres_f4 = 1, 'Accepted',
                                                           IF(pa.fu_ref_likely_scorres_f4 = 0, 'Declined',
                                                              pa.fu_ref_likely_scorres_f4)),
        v5.zapps_referral_declined_reasons            = use_ZAPPS_RefDeclinedReasonsTransformer_V5(pa.record_id),
        v5.preferred_zapps_clinic                     = pa.zr_fu_pref_zapps_scorres_f4_label,
        v5.preferred_zapps_appointment_date           = pa.zr_fu_apnt_dat_scorres_f4,
        v5.pregnancy_identifier                       = ps.fu_np_pregid_mhyn_f4_label,
        v5.first_positive_upt_date                    = COALESCE(getFirstPositive_UPT_Date_V5(ps.record_id),
                                                                 poc.visit_date, v5.visit_date),
        v5.first_ultra_sound_date                     = use_ISO_DateTrimmer(TRIM(ps.fu_np_us_test_dat_f4)),
        v5.first_ultra_sound_by_edd                   = ps.fu_np_us_edd_dat_f4,
        v5.lmp_date                                   = COALESCE(ps.fu_lmp_scdat_f4, getEstimated_LMP_V5(pa.record_id)),
        v5.ega_by_lmp                                 = getEstimatedGestationalAge_V5(ps.record_id),
        v5.edd_by_ega                                 = getEstimatedDateOfDelivery_V5(pa.record_id),
        v5.zapps_referral_comments                    = pa.zr_fu_comments_f4
    WHERE v5.record_id = pa.record_id
      AND poc.visit_number = v5.visit_number;
    COMMIT;

    -- Process Metrics
    SET @v_tx_pro_pa_v5 = (SELECT COUNT(pa_v5.record_id) FROM crt_wra_visit_5_pregnancy_assessments_overview pa_v5);
    SET @v_load_metrics = CONCAT_WS(' of ', @v_tx_pro_pa_v5, @v_tx_pre_pa_v5);
    SET @v_load_info = CONCAT('WRA-Pregnancy-Assessment-V5-Data: LOADING COMPLETE. ', @v_load_metrics);
    SELECT @v_load_info as `|_________________| Operation_Summary |_________________|`;

END $$

DELIMITER ;
