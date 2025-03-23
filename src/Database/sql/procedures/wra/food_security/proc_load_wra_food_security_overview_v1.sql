/**
 * Load Baseline WRA Food Security.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 21.03.25
 * @since 0.0.1
 * @alias Load WRA Food Security Baseline
 */
DROP PROCEDURE IF EXISTS `Load_WRA_Food_Security_Overview_V1`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_Food_Security_Overview_V1()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load Baseline WRA Food Security Overview;', @errno, '(',
                              @sqlstate, '):',
                              @text);
            SELECT @full_error;
            RESIGNAL;
        END;
    -- Op matrices
    SET @v_tx_pre_fs_v1 := 0; -- Initial count
    SET @v_tx_pro_fs_v1 := 0; -- After count

    START TRANSACTION;
    SET @v_tx_pre_fs_v1 = (SELECT COUNT(wra_v1.root_id)
                           FROM wra_forms_repeating_instruments wra_v1
                           WHERE wra_v1.air_pol_comm_yn IN (0, 1));

    TRUNCATE arch_etl_db.crt_wra_visit_1_food_security_overview;
    INSERT INTO arch_etl_db.crt_wra_visit_1_food_security_overview(record_id,
                                                                   alternate_id,
                                                                   wra_ptid,
                                                                   member_id,
                                                                   screening_id,
                                                                   age,
                                                                   ra,
                                                                   visit_number,
                                                                   visit_name,
                                                                   visit_date)
    SELECT v1.record_id,
           v1.alternate_id,
           v1.wra_ptid,
           v1.member_id,
           v1.screening_id,
           v1.age,
           v1.ra,
           v1.visit_number,
           v1.visit_name,
           v1.visit_date
    FROM crt_wra_visit_1_overview v1
    WHERE v1.record_id IN
          (SELECT bsl.record_id FROM wra_forms_repeating_instruments bsl WHERE bsl.air_pol_comm_yn IS NOT NULL)
    ORDER BY v1.visit_date, v1.screening_id DESC;

    UPDATE crt_wra_visit_1_food_security_overview fs
        LEFT JOIN wra_forms_repeating_instruments wra_v1 ON fs.record_id = wra_v1.record_id
    SET fs.no_food_to_eat_last_30_days                       = get_YN_Label(wra_v1.hh_nofd_scorres),
        fs.no_food_to_eat_last_30_days_freq                  = wra_v1.hh_nofd_frq_scorres_label,
        fs.hh_member_slept_hungry_at_night_last_30_days      = get_YN_Label(hh_nofd_sleep_scorres),
        fs.hh_member_slept_hungry_at_night_last_30_days_freq = wra_v1.hh_nofd_sleep_frq_scorres_label,
        fs.hh_member_hungry_day_night_last_30_days           = get_YN_Label(wra_v1.hh_nofd_night_scorres),
        fs.hh_member_hungry_day_night_last_30_days_freq      = wra_v1.hh_nofd_night_frq_scorres_label
    WHERE wra_v1.air_pol_comm_yn IN (0, 1);
    COMMIT;

    -- Process Metrics
    SET @v_tx_pro_fs_v1 = (SELECT COUNT(fs_v1.record_id) FROM crt_wra_visit_1_food_security_overview fs_v1);
    SET @v_load_metrics = CONCAT_WS(' of ', @v_tx_pro_fs_v1, @v_tx_pre_fs_v1);
    SET @v_load_info = CONCAT('WRA-FoodSecurity-V1-Data: LOADING COMPLETE. ', @v_load_metrics);
    SELECT @v_load_info as `|_________________| Operation_Summary |_________________|`;

END $$

DELIMITER ;
