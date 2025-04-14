/**
 * Load FU-4 WRA Pregnancy Surveillance.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 12.02.25
 * @since 0.0.1
 * @alias Load WRA Pregnancy Surveillance FU-4
 */
DROP PROCEDURE IF EXISTS `Load_WRA_Pregnancy_Overview_V5`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_Pregnancy_Overview_V5()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load FU-4 WRA Pregnancy Overview;', @errno, '(', @sqlstate, '):',
                              @text);
            SELECT @full_error;
            RESIGNAL;
        END;
    -- Op matrices
    SET @v_tx_pre_po_v5 := 0; -- Initial count
    SET @v_tx_pro_po_v5 := 0; -- After count

    START TRANSACTION;
    SET @v_tx_pre_po_v5 = (SELECT COUNT(ps.root_id) FROM wrafu_pregnancy_surveillance_4 ps);
    TRUNCATE arch_etl_db.crt_wra_visit_5_pregnancy_overview;
    INSERT INTO arch_etl_db.crt_wra_visit_5_pregnancy_overview(record_id,
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
    WHERE v5.visit_outcome = 'Completed'
      AND v5.record_id IN
          (SELECT ps.record_id FROM wrafu_pregnancy_surveillance_4 ps WHERE ps.fu_lmp_reg_scorres_f4 IS NOT NULL)
    ORDER BY v5.visit_date DESC;

    UPDATE crt_wra_visit_5_pregnancy_overview v5
        LEFT JOIN wrafu_pregnancy_surveillance_4 ps_v5 ON v5.record_id = ps_v5.record_id
    SET v5.menstruation_outcome             = IF(ps_v5.fu_lmp_reg_scorres_f4 = 1, 'Menstruating',
                                                 IF(ps_v5.fu_lmp_reg_scorres_f4 = 0, 'Not Menstruating',
                                                    ps_v5.fu_lmp_reg_scorres_f4)),
        v5.no_menstruals_reason             = IF(ps_v5.fu_lmp_kd_scorres_f4 = 96, CONCAT_WS(
                ' - ', 'Other', ps_v5.lmp_kd_scorres_othr_f4), ps_v5.fu_lmp_kd_scorres_f4_label),
        v5.currently_pregnant               = ps_v5.fu_preg_scorres_f4_label,
        v5.lmp_date                         = ps_v5.fu_lmp_scdat_f4,
        v5.estimated_lmp                    = CASE ps_v5.fu_lmp_cat_scorres_f4
                                                  WHEN 0 THEN ps_v5.fu_lmp_start_weeks_f4
                                                  WHEN 1 THEN ps_v5.fu_lmp_start_months_f4
                                                  WHEN 2 THEN ps_v5.fu_lmp_start_years_f4 END,
        v5.estimated_lmp_flag               = CASE ps_v5.fu_lmp_cat_scorres_f4
                                                  WHEN 0 THEN 'week(s)'
                                                  WHEN 1 THEN 'month(s)'
                                                  WHEN 2 THEN 'year(s)' END,
        v5.pregnancy_identifier             = ps_v5.fu_np_pregid_mhyn_f4_label,
        v5.pregnant_since_last_visit        = IF(ps_v5.ps_preg_last_visit_f4 = 1, 'Yes',
                                                 IF(ps_v5.ps_preg_last_visit_f4 = 0, 'No',
                                                    ps_v5.ps_preg_last_visit_f4)),
        v5.same_pregnancy_since_last_visit  = IF(ps_v5.ps_same_preg_lv_f4 = 1, 'Yes',
                                                 IF(ps_v5.ps_same_preg_lv_f4 = 0, 'No', ps_v5.ps_same_preg_lv_f4)),
        v5.pregnancy_count_since_last_visit = ps_v5.ps_preg_times_f4
    WHERE v5.record_id = ps_v5.record_id;

    UPDATE crt_wra_visit_5_pregnancy_overview v5
        LEFT JOIN crt_wra_visit_4_pregnancy_assessments_overview pa_v4 ON v5.record_id = pa_v4.record_id
        LEFT JOIN crt_wra_point_of_collection_overview poc ON v5.record_id = poc.record_id
    SET v5.last_upt_result             = poc.upt_result,
        v5.last_pregnancy_id           = poc.pregnancy_id,
        v5.last_zapps_referral_outcome = pa_v4.zapps_referral_outcome,
        v5.zapps_enrollment_status     = pa_v4.zapps_enrollment_status,
        v5.zapps_ptid                  = pa_v4.zapps_ptid
    WHERE poc.visit_number = v5.visit_number;
    COMMIT;

    -- Process Metrics
    SET @v_tx_pro_po_v5 = (SELECT COUNT(po_v5.record_id) FROM crt_wra_visit_5_pregnancy_overview po_v5);
    SET @v_load_metrics = CONCAT_WS(' of ', @v_tx_pro_po_v5, @v_tx_pre_po_v5);
    SET @v_load_info = CONCAT('WRA-Surveillance-V5-Data: LOADING COMPLETE. ', @v_load_metrics);
    SELECT @v_load_info as `|_________________| Operation_Summary |_________________|`;

END $$

DELIMITER ;
