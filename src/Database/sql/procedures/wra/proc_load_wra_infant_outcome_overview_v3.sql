/**
 * Load FU-2 WRA Infant Outcome Assessment.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 14.02.25
 * @since 0.0.1
 * @alias Load WRA Infant Outcome Assessment FU-2
 */
DROP PROCEDURE IF EXISTS `Load_WRA_Infant_Outcome_Overview_V3`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_Infant_Outcome_Overview_V3()
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

    START TRANSACTION;
    TRUNCATE arch_etl_db.crt_wra_visit_3_infant_outcome_overview;
    INSERT INTO arch_etl_db.crt_wra_visit_3_infant_outcome_overview(alternate_id,
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
    SELECT v3.alternate_id,
           v3.infant_id,
           v3.record_id,
           v3.wra_ptid,
           v3.member_id,
           v3.screening_id,
           v3.age,
           v3.ra,
           v3.visit_number,
           v3.visit_name,
           v3.visit_date,
           v3.infant_name,
           REPLACE(v3.infant_ptid, ' ', '') as infant_ptid,
           v3.infant_gender,
           CASE
               WHEN v3.infant_mortality_outcome = 0 THEN 'Deceased'
               WHEN v3.infant_mortality_outcome = 1 THEN 'Living'
               END                          as infant_mortality_outcome,
           v3.infant_living_age_days,
           v3.infant_living_age_months,
           v3.infant_deceased_age_days,
           v3.infant_deceased_age_months
    FROM (SELECT ioa_3.wrafu_infant_outcome_assessment_repeating_instruments_id               as alternate_id,
                 ioa_3.record_id,
                 ROW_NUMBER() OVER (
                     PARTITION BY ioa_3.record_id ORDER BY ioa_3.redcap_repeat_instance DESC) as infant_id,
                 v3.wra_ptid,
                 v3.member_id,
                 v3.screening_id,
                 v3.age,
                 v3.ra,
                 v3.visit_number,
                 v3.visit_name,
                 ioa_3.ioa_visit_date_f2                                                      as visit_date,
                 ioa_3.ioa_infant_name_f2                                                     as infant_name,
                 CONCAT_WS('-', v3.wra_ptid, useAutoTrimmer(ioa_3.ioa_infant_name_f2))        as infant_ptid,
                 ioa_3.ioa_infant_sex_f2_label                                                as infant_gender,
                 ioa_3.ioa_infant_alive_f2                                                    as infant_mortality_outcome,
                 ioa_3.ioa_infant_age_days_f2                                                 as infant_living_age_days,
                 ioa_3.ioa_infant_age_months_f2                                               as infant_living_age_months,
                 ioa_3.ioa_infant_age_death_days_f2                                           as infant_deceased_age_days,
                 ioa_3.ioa_infant_age_death_months_f2                                         as infant_deceased_age_months
          FROM wrafu_infant_outcome_assessment_repeating_instruments ioa_3
                   LEFT JOIN crt_wra_visit_3_overview v3 ON v3.record_id = ioa_3.record_id
          -- intentionally declaring this filter lazy to catch incomplete REDCap forms. Delete blank form from REDCap
          WHERE ioa_3.ioa_visit_date_f2 IS NOT NULL
            AND v3.visit_outcome = 'Completed') v3
    ORDER BY v3.visit_date DESC;

    UPDATE crt_wra_visit_3_infant_outcome_overview v2
        LEFT JOIN crt_wra_visit_2_pregnancy_assessments_overview pa_v2 ON v2.record_id = pa_v2.record_id
        LEFT JOIN crt_wra_point_of_collection_overview poc ON v2.record_id = poc.record_id
    SET v2.last_upt_result   = poc.upt_result,
        v2.last_pregnancy_id = poc.pregnancy_id
    WHERE poc.visit_number = 2.0; -- filter by previous POC visit
    COMMIT;

    -- flag completion
    SELECT 'FU-2 WRA Infant Outcome Assessment loader completed successfully.' as `|_________________| Operation_Summary |_________________|`;

END $$

DELIMITER ;
