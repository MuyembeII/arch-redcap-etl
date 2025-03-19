/**
 * Load FU-3 WRA Infant Outcome Assessment.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 18.03.25
 * @since 0.0.1
 * @alias Load WRA Infant Outcome Assessment FU-3
 */
DROP PROCEDURE IF EXISTS `Load_WRA_Infant_Outcome_Overview_V4`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_Infant_Outcome_Overview_V4()
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
    SET @v_tx_pre_ioa_v4 := 0; -- Initial count
    SET @v_tx_pro_ioa_v4 := 0; -- After count

    START TRANSACTION;
    TRUNCATE arch_etl_db.crt_wra_visit_4_infant_outcome_overview;
    SET @v_tx_pre_ioa_v4 = (SELECT COUNT(io.root_id) FROM infant_outcome_assessment_3_repeating_instruments io);
    INSERT INTO arch_etl_db.crt_wra_visit_4_infant_outcome_overview(alternate_id,
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
    SELECT v4.alternate_id,
           v4.infant_id,
           v4.record_id,
           v4.wra_ptid,
           v4.member_id,
           v4.screening_id,
           v4.age,
           v4.ra,
           v4.visit_number,
           v4.visit_name,
           v4.visit_date,
           get_Last_UPT_Result(v4.record_id, v4.visit_number)   as last_upt_result,
           get_Last_Pregnancy_ID(v4.record_id, v4.visit_number) as last_pregnancy_id,
           v4.infant_name,
           REPLACE(v4.infant_ptid, ' ', '')                     as infant_ptid,
           v4.infant_gender,
           CASE
               WHEN v4.infant_mortality_outcome = 0 THEN 'Deceased'
               WHEN v4.infant_mortality_outcome = 1 THEN 'Living'
               END                                              as infant_mortality_outcome,
           v4.infant_living_age_days,
           v4.infant_living_age_months,
           v4.infant_deceased_age_days,
           v4.infant_deceased_age_months
    FROM (SELECT ioa_4.infant_outcome_assessment_3_repeating_instruments_id            as alternate_id,
                 CAST(ioa_4.record_id AS UNSIGNED)                                     as record_id,
                 ROW_NUMBER() OVER (
                     PARTITION BY ioa_4.record_id ORDER
                         BY ioa_4.redcap_repeat_instance DESC)                         as infant_id,
                 v4.wra_ptid,
                 v4.member_id,
                 v4.screening_id,
                 v4.age,
                 v4.ra,
                 v4.visit_number,
                 v4.visit_name,
                 ioa_4.ioa_visit_date_f3                                               as visit_date,
                 ioa_4.ioa_infant_name_f3                                              as infant_name,
                 CONCAT_WS('-', v4.wra_ptid, useAutoTrimmer(ioa_4.ioa_infant_name_f3)) as infant_ptid,
                 ioa_4.ioa_infant_sex_f3_label                                         as infant_gender,
                 ioa_4.ioa_infant_alive_f3                                             as infant_mortality_outcome,
                 ioa_4.ioa_infant_age_days_f3                                          as infant_living_age_days,
                 ioa_4.ioa_infant_age_months_f3                                        as infant_living_age_months,
                 ioa_4.ioa_infant_age_death_days_f3                                    as infant_deceased_age_days,
                 ioa_4.ioa_infant_age_death_months_f3                                  as infant_deceased_age_months
          FROM infant_outcome_assessment_3_repeating_instruments ioa_4
                   LEFT JOIN crt_wra_visit_4_overview v4 ON v4.record_id = ioa_4.record_id
          -- intentionally declaring this filter lazy to catch incomplete REDCap forms. Delete blank form from REDCap
          WHERE ioa_4.ioa_visit_date_f3 IS NOT NULL
            AND v4.visit_outcome = 'Completed') v4
    ORDER BY v4.visit_date DESC;
    COMMIT;

-- Process Metrics
    SET @v_tx_pro_ioa_v4 = (SELECT COUNT(io_v4.record_id) FROM crt_wra_visit_4_infant_outcome_overview io_v4);
    SET @v_load_metrics = CONCAT_WS(' of ', @v_tx_pro_ioa_v4, @v_tx_pre_ioa_v4);
    SET @v_load_info = CONCAT('WRA-Infant-Outcome-Assessment-V4-Data: LOADING COMPLETE. ', @v_load_metrics);
    SELECT @v_load_info as `|_________________| Operation_Summary |_________________|`;

END $$

DELIMITER ;
