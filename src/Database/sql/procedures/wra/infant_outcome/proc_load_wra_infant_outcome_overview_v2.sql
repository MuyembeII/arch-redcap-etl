/**
 * Load FU-1 WRA Infant Outcome Assessment.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 14.02.25
 * @since 0.0.1
 * @alias Load WRA Infant Outcome Assessment FU-1
 */
DROP PROCEDURE IF EXISTS `Load_WRA_Infant_Outcome_Overview_V2`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_Infant_Outcome_Overview_V2()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load FU-2 WRA Infant Outcome Assessment;', @errno, '(',
                              @sqlstate, '):',
                              @text);
            SELECT @full_error;
            RESIGNAL;
        END;
    -- Op matrices
    SET @v_tx_pre_ioa_v2 := 0; -- Initial count
    SET @v_tx_pro_ioa_v2 := 0; -- After count

    START TRANSACTION;
    TRUNCATE arch_etl_db.crt_wra_visit_2_infant_outcome_overview;
    SET @v_tx_pre_ioa_v2 = (SELECT COUNT(io.root_id) FROM infant_outcome_assessment_repeating_instruments io);
    INSERT INTO arch_etl_db.crt_wra_visit_2_infant_outcome_overview(alternate_id,
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
                                                                    infant_name,
                                                                    infant_ptid,
                                                                    infant_gender,
                                                                    infant_mortality_outcome,
                                                                    infant_living_age_days,
                                                                    infant_living_age_months,
                                                                    infant_deceased_age_days,
                                                                    infant_deceased_age_months)
    SELECT v2.alternate_id,
           v2.infant_id,
           v2.record_id,
           v2.wra_ptid,
           v2.member_id,
           v2.screening_id,
           v2.age,
           v2.ra,
           v2.visit_number,
           v2.visit_name,
           v2.visit_date,
           v2.infant_name,
           REPLACE(v2.infant_ptid, ' ', '') as infant_ptid,
           v2.infant_gender,
           CASE
               WHEN v2.infant_mortality_outcome = 0 THEN 'Deceased'
               WHEN v2.infant_mortality_outcome = 1 THEN 'Living'
               END                          as infant_mortality_outcome,
           v2.infant_living_age_days,
           v2.infant_living_age_months,
           v2.infant_deceased_age_days,
           v2.infant_deceased_age_months
    FROM (SELECT ioa_2.infant_outcome_assessment_repeating_instruments_id                     as alternate_id,
                 CAST(ioa_2.record_id AS UNSIGNED)                                            as record_id,
                 ROW_NUMBER() OVER (
                     PARTITION BY ioa_2.record_id ORDER BY ioa_2.redcap_repeat_instance DESC) as infant_id,
                 v2.wra_ptid,
                 v2.member_id,
                 v2.screening_id,
                 v2.age,
                 v2.ra,
                 v2.visit_number,
                 v2.visit_name,
                 ioa_2.ioa_visit_date                                                         as visit_date,
                 ioa_2.ioa_infant_name                                                        as infant_name,
                 CONCAT_WS('-', v2.wra_ptid, useAutoTrimmer(ioa_2.ioa_infant_name))           as infant_ptid,
                 ioa_2.ioa_infant_sex_label                                                   as infant_gender,
                 ioa_2.ioa_infant_alive                                                       as infant_mortality_outcome,
                 ioa_2.ioa_infant_age_days                                                    as infant_living_age_days,
                 ioa_2.ioa_infant_age_months                                                  as infant_living_age_months,
                 ioa_2.ioa_infant_age_death_days                                              as infant_deceased_age_days,
                 ioa_2.ioa_infant_age_death_months                                            as infant_deceased_age_months
          FROM infant_outcome_assessment_repeating_instruments ioa_2
                   LEFT JOIN crt_wra_visit_2_overview v2 ON v2.record_id = ioa_2.record_id
          -- intentionally declaring this filter lazy to catch incomplete REDCap forms. Delete blank form from REDCap
          WHERE ioa_2.ioa_visit_date IS NOT NULL
            AND v2.visit_outcome = 'Completed') v2
    ORDER BY v2.visit_date DESC;

    UPDATE crt_wra_visit_2_infant_outcome_overview v2
        LEFT JOIN crt_wra_point_of_collection_overview poc ON v2.record_id = poc.record_id
    SET v2.last_upt_result   = poc.upt_result,
        v2.last_pregnancy_id = poc.pregnancy_id
    WHERE poc.visit_number = (v2.visit_number - 1); -- filter by all previous POC visits
    COMMIT;

    -- Process Metrics
    SET @v_tx_pro_ioa_v2 = (SELECT COUNT(io_v2.record_id) FROM crt_wra_visit_2_infant_outcome_overview io_v2);
    SET @v_load_metrics = CONCAT_WS(' of ', @v_tx_pro_ioa_v2, @v_tx_pre_ioa_v2);
    SET @v_load_info = CONCAT('WRA-Infant-Outcome-Assessment-V2-Data: LOADING COMPLETE. ', @v_load_metrics);
    SELECT @v_load_info as `|_________________| Operation_Summary |_________________|`;

END $$

DELIMITER ;
