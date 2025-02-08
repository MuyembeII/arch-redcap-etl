/**
 * Load WRA Fifth Follow-Up Visit Overview.
 *
 * DISCLAIMER: Do not confuse VISIT NUMBER (6.0) with VISIT NAME (Fifth-FU). See the Visit table for more information.
 * V6 - Visit Number 6
 * FU5 - Fifth Follow-Up Visit
 *
 * @author Gift Jr <muyembegift@gmail.com> | 07.02.25
 * @since 0.0.1
 * @alias WRA FU Visit 5 Overview
 */
DROP PROCEDURE IF EXISTS `Load_WRA_FollowUp_Overview_V6`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_FollowUp_Overview_V6()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load WRA FU Visit 5 Overview;', @errno, '(',
                              @sqlstate, '):',
                              @text);
            SELECT @full_error as Error_Details;
            RESIGNAL;
        END;

    START TRANSACTION;
    TRUNCATE arch_etl_db.crt_wra_visit_6_overview;

    INSERT INTO arch_etl_db.crt_wra_visit_6_overview(record_id,
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
    SELECT v6.record_id,
           alternate_id,
           v6.wra_ptid,
           v6.member_id,
           v6.screening_id,
           v6.age,
           v6.ra,
           v.visit_number,
           v.visit_alias as visit_name,
           v6.visit_date,
           CASE
               WHEN v6.is_wra_available = 1 AND v6.attempt_number <= 3 THEN 'Completed'
               WHEN v6.is_wra_available = 2 AND v6.attempt_number < 3 THEN 'Incomplete'
               WHEN ((v6.is_wra_available = 2 AND v6.attempt_number = 3) OR v6.is_wra_available = 8) THEN 'Untraceable'
               WHEN v6.is_wra_available = 3 AND v6.attempt_number <= 3 THEN 'Extended-Absence'
               WHEN v6.is_wra_available = 4 AND v6.attempt_number < 3 THEN 'Physical/Mental-Impairment'
               WHEN v6.is_wra_available = 6 AND v6.attempt_number <= 3
                   THEN CONCAT_WS(' - ', 'Other', v6.is_wra_available_oth_label)
               WHEN v6.is_wra_available = 7 AND v6.attempt_number <= 3 THEN 'Migrated'
               ELSE v6.is_wra_available_label
               END       as visit_outcome
    FROM (SELECT fu_5.wra_follow_up_visit_5_repeating_instruments_id                               as alternate_id,
                 fu_5.record_id,
                 ROW_NUMBER() OVER (
                     PARTITION BY fu_5.record_id ORDER BY fu_5.redcap_repeat_instance DESC)        as visit_id,
                 fu_5.wra_fu_visit_date_f5                                                         as visit_date,
                 fu_5.hhe_hh_member_id_f5                                                          as member_id,
                 COALESCE(CAST(fu_5.fu_attempt_count_f5 AS UNSIGNED), fu_5.redcap_repeat_instance) as attempt_number,
                 fu_5.redcap_event_name                                                            as visit_name,
                 fu_5.wra_fu_interviewer_obsloc_f5                                                 as ra,
                 fu_5.wra_fu_wra_ptid_f5                                                           as wra_ptid,
                 SUBSTRING(useIdTrimmer(fu_5.hh_scrn_num_obsloc_f5) FROM 1 FOR 14)                 as screening_id,
                 fu_5.wra_fu_pp_avail_f5                                                           as is_wra_available,
                 fu_5.wra_fu_pp_avail_f5_label                                                     as is_wra_available_label,
                 fu_5.wra_fu_is_wra_avail_other_f5                                                 as is_wra_available_oth_label,
                 get_WRA_Age(fu_5.wra_fu_visit_date_f5, fu_5.record_id)                            as age
          FROM wra_follow_up_visit_5_repeating_instruments fu_5
          -- intentionally declaring this filter lazy to catch incomplete REDCap forms. Delete blank form from REDCap 
          WHERE fu_5.wra_fu_visit_date_f5 IS NOT NULL
             OR fu_5.hhe_hh_member_id_f5 IS NOT NULL) v6
             LEFT JOIN visit v ON v6.visit_name = v.visit_name
    WHERE v6.visit_id = 1
      AND v6.screening_id <> ''
    ORDER BY v6.visit_date DESC;
    COMMIT;

    -- flag completion
    SELECT 'WRA-FU-4-Overview-Data loader completed successfully.' as `|_________________| Operation_Summary |_________________|`;

END $$

DELIMITER ;
