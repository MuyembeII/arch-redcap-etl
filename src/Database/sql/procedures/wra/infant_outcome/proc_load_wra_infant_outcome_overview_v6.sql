/**
 * Load FU-5 WRA Infant Outcome Assessment.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 18.03.25
 * @since 0.0.1
 * @alias Load WRA Infant Outcome Assessment FU-5
 */
DROP PROCEDURE IF EXISTS `Load_WRA_Infant_Outcome_Overview_V6`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_Infant_Outcome_Overview_V6()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load FU-3 WRA Infant Outcome Assessment;', @errno, '(',
                              @sqlstate, '):',
                              @text);
            SELECT @full_error;
            RESIGNAL;
        END;
    -- Op matrices
    SET @v_tx_pre_ioa_v6 := 0; -- Initial count
    SET @v_tx_pro_ioa_v6 := 0; -- After count

    START TRANSACTION;
    TRUNCATE arch_etl_db.crt_wra_visit_6_infant_outcome_overview;
    SET @v_tx_pre_ioa_v6 = (SELECT COUNT(io.root_id) FROM infant_outcome_assessment_5_repeating_instruments io);
    INSERT INTO arch_etl_db.crt_wra_visit_6_infant_outcome_overview(alternate_id,
                                                                    infant_id,
                                                                    record_id,
                                                                    wra_ptid,
                                                                    member_id,
                                                                    screening_id,
                                                                    age,
                                                                    ra,
                                                                    visit_number,
                                                                    visit_name,
                                                                    visit_date,
                                                                    last_upt_result,
                                                                    last_pregnancy_id,
                                                                    infant_name,
                                                                    infant_ptid,
                                                                    infant_gender,
                                                                    infant_mortality_outcome,
                                                                    infant_living_age_days,
                                                                    infant_living_age_months,
                                                                    infant_deceased_age_days,
                                                                    infant_deceased_age_months)
    SELECT v6.alternate_id,
           v6.infant_id,
           v6.record_id,
           v6.wra_ptid,
           v6.member_id,
           v6.screening_id,
           v6.age,
           v6.ra,
           v6.visit_number,
           v6.visit_name,
           v6.visit_date,
           get_Last_UPT_Result(v6.record_id, v6.visit_number)   as last_upt_result,
           get_Last_Pregnancy_ID(v6.record_id, v6.visit_number) as last_pregnancy_id,
           v6.infant_name,
           REPLACE(v6.infant_ptid, ' ', '')                     as infant_ptid,
           v6.infant_gender,
           CASE
               WHEN v6.infant_mortality_outcome = 0 THEN 'Deceased'
               WHEN v6.infant_mortality_outcome = 1 THEN 'Living'
               END                                              as infant_mortality_outcome,
           v6.infant_living_age_days,
           v6.infant_living_age_months,
           v6.infant_deceased_age_days,
           v6.infant_deceased_age_months
    FROM (SELECT ioa_6.infant_outcome_assessment_5_repeating_instruments_id            as alternate_id,
                 CAST(ioa_6.record_id AS UNSIGNED)                                     as record_id,
                 ROW_NUMBER() OVER (
                     PARTITION BY ioa_6.record_id ORDER
                         BY ioa_6.redcap_repeat_instance DESC)                         as infant_id,
                 v6.wra_ptid,
                 v6.member_id,
                 v6.screening_id,
                 v6.age,
                 v6.ra,
                 v6.visit_number,
                 v6.visit_name,
                 ioa_6.ioa_visit_date_f5                                               as visit_date,
                 ioa_6.ioa_infant_name_f5                                              as infant_name,
                 CONCAT_WS('-', v6.wra_ptid, useAutoTrimmer(ioa_6.ioa_infant_name_f5)) as infant_ptid,
                 ioa_6.ioa_infant_sex_f5_label                                         as infant_gender,
                 ioa_6.ioa_infant_alive_f5                                             as infant_mortality_outcome,
                 ioa_6.ioa_infant_age_days_f5                                          as infant_living_age_days,
                 ioa_6.ioa_infant_age_months_f5                                        as infant_living_age_months,
                 ioa_6.ioa_infant_age_death_days_f5                                    as infant_deceased_age_days,
                 ioa_6.ioa_infant_age_death_months_f5                                  as infant_deceased_age_months
          FROM infant_outcome_assessment_5_repeating_instruments ioa_6
                   LEFT JOIN crt_wra_visit_6_overview v6 ON v6.record_id = ioa_6.record_id
          -- intentionally declaring this filter lazy to catch incomplete REDCap forms. Delete blank form from REDCap
          WHERE ioa_6.ioa_visit_date_f5 IS NOT NULL
            AND v6.visit_outcome = 'Completed') v6
    ORDER BY v6.visit_date DESC;
    COMMIT;

-- Process Metrics
    SET @v_tx_pro_ioa_v6 = (SELECT COUNT(io_v6.record_id) FROM crt_wra_visit_6_infant_outcome_overview io_v6);
    SET @v_load_metrics = CONCAT_WS(' of ', @v_tx_pro_ioa_v6, @v_tx_pre_ioa_v6);
    SET @v_load_info = CONCAT('WRA-Infant-Outcome-Assessment-V6-Data: LOADING COMPLETE. ', @v_load_metrics);
    SELECT @v_load_info as `|_________________| Operation_Summary |_________________|`;

END $$

DELIMITER ;
