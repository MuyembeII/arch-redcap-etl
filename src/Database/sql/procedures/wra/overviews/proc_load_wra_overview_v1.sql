/**
 * Load WRA Baseline Overview.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 26.01.25
 * @since 0.0.1
 * @alias WRA Baseline Overview
 */
DROP PROCEDURE IF EXISTS `Load_WRA_Baseline_Overview_V1`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_Baseline_Overview_V1()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load WRA Baseline (1.0) Overview;', @errno, '(',
                              @sqlstate, '):',
                              @text);
            SELECT @full_error as Error_Details;
            RESIGNAL;
        END;

    START TRANSACTION;
    TRUNCATE arch_etl_db.crt_wra_visit_1_overview;

    INSERT INTO arch_etl_db.crt_wra_visit_1_overview(record_id,
                                                     alternate_id,
                                                     wra_ptid,
                                                     member_id,
                                                     screening_id,
                                                     age,
                                                     dob,
                                                     ra,
                                                     visit_number,
                                                     visit_name,
                                                     visit_date,
                                                     visit_outcome)
    SELECT v1.record_id,
           v1.alternate_id,
           v1.wra_ptid,
           v1.member_id,
           v1.screening_id,
           age,
           dob,
           v1.ra,
           v1.visit_number,
           v1.visit_name,
           v1.screening_date as visit_date,
           'Enrolled'        as visit_outcome
    FROM (SELECT wra_enr.record_id,
                 ROW_NUMBER() OVER (
                     PARTITION BY wra_enr.record_id
                     ORDER BY wra_enr.redcap_repeat_instance DESC )                  as visit_id,
                 wra_enr.wra_forms_repeating_instruments_id                          as alternate_id,
                 CONCAT(
                         UCASE(LEFT(useAutoTrimmer(wra_enr.wra_ptid), 1)),
                         SUBSTRING(wra_enr.wra_ptid, 2)
                 )                                                                   as wra_ptid,
                 CAST(wra_enr.hhe_hh_member_id AS UNSIGNED)                          as member_id,
                 SUBSTRING(useAutoTrimmer(wra_enr.hh_scrn_num_obsloc) FROM 1 FOR 14) as screening_id,
                 wra_enr.scrn_obsstdat                                               as screening_date,
                 useAutoTrimmer(wra_enr.wra_enr_interviewer_obsloc)                                 as ra,
                 get_WRA_Age(wra_enr.scrn_obsstdat, wra_enr.record_id)               as age,
                 wra_enr.brthdat                                                     as dob,
                 v.visit_number,
                 v.visit_alias                                                       as visit_name
          FROM wra_forms_repeating_instruments wra_enr
                   LEFT JOIN visit v ON wra_enr.redcap_event_name = v.visit_name
          WHERE CAST(wra_enr.wra_age AS UNSIGNED) > 0) v1
    WHERE v1.visit_id = 1
    ORDER BY v1.screening_date DESC;

    UPDATE crt_wra_visit_1_overview o1
        LEFT JOIN wra_forms_repeating_instruments v1 ON o1.alternate_id = v1.wra_forms_repeating_instruments_id
    SET o1.ra = 'jdaka'
    WHERE o1.ra = 'gmuyembe' AND v1.wra_ra_name LIKE '%Daka%'
      AND o1.record_id = v1.record_id;


    COMMIT;

    -- flag completion
    SELECT 'WRA-Baseline-Overview-Data loader completed successfully.' as `Operation_Result`;

END $$

DELIMITER ;
