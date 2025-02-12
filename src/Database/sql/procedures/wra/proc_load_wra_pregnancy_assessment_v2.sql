/**
 * Load FU-1 WRA Pregnancy Assessment.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 12.02.25
 * @since 0.0.1
 * @alias Load WRA Pregnancy Assessment FU-1
 */
DROP PROCEDURE IF EXISTS `Load_WRA_Pregnancy_Assessment_Overview_V2`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_Pregnancy_Assessment_Overview_V2()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load FU-1 WRA Pregnancy Assessment Overview;', @errno, '(',
                              @sqlstate, '):',
                              @text);
            SELECT @full_error;
            RESIGNAL;
        END;

    START TRANSACTION;
    TRUNCATE arch_etl_db.crt_wra_visit_2_pregnancy_assessments_overview;
    INSERT INTO arch_etl_db.crt_wra_visit_2_pregnancy_assessments_overview(record_id,
                                                                           wra_ptid,
                                                                           member_id,
                                                                           screening_id,
                                                                           age,
                                                                           ra,
                                                                           visit_number,
                                                                           visit_name,
                                                                           visit_date)
    SELECT v2.record_id,
           v2.wra_ptid,
           v2.member_id,
           v2.screening_id,
           v2.age,
           v2.ra,
           v2.visit_number,
           v2.visit_name,
           v2.visit_date
    FROM crt_wra_visit_2_overview v2
    WHERE v2.record_id IN (SELECT DISTINCT a.record_id
                           FROM wrafu_pregnancy_assessments a
                           WHERE (a.np_fu_zapps_scorres IS NOT NULL OR a.np_fu_anc_mhyn IS NOT NULL) AND a.fu_name_veri IS NOT NULL)
    GROUP BY v2.visit_date, v2.screening_id
    ORDER BY v2.visit_date DESC;

    UPDATE crt_wra_visit_2_pregnancy_assessments_overview v2
        LEFT JOIN wrafu_pregnancy_assessments pa ON v2.record_id = pa.record_id
        LEFT JOIN crt_wra_point_of_collection_overview poc ON v2.record_id = poc.record_id
    SET v2.visit_date                                = COALESCE(pa.pa_fu_visit_date, v2.visit_date),
        v2.pregnancy_id                              = poc.pregnancy_id,
        v2.zapps_enrollment_status                   = pa.np_fu_zapps_scorres_label,
        v2.zapps_ptid                                = useAutoTrimmer(pa.np_fu_zapps_ptid),
        v2.zapps_ptid_source                         = pa.np_fu_zapps_id_src_label,
        v2.pregnancy_identified_by_arch              = IF(pa.np_fu_ident_arch = 1, 'Yes',
                                                          IF(pa.np_fu_ident_arch = 0, 'No', pa.np_fu_ident_arch)),
        v2.pregnancy_has_antenatal_care              = IF(pa.np_fu_anc_mhyn = 1, 'Yes',
                                                          IF(pa.np_fu_anc_mhyn = 0, 'No', pa.np_fu_anc_mhyn)),
        v2.anc_visit_count                           = CAST(pa.np_fu_anc_num_mh AS UNSIGNED),
        v2.anc_attendance_plan                       = np_fu_anc_plan_obsloc_label,
        v2.planned_place_for_birth                   = (
            CASE
                WHEN pa.fu_birth_plan_fac_obsloc = 1 THEN pa.fu_facility_other_label
                WHEN pa.fu_birth_plan_fac_obsloc = 2 THEN pa.fu_birth_plan_fac_obsloc_label
                WHEN pa.fu_birth_plan_fac_obsloc = 88 THEN UCASE(useAutoTrimmer(pa.fu_birth_other_loc))
                ELSE NULLIF(pa.np_fu_anc_plan_obsloc, NULL)
                END
            ),

        v2.place_for_birth_planner                   = (
            CASE
                WHEN pa.np_fu_del_decide_scorres BETWEEN 1 AND 5 THEN pa.np_fu_del_decide_scorres_label
                WHEN pa.fu_birth_plan_fac_obsloc = 88 THEN UCASE(useAutoTrimmer(pa.fu_del_decide_spfy_scorres))
                ELSE NULLIF(pa.np_fu_del_decide_scorres, NULL)
                END
            ),
        v2.alcoholic_consumption_during_pregnancy    = IF(pa.np_fu_alc_suyn = 1, 'Yes',
                                                          IF(pa.np_fu_alc_suyn = 0, 'No', pa.np_fu_alc_suyn)),
        v2.alcoholic_consumption_frequency           = pa.np_fu_alc_cons_label,
        v2.tobacco_consumption_during_pregnancy      = IF(pa.np_fu_tob_suyn = 1, 'Yes',
                                                          IF(pa.np_fu_tob_suyn = 0, 'No', pa.np_fu_tob_suyn)),
        v2.tobacco_consumption_frequency             = pa.np_fu_tob_curr_sudosfrq_label,
        v2.street_drugs_consumption_during_pregnancy = IF(pa.np_fu_drug_suyn = 1, 'Yes',
                                                          IF(pa.np_fu_drug_suyn = 0, 'No', pa.np_fu_drug_suyn)),
        v2.street_drug_consumption_frequency         = pa.np_fu_drug_usage_label,
        v2.zapps_referral_acceptance                 = IF(pa.fu_ref_likely_scorres = 1, 'Yes',
                                                          IF(pa.fu_ref_likely_scorres = 0, 'No', pa.fu_ref_likely_scorres)),
        v2.preferred_zapps_clinic                    = pa.zr_fu_pref_zapps_scorres_label
    WHERE v2.record_id = pa.record_id
      AND poc.visit_number = v2.visit_number AND poc.upt_result = 'Positive';
    COMMIT;

    -- flag completion
    SELECT 'WRA FU-1 Pregnancy-Assessment-Data loader completed successfully.' as `status`;

END $$

DELIMITER ;
