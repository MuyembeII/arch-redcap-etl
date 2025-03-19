/**
 * Load FU-1 WRA Socio-Demographics.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 19.03.25
 * @since 0.0.1
 * @alias Load WRA Socio-Demographics FU-1
 */
DROP PROCEDURE IF EXISTS `Load_WRA_SocioDemographics_Overview_V2`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_SocioDemographics_Overview_V2()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load FU-1 WRA Socio-Demographics Overview;', @errno, '(',
                              @sqlstate, '):',
                              @text);
            SELECT @full_error;
            RESIGNAL;
        END;
    -- Op matrices
    SET @v_tx_pre_sd_v2 := 0; -- Initial count
    SET @v_tx_pro_sd_v2 := 0; -- After count

    START TRANSACTION;
    SET @v_tx_pre_sd_v2 = (SELECT COUNT(wra_v2.root_id)
                           FROM wra_follow_up_visit_repeating_instruments wra_v2
                           WHERE wra_v2.fu_covid_scrn_comments_yn IN (0, 1));

    TRUNCATE arch_etl_db.crt_wra_visit_2_socio_demographics_overview;
    INSERT INTO arch_etl_db.crt_wra_visit_2_socio_demographics_overview(record_id,
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
    ORDER BY v2.visit_date, v2.screening_id DESC;


    UPDATE crt_wra_visit_2_socio_demographics_overview sd
        LEFT JOIN wra_follow_up_visit_repeating_instruments wra_v2 ON sd.alternate_id = wra_v2.wra_follow_up_visit_repeating_instruments_id
    SET sd.marital_status                   = wra_v2.fu_scdmar_scorres_label,
        sd.marriage_age                     = wra_v2.scd_fu_agemar_scorres,
        sd.attended_school                  = get_YN_Label(wra_v2.fu_school_scorres),
        sd.highest_education_level          = wra_v2.fu_sd_highest_edu_level_label,
        sd.tx_school_years_attended         = wra_v2.fu_school_yrs_scorres,
        sd.has_occupation_income            = get_YN_Label(wra_v2.fu_scd_occupation_scorres),
        sd.approx_income_pay                = REGEXP_REPLACE(wra_v2.fu_sd_approx_income_pay, '[[:space:]]+', ' '),
        sd.mobile_phone_accessibility       = wra_v2.fu_scd_mobile_fcorres_label,
        sd.smoke_cigarettes_cigar_pipe      = get_YN_Label(wra_v2.fu_scd_mh_tob_suyn),
        sd.smoke_cigarettes_cigar_pipe_freq = wra_v2.fu_scd_mh_tob_sudosfrq_label,
        sd.chewed_tobacco_last_month        = get_YN_Label(wra_v2.fu_scd_tob_chew_sutrt),
        sd.consumed_alcohol_last_month      = get_YN_Label(wra_v2.fu_scd_alc_suyn)
    WHERE sd.record_id = wra_v2.record_id
      AND wra_v2.fu_covid_scrn_comments_yn IN (0, 1);

    UPDATE crt_wra_visit_2_socio_demographics_overview sd_v2
    SET sd_v2.approx_income_pay = useCurrencyTrimmer(sd_v2.approx_income_pay)
    WHERE MATCH (approx_income_pay) AGAINST ('+K' IN BOOLEAN MODE);

    UPDATE crt_wra_visit_2_socio_demographics_overview sd_v2
    SET sd_v2.approx_income_pay = REPLACE(REPLACE(REPLACE(approx_income_pay, 'K', ''), 'k', ''), 'Kk', '')
    WHERE sd_v2.has_occupation_income = 'Yes';

    UPDATE crt_wra_visit_2_socio_demographics_overview sd_v2
    SET sd_v2.approx_income_pay = CAST(sd_v2.approx_income_pay AS DECIMAL(12, 2))
    WHERE sd_v2.approx_income_pay REGEXP '^[[:digit:]]+$';
    COMMIT;

    -- Process Metrics
    SET @v_tx_pro_sd_v2 = (SELECT COUNT(sd_v2.record_id) FROM crt_wra_visit_2_socio_demographics_overview sd_v2);
    SET @v_load_metrics = CONCAT_WS(' of ', @v_tx_pro_sd_v2, @v_tx_pre_sd_v2);
    SET @v_load_info = CONCAT('WRA-SocioDemographics-V2-Data: LOADING COMPLETE. ', @v_load_metrics);
    SELECT @v_load_info as `|_________________| Operation_Summary |_________________|`;

END $$

DELIMITER ;
