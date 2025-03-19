/**
 * Load Baseline WRA Socio-Demographics.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 19.03.25
 * @since 0.0.1
 * @alias Load WRA Socio-Demographics Baseline
 */
DROP PROCEDURE IF EXISTS `Load_WRA_SocioDemographics_Overview_V1`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_SocioDemographics_Overview_V1()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load Baseline WRA Socio-Demographics Overview;', @errno, '(',
                              @sqlstate, '):',
                              @text);
            SELECT @full_error;
            RESIGNAL;
        END;
    -- Op matrices
    SET @v_tx_pre_sd_v1 := 0; -- Initial count
    SET @v_tx_pro_sd_v1 := 0; -- After count

    START TRANSACTION;
    SET @v_tx_pre_sd_v1 = (SELECT COUNT(wra_v1.root_id)
                           FROM wra_forms_repeating_instruments wra_v1
                           WHERE wra_v1.loc_comments_yn IN (0, 1));

    TRUNCATE arch_etl_db.crt_wra_visit_1_socio_demographics_overview;
    INSERT INTO arch_etl_db.crt_wra_visit_1_socio_demographics_overview(record_id,
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
    ORDER BY v1.visit_date, v1.screening_id DESC;

    UPDATE crt_wra_visit_1_socio_demographics_overview sd
        LEFT JOIN wra_forms_repeating_instruments wra_v1 ON sd.alternate_id = wra_v1.wra_forms_repeating_instruments_id
    SET sd.marital_status                   = wra_v1.scdmar_scorres_label,
        sd.marriage_age                     = wra_v1.scd_agemar_scorres,
        sd.attended_school                  = get_YN_Label(wra_v1.school_scorres),
        sd.highest_education_level          = wra_v1.sd_highest_edu_level_label,
        sd.tx_school_years_attended         = wra_v1.school_yrs_scorres,
        sd.has_occupation_income            = get_YN_Label(wra_v1.scd_occupation_scorres),
        sd.approx_income_pay                = REGEXP_REPLACE(wra_v1.sd_approx_income_pay, '[[:space:]]+', ' '),
        sd.mobile_phone_accessibility       = wra_v1.scd_mobile_fcorres_label,
        sd.smoke_cigarettes_cigar_pipe      = get_YN_Label(wra_v1.scd_mh_tob_suyn),
        sd.smoke_cigarettes_cigar_pipe_freq = wra_v1.scd_mh_tob_sudosfrq_label,
        sd.chewed_tobacco_last_month        = get_YN_Label(wra_v1.scd_tob_chew_sutrt),
        sd.consumed_alcohol_last_month      = get_YN_Label(wra_v1.scd_alc_suyn)
    WHERE sd.record_id = wra_v1.record_id
      AND wra_v1.loc_comments_yn IN (0, 1);

    UPDATE crt_wra_visit_1_socio_demographics_overview sd_v1
    SET sd_v1.approx_income_pay   = useCurrencyTrimmer(sd_v1.approx_income_pay)
    WHERE MATCH (approx_income_pay) AGAINST ('+K' IN BOOLEAN MODE);

    UPDATE crt_wra_visit_1_socio_demographics_overview sd_v1
    SET sd_v1.approx_income_pay   = REPLACE(REPLACE(REPLACE(approx_income_pay, 'K', ''), 'k', ''), 'Kk', '')
    WHERE sd_v1.has_occupation_income = 'Yes';

    UPDATE crt_wra_visit_1_socio_demographics_overview sd_v1
    SET sd_v1.approx_income_pay   = CAST(sd_v1.approx_income_pay AS DECIMAL(12,2))
    WHERE sd_v1.approx_income_pay REGEXP '^[[:digit:]]+$';

    COMMIT;

    -- Process Metrics
    SET @v_tx_pro_sd_v1 = (SELECT COUNT(sd_v1.record_id) FROM crt_wra_visit_1_socio_demographics_overview sd_v1);
    SET @v_load_metrics = CONCAT_WS(' of ', @v_tx_pro_sd_v1, @v_tx_pre_sd_v1);
    SET @v_load_info = CONCAT('WRA-SocioDemographics-V1-Data: LOADING COMPLETE. ', @v_load_metrics);
    SELECT @v_load_info as `|_________________| Operation_Summary |_________________|`;

END $$

DELIMITER ;
