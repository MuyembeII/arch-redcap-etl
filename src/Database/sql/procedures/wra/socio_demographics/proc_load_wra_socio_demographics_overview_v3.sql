/**
 * Load FU-2 WRA Socio-Demographics.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 19.03.25
 * @since 0.0.1
 * @alias Load WRA Socio-Demographics FU-2
 */
DROP PROCEDURE IF EXISTS `Load_WRA_SocioDemographics_Overview_V3`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_SocioDemographics_Overview_V3()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load FU-2 WRA Socio-Demographics Overview;', @errno, '(',
                              @sqlstate, '):',
                              @text);
            SELECT @full_error;
            RESIGNAL;
        END;
    -- Op matrices
    SET @v_tx_pre_sd_v3 := 0; -- Initial count
    SET @v_tx_pro_sd_v3 := 0; -- After count

    START TRANSACTION;
    SET @v_tx_pre_sd_v3 = (SELECT COUNT(wra_v3.root_id)
                           FROM wra_follow_up_visit_2_repeating_instruments wra_v3
                           WHERE wra_v3.covid_scrn_comments_yn_f2 IN (0, 1));

    TRUNCATE arch_etl_db.crt_wra_visit_3_socio_demographics_overview;
    INSERT INTO arch_etl_db.crt_wra_visit_3_socio_demographics_overview(record_id,
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
    WHERE v3.visit_outcome = 'Completed'
      AND v3.record_id IN
          (SELECT f5.record_id FROM wra_follow_up_visit_2_repeating_instruments f5 WHERE f5.scdmar_scorres_f2 <> '')
    ORDER BY v3.visit_date, v3.screening_id DESC;


    UPDATE crt_wra_visit_3_socio_demographics_overview sd
        LEFT JOIN wra_follow_up_visit_2_repeating_instruments wra_v3 ON sd.record_id = wra_v3.record_id
    SET sd.marital_status                   = wra_v3.scdmar_scorres_f2_label,
        sd.marriage_age                     = wra_v3.scd_agemar_scorres_f2,
        sd.attended_school                  = get_YN_Label(wra_v3.school_scorres_f2),
        sd.highest_education_level          = wra_v3.sd_highest_edu_level_f2_label,
        sd.tx_school_years_attended         = wra_v3.school_yrs_scorres_f2,
        sd.has_occupation_income            = get_YN_Label(wra_v3.scd_occupation_scorres_f2),
        sd.approx_income_pay                = REGEXP_REPLACE(wra_v3.sd_approx_income_pay_f2, '[[:space:]]+', ' '),
        sd.mobile_phone_accessibility       = wra_v3.scd_mobile_fcorres_f2_label,
        sd.smoke_cigarettes_cigar_pipe      = get_YN_Label(wra_v3.scd_mh_tob_suyn_f2),
        sd.smoke_cigarettes_cigar_pipe_freq = wra_v3.scd_mh_tob_sudosfrq_f2_label,
        sd.chewed_tobacco_last_month        = get_YN_Label(wra_v3.scd_tob_chew_sutrt_f2),
        sd.consumed_alcohol_last_month      = get_YN_Label(wra_v3.scd_alc_suyn_f2)
    WHERE sd.record_id = wra_v3.record_id
      AND wra_v3.covid_scrn_comments_yn_f2 IN (0, 1);

    UPDATE crt_wra_visit_3_socio_demographics_overview sd_v3
    SET sd_v3.approx_income_pay = useCurrencyTrimmer(sd_v3.approx_income_pay)
    WHERE MATCH (approx_income_pay) AGAINST ('+K' IN BOOLEAN MODE);

    UPDATE crt_wra_visit_3_socio_demographics_overview sd_v3
    SET sd_v3.approx_income_pay = REPLACE(REPLACE(REPLACE(approx_income_pay, 'K', ''), 'k', ''), 'Kk', '')
    WHERE sd_v3.has_occupation_income = 'Yes';

    UPDATE crt_wra_visit_3_socio_demographics_overview sd_v3
    SET sd_v3.approx_income_pay = REPLACE(approx_income_pay, ',', '')
    WHERE sd_v3.has_occupation_income = 'Yes';

    UPDATE crt_wra_visit_3_socio_demographics_overview sd_v3
    SET sd_v3.approx_income_pay = CAST(sd_v3.approx_income_pay AS DECIMAL(12, 2))
    WHERE sd_v3.approx_income_pay REGEXP '^[[:digit:]]+$';
    COMMIT;

    -- Process Metrics
    SET @v_tx_pro_sd_v3 = (SELECT COUNT(sd_v3.record_id) FROM crt_wra_visit_3_socio_demographics_overview sd_v3);
    SET @v_load_metrics = CONCAT_WS(' of ', @v_tx_pro_sd_v3, @v_tx_pre_sd_v3);
    SET @v_load_info = CONCAT('WRA-SocioDemographics-V3-Data: LOADING COMPLETE. ', @v_load_metrics);
    SELECT @v_load_info as `|_________________| Operation_Summary |_________________|`;

END $$

DELIMITER ;
