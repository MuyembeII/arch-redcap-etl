/**
 * Load WRA Second Follow-Up Visit Overview.
 *
 * DISCLAIMER: Do not confuse VISIT NUMBER (3.0) with VISIT NAME Second-FU). See the Visit table for more information.
 * V3 - Visit Number 3
 * FU2 - Second Follow-Up Visit
 *
 * @author Gift Jr <muyembegift@gmail.com> | 07.02.25
 * @since 0.0.1
 * @alias WRA FU Visit 2 Overview
 */
DROP PROCEDURE IF EXISTS `Load_WRA_FollowUp_Overview_V3`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_FollowUp_Overview_V3()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load WRA FU Visit 2 Overview;', @errno, '(',
                              @sqlstate, '):',
                              @text);
            SELECT @full_error as Error_Details;
            RESIGNAL;
        END;

    START TRANSACTION;
    TRUNCATE arch_etl_db.crt_wra_visit_3_overview;

    INSERT INTO arch_etl_db.crt_wra_visit_3_overview(record_id,
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
    SELECT v3.record_id,
           alternate_id,
           v3.wra_ptid,
           v3.member_id,
           v3.screening_id,
           v3.age,
           v3.ra,
           v.visit_number,
           v.visit_alias as visit_name,
           v3.visit_date,
           CASE
               WHEN v3.is_wra_available = 1 AND v3.attempt_number <= 3 THEN 'Completed'
               WHEN v3.is_wra_available = 2 AND v3.attempt_number < 3 THEN 'Incomplete'
               WHEN ((v3.is_wra_available = 2 AND v3.attempt_number = 3) OR v3.is_wra_available = 8) THEN 'Untraceable'
               WHEN v3.is_wra_available = 3 AND v3.attempt_number <= 3 THEN 'Extended-Absence'
               WHEN v3.is_wra_available = 4 AND v3.attempt_number < 3 THEN 'Physical/Mental-Impairment'
               WHEN v3.is_wra_available = 6 AND v3.attempt_number <= 3
                   THEN CONCAT_WS(' - ', 'Other', v3.is_wra_available_oth_label)
               WHEN v3.is_wra_available = 7 AND v3.attempt_number <= 3 THEN 'Migrated'
               ELSE v3.is_wra_available_label
               END       as visit_outcome
    FROM (SELECT fu_2.wra_follow_up_visit_2_repeating_instruments_id                            as alternate_id,
                 fu_2.record_id,
                 ROW_NUMBER() OVER (
                     PARTITION BY fu_2.record_id ORDER BY fu_2.redcap_repeat_instance DESC)     as visit_id,
                 fu_2.scrn_obsstdat_f2                                                          as visit_date,
                 CAST(fu_2.hhe_hh_member_id_f2 AS UNSIGNED)                                     as member_id,
                 COALESCE(CAST(fu_2.attempt_count_f2 AS UNSIGNED), fu_2.redcap_repeat_instance) as attempt_number,
                 fu_2.redcap_event_name                                                         as visit_name,
                 fu_2.wra_enr_interviewer_obsloc_f2                                             as ra,
                 fu_2.wra_fu_wra_ptid_f2                                                        as wra_ptid,
                 SUBSTRING(useIdTrimmer(fu_2.hh_scrn_num_obsloc_f2) FROM 1 FOR 14)              as screening_id,
                 fu_2.wra_enr_pp_avail_f2                                                       as is_wra_available,
                 fu_2.wra_enr_pp_avail_f2_label                                                 as is_wra_available_label,
                 fu_2.wra_fu_is_wra_avail_other_f2                                              as is_wra_available_oth_label,
                 get_WRA_Age(fu_2.scrn_obsstdat_f2, fu_2.record_id)                             as age
          FROM wra_follow_up_visit_2_repeating_instruments fu_2
          -- intentionally declaring this filter lazy to catch incomplete REDCap forms. Delete blank form from REDCap 
          WHERE fu_2.scrn_obsstdat_f2 IS NOT NULL
             OR fu_2.hhe_hh_member_id_f2 IS NOT NULL) v3
             LEFT JOIN visit v ON v3.visit_name = v.visit_name
    WHERE v3.visit_id = 1
      AND v3.screening_id <> ''
    ORDER BY v3.visit_date DESC;
    COMMIT;

    -- flag completion
    SELECT 'WRA-FU-2-Overview-Data loader completed successfully.' as `|_________________| Operation_Summary |_________________|`;

END $$

DELIMITER ;
