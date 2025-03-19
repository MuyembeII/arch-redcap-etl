/**
 * Load FU-2 WRA Pregnancy Surveillance.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 12.02.25
 * @since 0.0.1
 * @alias Load WRA Pregnancy Surveillance FU-2
 */
DROP PROCEDURE IF EXISTS `Load_WRA_Pregnancy_Overview_V3`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_Pregnancy_Overview_V3()
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
    -- Op matrices
    SET @v_tx_pre_po_v3 := 0; -- Initial count
    SET @v_tx_pro_po_v3 := 0; -- After count

    START TRANSACTION;
    SET @v_tx_pre_po_v3 = (SELECT COUNT(ps.root_id) FROM wrafu_pregnancy_surveillance_2 ps);
    TRUNCATE arch_etl_db.crt_wra_visit_3_pregnancy_overview;
    INSERT INTO arch_etl_db.crt_wra_visit_3_pregnancy_overview(record_id,
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
    WHERE v3.visit_outcome = 'Completed'
      AND v3.record_id IN (SELECT ps.record_id FROM wrafu_pregnancy_surveillance_2 ps WHERE ps.fu_lmp_reg_scorres_f2 IS NOT NULL)
    ORDER BY v3.visit_date DESC;

    UPDATE crt_wra_visit_3_pregnancy_overview v3
        LEFT JOIN wrafu_pregnancy_surveillance_2 ps_v3 ON v3.record_id = ps_v3.record_id
    SET v3.menstruation_outcome                   = IF(ps_v3.fu_lmp_reg_scorres_f2 = 1, 'Menstruating',
                                                 IF(ps_v3.fu_lmp_reg_scorres_f2 = 0, 'Not Menstruating', ps_v3.fu_lmp_reg_scorres_f2)),
        v3.no_menstruals_reason             = IF(ps_v3.fu_lmp_kd_scorres_f2 = 96, CONCAT_WS(
                ' - ', 'Other', ps_v3.lmp_kd_scorres_othr_f2), ps_v3.fu_lmp_kd_scorres_f2_label),
        v3.currently_pregnant               = ps_v3.fu_preg_scorres_f2_label,
        v3.pregnancy_identifier             = ps_v3.fu_np_pregid_mhyn_f2_label,
        v3.pregnant_since_last_visit        = IF(ps_v3.ps_preg_last_visit_f2 = 1, 'Yes',
                                                 IF(ps_v3.ps_preg_last_visit_f2 = 0, 'No', ps_v3.ps_preg_last_visit_f2)),
        v3.same_pregnancy_since_last_visit  = IF(ps_v3.ps_same_preg_lv_f2 = 1, 'Yes',
                                                 IF(ps_v3.ps_same_preg_lv_f2 = 0, 'No', ps_v3.ps_same_preg_lv_f2)),
        v3.pregnancy_count_since_last_visit = ps_v3.ps_preg_times_f2
    WHERE v3.record_id = ps_v3.record_id;

    UPDATE crt_wra_visit_3_pregnancy_overview v3
        LEFT JOIN crt_wra_visit_2_pregnancy_assessments_overview pa_v2 ON v3.record_id = pa_v2.record_id
        LEFT JOIN crt_wra_point_of_collection_overview poc ON v3.record_id = poc.record_id
    SET v3.last_upt_result             = poc.upt_result,
        v3.last_pregnancy_id           = poc.pregnancy_id,
        v3.last_zapps_referral_outcome = pa_v2.zapps_referral_outcome,
        v3.zapps_enrollment_status = pa_v2.zapps_enrollment_status,
        v3.zapps_ptid              = pa_v2.zapps_ptid
    WHERE poc.visit_number = 3.0;

    COMMIT;

    -- Process Metrics
    SET @v_tx_pro_po_v3 = (SELECT COUNT(po_v3.record_id) FROM crt_wra_visit_3_pregnancy_overview po_v3);
    SET @v_load_metrics = CONCAT_WS(' of ', @v_tx_pro_po_v3, @v_tx_pre_po_v3);
    SET @v_load_info = CONCAT('WRA-Surveillance-V3-Data: LOADING COMPLETE. ', @v_load_metrics);
    SELECT @v_load_info as `|_________________| Operation_Summary |_________________|`;

END $$

DELIMITER ;
