/**
 * Load FU-1 WRA Food Security.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 22.03.25
 * @since 0.0.1
 * @alias Load WRA Food Security FU-1
 */
DROP PROCEDURE IF EXISTS `Load_WRA_Food_Security_Overview_V2`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_Food_Security_Overview_V2()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load FU-1 WRA Food Security Overview;', @errno, '(',
                              @sqlstate, '):',
                              @text);
            SELECT @full_error;
            RESIGNAL;
        END;
    -- Op matrices
    SET @v_tx_pre_fs_v2 := 0; -- Initial count
    SET @v_tx_pro_fs_v2 := 0; -- After count

    START TRANSACTION;
    SET @v_tx_pre_fs_v2 = (SELECT COUNT(wra_v2.root_id)
                           FROM wra_follow_up_visit_repeating_instruments wra_v2
                           WHERE wra_v2.fu_scd_comments_yn IN (0, 1));

    TRUNCATE arch_etl_db.crt_wra_visit_2_food_security_overview;
    INSERT INTO arch_etl_db.crt_wra_visit_2_food_security_overview(record_id,
                                                                   alternate_id,
                                                                   wra_ptid,
                                                                   member_id,
                                                                   screening_id,
                                                                   age,
                                                                   ra,
                                                                   visit_number,
                                                                   visit_name,
                                                                   visit_date)
    SELECT v2.record_id,
           v2.alternate_id,
           v2.wra_ptid,
           v2.member_id,
           v2.screening_id,
           v2.age,
           v2.ra,
           v2.visit_number,
           v2.visit_name,
           v2.visit_date
    FROM crt_wra_visit_2_overview v2
             LEFT JOIN vw_wra_consent_overview ic ON (v2.record_id = ic.record_id AND v2.visit_number = ic.visit_number)
    WHERE v2.visit_outcome = 'Completed'
      AND ic.ongoing_consent_outcome = 'Accepted'
    ORDER BY v2.visit_date, v2.screening_id DESC;

    UPDATE crt_wra_visit_2_food_security_overview fs
        LEFT JOIN wra_follow_up_visit_repeating_instruments wra_v2 ON (
            fs.record_id = wra_v2.record_id AND fs.alternate_id = wra_v2.wra_follow_up_visit_repeating_instruments_id)
    SET fs.no_food_to_eat_last_30_days                       = get_YN_Label(wra_v2.fu_hh_nofd_scorres),
        fs.no_food_to_eat_last_30_days_freq                  = wra_v2.fu_hh_nofd_frq_scorres_label,
        fs.hh_member_slept_hungry_at_night_last_30_days      = get_YN_Label(fu_hh_nofd_sleep_scorres),
        fs.hh_member_slept_hungry_at_night_last_30_days_freq = wra_v2.fu_hh_nofd_sleep_frq_label,
        fs.hh_member_hungry_day_night_last_30_days           = get_YN_Label(wra_v2.fu_hh_nofd_night_scorres),
        fs.hh_member_hungry_day_night_last_30_days_freq      = wra_v2.fu_hh_nofd_night_frq_label
    WHERE wra_v2.fu_scd_comments_yn IS NOT NULL;
    COMMIT;

    -- Process Metrics
    SET @v_tx_pro_fs_v2 = (SELECT COUNT(fs_v2.record_id) FROM crt_wra_visit_2_food_security_overview fs_v2);
    SET @v_load_metrics = CONCAT_WS(' of ', @v_tx_pro_fs_v2, @v_tx_pre_fs_v2);
    SET @v_load_info = CONCAT('WRA-FoodSecurity-V2-Data: LOADING COMPLETE. ', @v_load_metrics);
    SELECT @v_load_info as `|_________________| Operation_Summary |_________________|`;

END $$

DELIMITER ;
