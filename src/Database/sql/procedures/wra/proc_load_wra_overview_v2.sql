/**
 * Load WRA First Follow-Up Visit Overview.
 *
 * DISCLAIMER: Do not confuse VISIT NUMBER (2.0) with VISIT NAME First-FU). See the Visit table for more information.
 * V2 - Visit Number 2
 * FU1 - First Follow-Up Visit
 *
 * @author Gift Jr <muyembegift@gmail.com> | 07.02.25
 * @since 0.0.1
 * @alias WRA FU Visit 1 Overview
 */
DROP PROCEDURE IF EXISTS `Load_WRA_FollowUp_Overview_V2`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_FollowUp_Overview_V2()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load WRA FU Visit 1 Overview;', @errno, '(',
                              @sqlstate, '):',
                              @text);
            SELECT @full_error as Error_Details;
            RESIGNAL;
        END;

    START TRANSACTION;
    TRUNCATE arch_etl_db.crt_wra_visit_2_overview;

    INSERT INTO arch_etl_db.crt_wra_visit_2_overview(record_id,
                                                     alternate_id,
                                                     wra_ptid,
                                                     member_id,
                                                     screening_id,
                                                     age,
                                                     ra,
                                                     visit_number,
                                                     visit_name,
                                                     visit_date,
                                                     visit_outcome)
    SELECT v2.record_id,
           alternate_id,
           v2.wra_ptid,
           v2.member_id,
           v2.screening_id,
           v2.age,
           v2.ra,
           v.visit_number,
           v.visit_alias as visit_name,
           v2.visit_date,
           CASE
               WHEN v2.is_wra_available = 1 AND v2.attempt_number <= 3 THEN 'Completed'
               WHEN v2.is_wra_available = 2 AND v2.attempt_number < 3 THEN 'Incomplete'
               WHEN ((v2.is_wra_available = 2 AND v2.attempt_number = 3) OR v2.is_wra_available = 8) THEN 'Untraceable'
               WHEN v2.is_wra_available = 3 AND v2.attempt_number <= 3 THEN 'Extended-Absence'
               WHEN v2.is_wra_available = 4 AND v2.attempt_number < 3 THEN 'Physical/Mental-Impairment'
               WHEN v2.is_wra_available = 6 AND v2.attempt_number <= 3
                   THEN CONCAT_WS(' - ', 'Other', v2.is_wra_available_oth_label)
               WHEN v2.is_wra_available = 7 AND v2.attempt_number <= 3 THEN 'Migrated'
               ELSE v2.is_wra_available_label
               END       as visit_outcome
    FROM (SELECT fu_1.wra_follow_up_visit_repeating_instruments_id                              as alternate_id,
                 fu_1.record_id,
                 ROW_NUMBER() OVER (
                     PARTITION BY fu_1.record_id ORDER BY fu_1.redcap_repeat_instance DESC)     as visit_id,
                 fu_1.wra_fu_visit_date                                                         as visit_date,
                 v1.member_id                                     as member_id,
                 COALESCE(CAST(fu_1.fu_attempt_count AS UNSIGNED), fu_1.redcap_repeat_instance) as attempt_number,
                 fu_1.redcap_event_name                                                         as visit_name,
                 fu_1.wra_fu_interviewer_obsloc                                                 as ra,
                 fu_1.wra_fu_wra_ptid                                                           as wra_ptid,
                 v1.screening_id                                                                as screening_id,
                 fu_1.wra_fu_pp_avail                                                           as is_wra_available,
                 fu_1.wra_fu_pp_avail_label                                                     as is_wra_available_label,
                 fu_1.wra_fu_is_wra_avail_other                                                 as is_wra_available_oth_label,
                 get_WRA_Age(fu_1.wra_fu_visit_date, fu_1.record_id)                            as age
          FROM wra_follow_up_visit_repeating_instruments fu_1
                   LEFT JOIN crt_wra_visit_1_overview v1 ON v1.record_id = fu_1.record_id
          -- intentionally declaring this filter lazy to catch incomplete REDCap forms. Delete blank form from REDCap 
          WHERE fu_1.wra_fu_visit_date IS NOT NULL) v2
             LEFT JOIN visit v ON v2.visit_name = v.visit_name
    WHERE v2.visit_id = 1 AND (v2.screening_id <> '' OR v2.member_id <> '')
    ORDER BY v2.visit_date DESC;
    COMMIT;

    -- flag completion
    SELECT 'WRA-FU-1-Overview-Data loader completed successfully.' as `|_________________| Operation_Summary |_________________|`;

END $$

DELIMITER ;
