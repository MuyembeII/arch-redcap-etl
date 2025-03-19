/**
 * Load FU-3 WRA Pregnancy Surveillance.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 12.02.25
 * @since 0.0.1
 * @alias Load WRA Pregnancy Surveillance FU-3
 */
DROP PROCEDURE IF EXISTS `Load_WRA_Pregnancy_Overview_V4`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_Pregnancy_Overview_V4()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load FU-3 WRA Pregnancy Overview;', @errno, '(', @sqlstate, '):',
                              @text);
            SELECT @full_error;
            RESIGNAL;
        END;
    -- Op matrices
    SET @v_tx_pre_po_v4 := 0; -- Initial count
    SET @v_tx_pro_po_v4 := 0; -- After count

    START TRANSACTION;
    SET @v_tx_pre_po_v4 = (SELECT COUNT(ps.root_id) FROM wrafu_pregnancy_surveillance_3 ps);
    TRUNCATE arch_etl_db.crt_wra_visit_4_pregnancy_overview;
    INSERT INTO arch_etl_db.crt_wra_visit_4_pregnancy_overview(record_id,
                                                               wra_ptid,
                                                               member_id,
                                                               screening_id,
                                                               age,
                                                               ra,
                                                               visit_number,
                                                               visit_name,
                                                               visit_date)
    SELECT v4.record_id,
           v4.wra_ptid,
           v4.member_id,
           v4.screening_id,
           v4.age,
           v4.ra,
           v4.visit_number,
           v4.visit_name,
           v4.visit_date
    FROM crt_wra_visit_4_overview v4
    WHERE v4.visit_outcome = 'Completed'
      AND v4.record_id IN (SELECT ps.record_id FROM wrafu_pregnancy_surveillance_3 ps WHERE ps.fu_lmp_reg_scorres_f3 IS NOT NULL)
    ORDER BY v4.visit_date DESC;

    UPDATE crt_wra_visit_4_pregnancy_overview v4
        LEFT JOIN wrafu_pregnancy_surveillance_3 ps_v4 ON v4.record_id = ps_v4.record_id
    SET v4.menstruation_outcome             = IF(ps_v4.fu_lmp_reg_scorres_f3 = 1, 'Menstruating',
                                                 IF(ps_v4.fu_lmp_reg_scorres_f3 = 0, 'Not Menstruating',
                                                    ps_v4.fu_lmp_reg_scorres_f3)),
        v4.no_menstruals_reason             = IF(ps_v4.fu_lmp_kd_scorres_f3 = 96, CONCAT_WS(
                ' - ', 'Other', ps_v4.lmp_kd_scorres_othr_f3), ps_v4.fu_lmp_kd_scorres_f3_label),
        v4.currently_pregnant               = ps_v4.fu_preg_scorres_f3_label,
        v4.pregnancy_identifier             = ps_v4.fu_np_pregid_mhyn_f3_label,
        v4.pregnant_since_last_visit        = IF(ps_v4.ps_preg_last_visit_f3 = 1, 'Yes',
                                                 IF(ps_v4.ps_preg_last_visit_f3 = 0, 'No',
                                                    ps_v4.ps_preg_last_visit_f3)),
        v4.same_pregnancy_since_last_visit  = IF(ps_v4.ps_same_preg_lv_f3 = 1, 'Yes',
                                                 IF(ps_v4.ps_same_preg_lv_f3 = 0, 'No', ps_v4.ps_same_preg_lv_f3)),
        v4.pregnancy_count_since_last_visit = ps_v4.ps_preg_times_f3
    WHERE v4.record_id = ps_v4.record_id;

    UPDATE crt_wra_visit_4_pregnancy_overview v4
        LEFT JOIN crt_wra_visit_3_pregnancy_assessments_overview pa_v3 ON v4.record_id = pa_v3.record_id
        LEFT JOIN crt_wra_point_of_collection_overview poc ON v4.record_id = poc.record_id
    SET v4.last_upt_result             = poc.upt_result,
        v4.last_pregnancy_id           = poc.pregnancy_id,
        v4.last_zapps_referral_outcome = pa_v3.zapps_referral_outcome,
        v4.zapps_enrollment_status     = pa_v3.zapps_enrollment_status,
        v4.zapps_ptid                  = pa_v3.zapps_ptid
    WHERE poc.visit_number = v4.visit_number;
    COMMIT;

    -- Process Metrics
    SET @v_tx_pro_po_v4 = (SELECT COUNT(po_v4.record_id) FROM crt_wra_visit_4_pregnancy_overview po_v4);
    SET @v_load_metrics = CONCAT_WS(' of ', @v_tx_pro_po_v4, @v_tx_pre_po_v4);
    SET @v_load_info = CONCAT('WRA-Surveillance-V4-Data: LOADING COMPLETE. ', @v_load_metrics);
    SELECT @v_load_info as `|_________________| Operation_Summary |_________________|`;

END $$

DELIMITER ;
