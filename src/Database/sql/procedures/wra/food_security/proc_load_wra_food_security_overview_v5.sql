/**
 * Load FU-4 WRA Food Security.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 22.03.25
 * @since 0.0.1
 * @alias Load WRA Food Security FU-4
 */
DROP PROCEDURE IF EXISTS `Load_WRA_Food_Security_Overview_V5`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_Food_Security_Overview_V5()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load FU-4 WRA Food Security Overview;', @errno, '(',
                              @sqlstate, '):',
                              @text);
            SELECT @full_error;
            RESIGNAL;
        END;
    -- Op matrices
    SET @v_tx_pre_fs_v5 := 0; -- Initial count
    SET @v_tx_pro_fs_v5 := 0; -- After count

    START TRANSACTION;
    SET @v_tx_pre_fs_v5 = (SELECT COUNT(wra_v5.root_id)
                           FROM arch_etl_db.wra_follow_up_visit_4_repeating_instruments wra_v5
                           WHERE wra_v5.fu_scd_comments_yn_f4 IN (0, 1));

    TRUNCATE arch_etl_db.crt_wra_visit_5_food_security_overview;
    INSERT INTO arch_etl_db.crt_wra_visit_5_food_security_overview(record_id,
                                                                   alternate_id,
                                                                   wra_ptid,
                                                                   member_id,
                                                                   screening_id,
                                                                   age,
                                                                   ra,
                                                                   visit_number,
                                                                   visit_name,
                                                                   visit_date)
    SELECT v5.record_id,
           v5.alternate_id,
           v5.wra_ptid,
           v5.member_id,
           v5.screening_id,
           v5.age,
           v5.ra,
           v5.visit_number,
           v5.visit_name,
           v5.visit_date
    FROM arch_etl_db.crt_wra_visit_5_overview v5
             LEFT JOIN arch_etl_db.vw_wra_consent_overview ic
                       ON (v5.record_id = ic.record_id AND v5.visit_number = ic.visit_number)
    WHERE v5.visit_outcome = 'Completed'
      AND ic.ongoing_consent_outcome = 'Accepted'
    ORDER BY v5.visit_date, v5.screening_id DESC;

    UPDATE arch_etl_db.crt_wra_visit_5_food_security_overview fs
        LEFT JOIN arch_etl_db.wra_follow_up_visit_4_repeating_instruments wra_v5 ON fs.record_id = wra_v5.record_id
    SET fs.no_food_to_eat_last_30_days                       = get_YN_Label(wra_v5.fu_hh_nofd_scorres_f4),
        fs.no_food_to_eat_last_30_days_freq                  = wra_v5.fu_hh_nofd_frq_scorres_f4_label,
        fs.hh_member_slept_hungry_at_night_last_30_days      = get_YN_Label(fu_hh_nofd_sleep_scorres_f4),
        fs.hh_member_slept_hungry_at_night_last_30_days_freq = wra_v5.fu_hh_nofd_sleep_frq_f4_label,
        fs.hh_member_hungry_day_night_last_30_days           = get_YN_Label(wra_v5.fu_hh_nofd_night_scorres_f4),
        fs.hh_member_hungry_day_night_last_30_days_freq      = wra_v5.fu_hh_nofd_night_frq_f4_label
    WHERE wra_v5.fu_scd_comments_yn_f4 IS NOT NULL;
    COMMIT;

    -- Process Metrics
    SET @v_tx_pro_fs_v5 = (SELECT COUNT(fs_v5.record_id) FROM arch_etl_db.crt_wra_visit_5_food_security_overview fs_v5);
    SET @v_load_metrics = CONCAT_WS(' of ', @v_tx_pro_fs_v5, @v_tx_pre_fs_v5);
    SET @v_load_info = CONCAT('WRA-FoodSecurity-V5-Data: LOADING COMPLETE. ', @v_load_metrics);
    SELECT @v_load_info as `|_________________| Operation_Summary |_________________|`;

END $$

DELIMITER ;
