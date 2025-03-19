/**
 * Load FU-5 WRA Pregnancy Surveillance.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 12.02.25
 * @since 0.0.1
 * @alias Load WRA Pregnancy Surveillance FU-5
 */
DROP PROCEDURE IF EXISTS `Load_WRA_Pregnancy_Overview_V6`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_Pregnancy_Overview_V6()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load FU-5 WRA Pregnancy Overview;', @errno, '(', @sqlstate, '):',
                              @text);
            SELECT @full_error;
            RESIGNAL;
        END;
    -- Op matrices
    SET @v_tx_pre_po_v6 := 0; -- Initial count
    SET @v_tx_pro_po_v6 := 0; -- After count

    START TRANSACTION;
    SET @v_tx_pre_po_v6 = (SELECT COUNT(ps.root_id) FROM wrafu_pregnancy_surveillance_6 ps);
    TRUNCATE arch_etl_db.crt_wra_visit_6_pregnancy_overview;
    INSERT INTO arch_etl_db.crt_wra_visit_6_pregnancy_overview(record_id,
                                                               wra_ptid,
                                                               member_id,
                                                               screening_id,
                                                               age,
                                                               ra,
                                                               visit_number,
                                                               visit_name,
                                                               visit_date)
    SELECT v6.record_id,
           v6.wra_ptid,
           v6.member_id,
           v6.screening_id,
           v6.age,
           v6.ra,
           v6.visit_number,
           v6.visit_name,
           v6.visit_date
    FROM crt_wra_visit_6_overview v6
    WHERE v6.visit_outcome = 'Completed'
      AND v6.record_id IN (SELECT ps.record_id FROM wrafu_pregnancy_surveillance_4 ps WHERE ps.fu_lmp_reg_scorres_f4 IS NOT NULL)
    ORDER BY v6.visit_date DESC;

    UPDATE crt_wra_visit_6_pregnancy_overview v6
        LEFT JOIN wrafu_pregnancy_surveillance_6 ps_v6 ON v6.record_id = ps_v6.record_id
    SET v6.menstruation_outcome             = IF(ps_v6.fu_lmp_reg_scorres_f5 = 1, 'Menstruating',
                                                 IF(ps_v6.fu_lmp_reg_scorres_f5 = 0, 'Not Menstruating',
                                                    ps_v6.fu_lmp_reg_scorres_f5)),
        v6.no_menstruals_reason             = IF(ps_v6.fu_lmp_kd_scorres_f5 = 96, CONCAT_WS(
                ' - ', 'Other', ps_v6.lmp_kd_scorres_othr_f5), ps_v6.fu_lmp_kd_scorres_f5_label),
        v6.currently_pregnant               = ps_v6.fu_preg_scorres_f5_label,
        v6.pregnancy_identifier             = ps_v6.fu_np_pregid_mhyn_f5_label,
        v6.pregnant_since_last_visit        = IF(ps_v6.ps_preg_last_visit_f5 = 1, 'Yes',
                                                 IF(ps_v6.ps_preg_last_visit_f5 = 0, 'No',
                                                    ps_v6.ps_preg_last_visit_f5)),
        v6.same_pregnancy_since_last_visit  = IF(ps_v6.ps_same_preg_lv_f5 = 1, 'Yes',
                                                 IF(ps_v6.ps_same_preg_lv_f5 = 0, 'No', ps_v6.ps_same_preg_lv_f5)),
        v6.pregnancy_count_since_last_visit = ps_v6.ps_preg_times_f5
    WHERE v6.record_id = ps_v6.record_id;

    UPDATE crt_wra_visit_6_pregnancy_overview v6
        LEFT JOIN crt_wra_visit_5_pregnancy_assessments_overview pa_v5 ON v6.record_id = pa_v5.record_id
        LEFT JOIN crt_wra_point_of_collection_overview poc ON v6.record_id = poc.record_id
    SET v6.last_upt_result             = poc.upt_result,
        v6.last_pregnancy_id           = poc.pregnancy_id,
        v6.last_zapps_referral_outcome = pa_v5.zapps_referral_outcome,
        v6.zapps_enrollment_status     = pa_v5.zapps_enrollment_status,
        v6.zapps_ptid                  = pa_v5.zapps_ptid
    WHERE poc.visit_number = v6.visit_number;
    COMMIT;

    -- Process Metrics
    SET @v_tx_pro_po_v6 = (SELECT COUNT(po_v6.record_id) FROM crt_wra_visit_6_pregnancy_overview po_v6);
    SET @v_load_metrics = CONCAT_WS(' of ', @v_tx_pro_po_v6, @v_tx_pre_po_v6);
    SET @v_load_info = CONCAT('WRA-Surveillance-V6-Data: LOADING COMPLETE. ', @v_load_metrics);
    SELECT @v_load_info as `|_________________| Operation_Summary |_________________|`;

END $$

DELIMITER ;
