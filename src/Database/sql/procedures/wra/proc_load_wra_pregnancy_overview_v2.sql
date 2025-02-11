/**
 * Load FU-2 WRA Pregnancy Surveillance.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 26.01.25
 * @since 0.0.1
 * @alias Load WRA Pregnancy Surveillance FU-2
 */
DROP PROCEDURE IF EXISTS `Load_WRA_Pregnancy_Overview_V2`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_Pregnancy_Overview_V2()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load FU-2 WRA Pregnancy Overview;', @errno, '(', @sqlstate, '):',
                              @text);
            SELECT @full_error;
            RESIGNAL;
        END;

    START TRANSACTION;
    TRUNCATE arch_etl_db.crt_wra_visit_2_pregnancy_overview;
    INSERT INTO arch_etl_db.crt_wra_visit_2_pregnancy_overview(record_id,
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
    WHERE v2.visit_outcome = 'Completed'
    GROUP BY v2.visit_date, v2.screening_id
    ORDER BY v2.visit_date DESC;

    UPDATE crt_wra_visit_2_pregnancy_overview v2
        LEFT JOIN wrafu_pregnancy_surveillance ps_v2 ON v2.record_id = ps_v2.record_id
    SET v2.has_menstruals                   = IF(ps_v2.fu_lmp_reg_scorres = 1, 'Yes',
                                                 IF(ps_v2.fu_lmp_reg_scorres = 0, 'No', ps_v2.fu_lmp_reg_scorres)),
        v2.no_menstruals_reason             = IF(ps_v2.fu_lmp_kd_scorres = 96, CONCAT_WS(
                ' - ', 'Other', ps_v2.lmp_kd_scorres_othr), ps_v2.fu_lmp_kd_scorres_label),
        v2.currently_pregnant               = ps_v2.fu_preg_scorres_label,
        v2.pregnancy_identifier             = ps_v2.fu_np_pregid_mhyn_label,
        v2.pregnant_since_last_visit        = IF(ps_v2.ps_preg_last_visit = 1, 'Yes',
                                                 IF(ps_v2.ps_preg_last_visit = 0, 'No', ps_v2.ps_preg_last_visit)),
        v2.same_pregnancy_since_last_visit  = IF(ps_v2.ps_same_preg_lv = 1, 'Yes',
                                                 IF(ps_v2.ps_same_preg_lv = 0, 'No', ps_v2.ps_same_preg_lv)),
        v2.pregnancy_count_since_last_visit = ps_v2.ps_preg_times
    WHERE v2.record_id = ps_v2.record_id;

    UPDATE crt_wra_visit_2_pregnancy_overview v2
        LEFT JOIN crt_wra_visit_1_pregnancy_assessments_overview pa_v1 ON v2.record_id = pa_v1.record_id
        LEFT JOIN crt_wra_point_of_collection_overview poc ON v2.record_id = poc.record_id
    SET v2.last_upt_result             = poc.upt_result,
        v2.last_pregnancy_id           = poc.pregnancy_id,
        v2.last_zapps_referral_outcome = IF(pa_v1.zapps_referral_acceptance = 'Yes', 'Accepted',
                                            IF(pa_v1.zapps_referral_acceptance = 'No', 'Not Accepted', NULL)),
        v2.zapps_enrollment_status = pa_v1.zapps_enrollment_status,
        v2.zapps_ptid              = pa_v1.zapps_ptid
    WHERE poc.visit_number = 1.0;

    COMMIT;

    -- flag completion
    SELECT 'Pregnancy-Surv-Data V2 loader completed successfully.' as `status`;

END $$

DELIMITER ;
