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

    START TRANSACTION;
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
    GROUP BY v1.visit_date, v1.screening_id
    ORDER BY v1.visit_date DESC;

    UPDATE crt_wra_visit_1_pregnancy_overview v1
        LEFT JOIN wra_pregnancy_overview_and_surveillance pos_v1 ON v1.record_id = pos_v1.record_id
    SET v1.has_pregnancy_hx               = IF(pos_v1.ph_prev_rporres = 1, 'Yes',
                                               IF(pos_v1.ph_prev_rporres = 0, 'No', pos_v1.ph_prev_rporres)),
        v1.pregnancy_count                = pos_v1.pho_num_preg_rporres,
        v1.live_birth_count               = pos_v1.ph_live_rporres,
        v1.loss_count                     = pos_v1.pho_loss_count,
        v1.spontaneous_miscarriages_count = pos_v1.ph_bs_rporres,
        v1.still_birth_count              = pos_v1.stlb_num_rporres,
        v1.has_menstruals                 = IF(pos_v1.lmp_reg_scorres = 1, 'Yes',
                                               IF(pos_v1.lmp_reg_scorres = 0, 'No', pos_v1.lmp_reg_scorres)),
        v1.no_menstruals_reason           = IF(pos_v1.lmp_kd_scorres = 96,
                                               CONCAT_WS(' - ', 'Other', pos_v1.lmp_kd_scorres_other),
                                               pos_v1.lmp_kd_scorres_label),
        v1.currently_pregnant             = pos_v1.preg_scorres_label,
        v1.pregnancy_identifier           = pos_v1.np_pregid_mhyn_label
    WHERE v1.record_id = pos_v1.record_id;
    COMMIT;

    -- flag completion
    SELECT 'Pregnancy-Surv-Data loader completed successfully.' as `status`;

END $$

DELIMITER ;
