/**
 * Load FU-2 WRA Food Security.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 22.03.25
 * @since 0.0.1
 * @alias Load WRA Food Security FU-2
 */
DROP PROCEDURE IF EXISTS `Load_WRA_Food_Security_Overview_V3`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_Food_Security_Overview_V3()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load FU-2 WRA Food Security Overview;', @errno, '(',
                              @sqlstate, '):',
                              @text);
            SELECT @full_error;
            RESIGNAL;
        END;
    -- Op matrices
    SET @v_tx_pre_fs_v3 := 0; -- Initial count
    SET @v_tx_pro_fs_v3 := 0; -- After count

    START TRANSACTION;
    SET @v_tx_pre_fs_v3 = (SELECT COUNT(wra_v3.root_id)
                           FROM arch_etl_db.wra_follow_up_visit_2_repeating_instruments wra_v3
                           WHERE wra_v3.scd_comments_yn_f2 IN (0, 1));

    TRUNCATE arch_etl_db.crt_wra_visit_3_food_security_overview;
    INSERT INTO arch_etl_db.crt_wra_visit_3_food_security_overview(record_id,
                                                                   alternate_id,
                                                                   wra_ptid,
                                                                   member_id,
                                                                   screening_id,
                                                                   age,
                                                                   ra,
                                                                   visit_number,
                                                                   visit_name,
                                                                   visit_date)
    SELECT v3.record_id,
           v3.alternate_id,
           v3.wra_ptid,
           v3.member_id,
           v3.screening_id,
           v3.age,
           v3.ra,
           v3.visit_number,
           v3.visit_name,
           v3.visit_date
    FROM crt_wra_visit_3_overview v3
             LEFT JOIN vw_wra_consent_overview ic ON (v3.record_id = ic.record_id AND v3.visit_number = ic.visit_number)
    WHERE v3.visit_outcome = 'Completed'
      AND ic.ongoing_consent_outcome = 'Accepted'
    ORDER BY v3.visit_date, v3.screening_id DESC;

    UPDATE crt_wra_visit_3_food_security_overview fs
        LEFT JOIN arch_etl_db.wra_follow_up_visit_2_repeating_instruments wra_v3 ON (
            fs.record_id = wra_v3.record_id AND fs.alternate_id = wra_v3.wra_follow_up_visit_2_repeating_instruments_id)
    SET fs.no_food_to_eat_last_30_days                       = get_YN_Label(wra_v3.hh_nofd_scorres_f2),
        fs.no_food_to_eat_last_30_days_freq                  = wra_v3.hh_nofd_frq_scorres_f2_label,
        fs.hh_member_slept_hungry_at_night_last_30_days      = get_YN_Label(hh_nofd_sleep_scorres_f2),
        fs.hh_member_slept_hungry_at_night_last_30_days_freq = wra_v3.hh_nofd_sleep_frq_scorres_f2_label,
        fs.hh_member_hungry_day_night_last_30_days           = get_YN_Label(wra_v3.hh_nofd_night_scorres_f2),
        fs.hh_member_hungry_day_night_last_30_days_freq      = wra_v3.hh_nofd_night_frq_scorres_f2_label
    WHERE wra_v3.scd_comments_yn_f2 IS NOT NULL;
    COMMIT;

    -- Process Metrics
    SET @v_tx_pro_fs_v3 = (SELECT COUNT(fs_v3.record_id) FROM crt_wra_visit_3_food_security_overview fs_v3);
    SET @v_load_metrics = CONCAT_WS(' of ', @v_tx_pro_fs_v3, @v_tx_pre_fs_v3);
    SET @v_load_info = CONCAT('WRA-FoodSecurity-V3-Data: LOADING COMPLETE. ', @v_load_metrics);
    SELECT @v_load_info as `|_________________| Operation_Summary |_________________|`;

END $$

DELIMITER ;
