/**
 * Load FU-1 WRA Pregnancy Surveillance.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 26.01.25
 * @since 0.0.1
 * @alias Load WRA Pregnancy Surveillance FU-1
 */
DROP PROCEDURE IF EXISTS `Load_WRA_Pregnancy_Overview_V1`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_Pregnancy_Overview_V1()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load FU-1 WRA Pregnancy Overview;', @errno, '(', @sqlstate, '):',
                              @text);
            SELECT @full_error;
            RESIGNAL;
        END;
    -- Op matrices
    SET @v_tx_pre_po_v1 := 0; -- Initial count
    SET @v_tx_pro_po_v1 := 0; -- After count

    START TRANSACTION;
    SET @v_tx_pre_po_v1 = (SELECT COUNT(pos.root_id) FROM wra_pregnancy_overview_and_surveillance pos);
    TRUNCATE arch_etl_db.crt_wra_visit_1_pregnancy_overview;
    INSERT INTO arch_etl_db.crt_wra_visit_1_pregnancy_overview(record_id,
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
    ORDER BY v1.visit_date, v1.screening_id DESC;

    UPDATE crt_wra_visit_1_pregnancy_overview v1
        LEFT JOIN wra_pregnancy_overview_and_surveillance pos_v1 ON v1.record_id = pos_v1.record_id
    SET v1.has_pregnancy_hx               = IF(pos_v1.ph_prev_rporres = 1, 'Yes',
                                               IF(pos_v1.ph_prev_rporres = 0, 'No', pos_v1.ph_prev_rporres)),
        v1.pregnancy_count                = pos_v1.pho_num_preg_rporres,
        v1.live_birth_count               = pos_v1.ph_live_rporres,
        v1.loss_count                     = pos_v1.ph_loss_rporres,
        v1.spontaneous_miscarriages_count = pos_v1.ph_bs_rporres,
        v1.still_birth_count              = pos_v1.stlb_num_rporres,
        v1.menstruation_outcome           = IF(pos_v1.lmp_reg_scorres = 1, 'Menstruating',
                                               IF(pos_v1.lmp_reg_scorres = 0, 'Not Menstruating',
                                                  pos_v1.lmp_reg_scorres)),
        v1.no_menstruals_reason           = IF(pos_v1.lmp_kd_scorres = 96,
                                               CONCAT_WS(' - ', 'Other', pos_v1.lmp_kd_scorres_other),
                                               pos_v1.lmp_kd_scorres_label),
        v1.lmp_date                       = pos_v1.lmp_scdat,
        v1.currently_pregnant             = pos_v1.preg_scorres_label,
        v1.pregnancy_identifier           = pos_v1.np_pregid_mhyn_label
    WHERE v1.record_id = pos_v1.record_id;
    COMMIT;

    -- Process Metrics
    SET @v_tx_pro_po_v1 = (SELECT COUNT(po_v1.record_id) FROM crt_wra_visit_1_pregnancy_overview po_v1);
    SET @v_load_metrics = CONCAT_WS(' of ', @v_tx_pro_po_v1, @v_tx_pre_po_v1);
    SET @v_load_info = CONCAT('WRA-Pregnancy-Overview-&-Surveillance-V1-Data: LOADING COMPLETE. ', @v_load_metrics);
    SELECT @v_load_info as `|_________________| Operation_Summary |_________________|`;

END $$

DELIMITER ;
