/**
 * Load WRA Fourth Follow-Up Visit Overview.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 29.01.25
 * @since 0.0.1
 * @alias WRA FU Visit 4 Overview
 */
DROP PROCEDURE IF EXISTS `Load_WRA_FollowUp_Overview_V5`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_FollowUp_Overview_V5()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load WRA FU Visit 4 Overview;', @errno, '(',
                              @sqlstate, '):',
                              @text);
            SELECT @full_error as Error_Details;
            RESIGNAL;
        END;

    START TRANSACTION;
    TRUNCATE arch_etl_db.crt_wra_visit_5_overview;

    INSERT INTO arch_etl_db.crt_wra_visit_5_overview(record_id,
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
    SELECT v5.record_id,
           root_id       as alternate_id,
           v5.wra_ptid,
           v5.member_id,
           v5.screening_id,
           v1.age,
           v5.ra,
           v.visit_number,
           v.visit_alias as visit_name,
           v5.visit_date,
           CASE
               WHEN v5.is_wra_available = 1 AND v5.attempt_number <= 3 THEN 'Completed'
               WHEN v5.is_wra_available = 2 AND v5.attempt_number < 3 THEN 'Incomplete'
               WHEN ((v5.is_wra_available = 2 AND v5.attempt_number = 3) OR v5.is_wra_available = 8) THEN 'Untraceable'
               WHEN v5.is_wra_available = 3 AND v5.attempt_number <= 3 THEN 'Extended-Absence'
               WHEN v5.is_wra_available = 4 AND v5.attempt_number < 3 THEN 'Physical/Mental-Impairment'
               WHEN v5.is_wra_available = 6 AND v5.attempt_number <= 3
                   THEN CONCAT_WS(' - ', 'Other', v5.is_wra_available_oth_label)
               WHEN v5.is_wra_available = 7 AND v5.attempt_number <= 3 THEN 'Migrated'
               ELSE v5.is_wra_available_label
               END       as visit_outcome
    FROM (SELECT fu_4.root_id,
                 fu_4.record_id,
                 ROW_NUMBER() OVER (
                     PARTITION BY fu_4.record_id ORDER BY fu_4.redcap_repeat_instance DESC) as visit_id,
                 fu_4.wra_fu_visit_date_f4                                                 as visit_date,
                 fu_4.hhe_hh_member_id_f4                                                  as member_id,
                 fu_4.redcap_repeat_instance                                               as attempt_number,
                 fu_4.redcap_event_name                                                    as visit_name,
                 fu_4.wra_fu_interviewer_obsloc_f4                                         as ra,
                 fu_4.wra_fu_wra_ptid_f4                                                   as wra_ptid,
                 fu_4.hh_scrn_num_obsloc_f4                                                as screening_id,
                 fu_4.wra_fu_pp_avail_f4                                                   as is_wra_available,
                 fu_4.wra_fu_pp_avail_f4_label                                             as is_wra_available_label,
                 fu_4.wra_fu_is_wra_avail_other_f4                                         as is_wra_available_oth_label
          FROM wra_follow_up_visit_4_repeating_instruments fu_4) v5
             LEFT JOIN visit v ON v5.visit_name = v.visit_name
             JOIN crt_wra_visit_1_overview v1 ON v5.wra_ptid = v1.wra_ptid
    WHERE v5.visit_id = 1
    ORDER BY v5.visit_date DESC;
    COMMIT;

    -- flag completion
    SELECT 'WRA-FU-4-Overview-Data loader completed successfully.' as `|_________________| Operation_Summary |_________________|`;

END $$

DELIMITER ;
