/**
 * Load WRA Third Follow-Up Visit Overview.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 07.02.25
 * @since 0.0.1
 * @alias WRA FU Visit 3 Overview
 */
DROP PROCEDURE IF EXISTS `Load_WRA_FollowUp_Overview_V4`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_FollowUp_Overview_V4()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load WRA FU Visit 3 Overview;', @errno, '(',
                              @sqlstate, '):',
                              @text);
            SELECT @full_error as Error_Details;
            RESIGNAL;
        END;

    START TRANSACTION;
    TRUNCATE arch_etl_db.crt_wra_visit_4_overview;

    INSERT INTO arch_etl_db.crt_wra_visit_4_overview(record_id,
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
    SELECT v4.record_id,
           alternate_id,
           v4.wra_ptid,
           v4.member_id,
           v4.screening_id,
           v4.age,
           v4.ra,
           v.visit_number,
           v.visit_alias as visit_name,
           v4.visit_date,
           CASE
               WHEN v4.is_wra_available = 1 AND v4.attempt_number <= 3 THEN 'Completed'
               WHEN v4.is_wra_available = 2 AND v4.attempt_number < 3 THEN 'Incomplete'
               WHEN ((v4.is_wra_available = 2 AND v4.attempt_number = 3) OR v4.is_wra_available = 8) THEN 'Untraceable'
               WHEN v4.is_wra_available = 3 AND v4.attempt_number <= 3 THEN 'Extended-Absence'
               WHEN v4.is_wra_available = 4 AND v4.attempt_number < 3 THEN 'Physical/Mental-Impairment'
               WHEN v4.is_wra_available = 6 AND v4.attempt_number <= 3
                   THEN CONCAT_WS(' - ', 'Other', v4.is_wra_available_oth_label)
               WHEN v4.is_wra_available = 7 AND v4.attempt_number <= 3 THEN 'Migrated'
               ELSE v4.is_wra_available_label
               END       as visit_outcome
    FROM (SELECT fu_3.wra_follow_up_visit_3_repeating_instruments_id                               as alternate_id,
                 fu_3.record_id,
                 ROW_NUMBER() OVER (
                     PARTITION BY fu_3.record_id ORDER BY fu_3.redcap_repeat_instance DESC)        as visit_id,
                 fu_3.wra_fu_visit_date_f3                                                         as visit_date,
                 CAST(fu_3.hhe_hh_member_id_f3 AS UNSIGNED)                                        as member_id,
                 COALESCE(CAST(fu_3.fu_attempt_count_f3 AS UNSIGNED), fu_3.redcap_repeat_instance) as attempt_number,
                 fu_3.redcap_event_name                                                            as visit_name,
                 fu_3.wra_fu_interviewer_obsloc_f3                                                 as ra,
                 IF(fu_3.wra_fu_wra_ptid_f3 = '', v1.wra_ptid, fu_3.wra_fu_wra_ptid_f3)            as wra_ptid,
                 SUBSTRING(useIdTrimmer(fu_3.hh_scrn_num_obsloc_f3) FROM 1 FOR 14)                 as screening_id,
                 fu_3.wra_fu_pp_avail_f3                                                           as is_wra_available,
                 fu_3.wra_fu_pp_avail_f3_label                                                     as is_wra_available_label,
                 fu_3.wra_fu_is_wra_avail_other_f3                                                 as is_wra_available_oth_label,
                 get_WRA_Age(fu_3.wra_fu_visit_date_f3, fu_3.record_id)                            as age
          FROM wra_follow_up_visit_3_repeating_instruments fu_3
                   LEFT JOIN crt_wra_visit_1_overview v1 ON v1.record_id = fu_3.record_id
          WHERE fu_3.wra_fu_visit_date_f3 IS NOT NULL
             OR fu_3.hhe_hh_member_id_f3 IS NOT NULL) v4
             LEFT JOIN visit v ON v4.visit_name = v.visit_name
    WHERE v4.visit_id = 1
      AND v4.screening_id <> ''
    ORDER BY v4.visit_date DESC;
    COMMIT;

    -- flag completion
    SELECT 'WRA-FU-3-Overview-Data loader completed successfully.' as `|_________________| Operation_Summary |_________________|`;

END $$

DELIMITER ;
