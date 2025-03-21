/**
 * Load FU-5 WRA Socio-Demographics.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 20.03.25
 * @since 0.0.1
 * @alias Load WRA Socio-Demographics FU-5
 */
DROP PROCEDURE IF EXISTS `Load_WRA_SocioDemographics_Overview_V6`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_SocioDemographics_Overview_V6()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load FU-5 WRA Socio-Demographics Overview;', @errno, '(',
                              @sqlstate, '):',
                              @text);
            SELECT @full_error;
            RESIGNAL;
        END;
    -- Op matrices
    SET @v_tx_pre_sd_v6 := 0; -- Initial count
    SET @v_tx_pro_sd_v6 := 0; -- After count

    START TRANSACTION;
    SET @v_tx_pre_sd_v6 = (SELECT COUNT(wra_v6.root_id)
                           FROM wra_follow_up_visit_5_repeating_instruments wra_v6
                           WHERE wra_v6.fu_covid_scrn_comments_yn_f5 IN (0, 1));

    TRUNCATE arch_etl_db.crt_wra_visit_6_socio_demographics_overview;
    INSERT INTO arch_etl_db.crt_wra_visit_6_socio_demographics_overview(record_id,
                                                                        alternate_id,
                                                                        wra_ptid,
                                                                        member_id,
                                                                        screening_id,
                                                                        age,
                                                                        ra,
                                                                        visit_number,
                                                                        visit_name,
                                                                        visit_date)
    SELECT v6.record_id,
           v6.alternate_id,
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
      AND v6.record_id IN
          (SELECT f5.record_id FROM wra_follow_up_visit_5_repeating_instruments f5 WHERE f5.fu_scdmar_scorres_f5 <> '')
    ORDER BY v6.visit_date, v6.screening_id DESC;


    UPDATE crt_wra_visit_6_socio_demographics_overview sd
        INNER JOIN wra_follow_up_visit_5_repeating_instruments wra_v6 ON sd.record_id = wra_v6.record_id
    SET sd.marital_status                   = wra_v6.fu_scdmar_scorres_f5_label,
        sd.marriage_age                     = wra_v6.scd_fu_agemar_scorres_f5,
        sd.attended_school                  = get_YN_Label(wra_v6.fu_school_scorres_f5),
        sd.highest_education_level          = wra_v6.fu_sd_highest_edu_level_f5_label,
        sd.tx_school_years_attended         = wra_v6.fu_school_yrs_scorres_f5,
        sd.has_occupation_income            = get_YN_Label(wra_v6.fu_scd_occupation_scorres_f5),
        sd.approx_income_pay                = REGEXP_REPLACE(wra_v6.fu_sd_approx_income_pay_f5, '[[:space:]]+', ' '),
        sd.mobile_phone_accessibility       = wra_v6.fu_scd_mobile_fcorres_f5_label,
        sd.smoke_cigarettes_cigar_pipe      = get_YN_Label(wra_v6.fu_scd_mh_tob_suyn_f5),
        sd.smoke_cigarettes_cigar_pipe_freq = wra_v6.fu_scd_mh_tob_sudosfrq_f5_label,
        sd.chewed_tobacco_last_month        = get_YN_Label(wra_v6.fu_scd_tob_chew_sutrt_f5),
        sd.consumed_alcohol_last_month      = get_YN_Label(wra_v6.fu_scd_alc_suyn_f5)
    WHERE wra_v6.fu_scdmar_scorres_f5 <> ''
       OR wra_v6.fu_scdmar_scorres_f5 IS NOT NULL;

    UPDATE crt_wra_visit_6_socio_demographics_overview sd_v6
    SET sd_v6.approx_income_pay = useCurrencyTrimmer(sd_v6.approx_income_pay)
    WHERE MATCH(approx_income_pay) AGAINST('+K' IN BOOLEAN MODE);

    UPDATE crt_wra_visit_6_socio_demographics_overview sd_v6
    SET sd_v6.approx_income_pay = REPLACE(REPLACE(REPLACE(approx_income_pay, 'K', ''), 'k', ''), 'Kk', '')
    WHERE sd_v6.has_occupation_income = 'Yes';

    UPDATE crt_wra_visit_6_socio_demographics_overview sd_v6
    SET sd_v6.approx_income_pay = REPLACE(approx_income_pay, ',', '')
    WHERE sd_v6.has_occupation_income = 'Yes';

    UPDATE crt_wra_visit_6_socio_demographics_overview sd_v6
    SET sd_v6.approx_income_pay = CAST(sd_v6.approx_income_pay AS DECIMAL(12, 2))
    WHERE sd_v6.approx_income_pay REGEXP '^[[:digit:]]+$';
    COMMIT;

    -- Process Metrics
    SET @v_tx_pro_sd_v6 = (SELECT COUNT(sd_v6.record_id) FROM crt_wra_visit_6_socio_demographics_overview sd_v6);
    SET @v_load_metrics = CONCAT_WS(' of ', @v_tx_pro_sd_v6, @v_tx_pre_sd_v6);
    SET @v_load_info = CONCAT('WRA-SocioDemographics-V5-Data: LOADING COMPLETE. ', @v_load_metrics);
    SELECT @v_load_info as `|_________________| Operation_Summary |_________________|`;

END $$

DELIMITER ;
