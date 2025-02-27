/**
 * Load WRA Missed appointments.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 07.02.25
 * @since 0.0.1
 * @alias WRA FU-3 Missed Appointment
 */
DROP PROCEDURE IF EXISTS `Load_WRA_Missed_Visit_V4`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_Missed_Visit_V4()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load WRA FU-3 Missed Visit;', @errno, '(',
                              @sqlstate, '):',
                              @text);
            SELECT @full_error as Error_Details;
            RESIGNAL;
        END;

    START TRANSACTION;
    TRUNCATE arch_etl_db.crt_wra_missed_visit_4_overview;

    INSERT INTO arch_etl_db.crt_wra_missed_visit_4_overview(record_id,
                                                            screening_id,
                                                            wra_ptid,
                                                            last_visit_date,
                                                            follow_up_3_visit_date,
                                                            follow_up_3_last_visit_date,
                                                            follow_up_3_visit_date_days_late)
    SELECT *
    FROM (SELECT v1.record_id,
                 v1.screening_id,
                 v1.wra_ptid,
                 v1.visit_date                                                             as last_visit_date,
                 DATE_ADD(v1.visit_date, INTERVAL ((90) + (90 + 21) + (90)) DAY)           as follow_up_3_visit_date,
                 DATE_ADD(v1.visit_date, INTERVAL ((90) + (90 + 21) + (90 + 21))
                          DAY)                                                             as follow_up_3_last_visit_date,
                 DATEDIFF(CURRENT_DATE,
                          DATE_ADD(v1.visit_date, INTERVAL ((90) + (90 + 21) + (90)) DAY)) as follow_up_3_visit_date_days_late
          FROM crt_wra_visit_1_overview v1
          WHERE v1.record_id NOT IN (SELECT f1.record_id FROM crt_wra_visit_2_overview f1)
            AND v1.record_id NOT IN (SELECT f2.record_id FROM crt_wra_visit_3_overview f2)
            AND v1.record_id NOT IN (SELECT f3.record_id FROM crt_wra_visit_4_overview f3)
            AND DATEDIFF(CURRENT_DATE, DATE_ADD(v1.visit_date, INTERVAL ((90) + (90 + 21) + (90)) DAY)) > 21
          UNION
-- Dateset 2: 1st FU visits due for 3rd FU appointment.
          SELECT v2.record_id,
                 v2.screening_id,
                 v2.wra_ptid,
                 v2.visit_date                                                      as last_visit_date,
                 DATE_ADD(v2.visit_date, INTERVAL ((90 + 21) + (90)) DAY)           as follow_up_3_visit_date,
                 DATE_ADD(v2.visit_date, INTERVAL ((90 + 21) + (90 + 21)) DAY)      as follow_up_3_last_visit_date,
                 DATEDIFF(CURRENT_DATE,
                          DATE_ADD(v2.visit_date, INTERVAL ((90 + 21) + (90)) DAY)) as follow_up_3_visit_date_days_late
          FROM crt_wra_visit_2_overview v2
          WHERE v2.record_id NOT IN (SELECT f2.record_id FROM crt_wra_visit_3_overview f2)
            AND v2.record_id NOT IN (SELECT f3.record_id FROM crt_wra_visit_4_overview f3)
            AND DATEDIFF(CURRENT_DATE, DATE_ADD(v2.visit_date, INTERVAL ((90 + 21) + (90)) DAY)) > 21
          UNION
-- Dateset 3: 2nd FU visits due for 3rd FU appointment.
          SELECT v3.record_id,
                 v3.screening_id,
                 v3.wra_ptid,
                 v3.visit_date                                                        as last_visit_date,
                 DATE_ADD(v3.visit_date, INTERVAL ((90)) DAY)                         as follow_up_3_visit_date,
                 DATE_ADD(v3.visit_date, INTERVAL ((90 + 21)) DAY)                    as follow_up_3_last_visit_date,
                 DATEDIFF(CURRENT_DATE,
                          DATE_ADD(v3.visit_date, INTERVAL ((90)) DAY))               as follow_up_3_visit_date_days_late
          FROM crt_wra_visit_3_overview v3
          WHERE v3.record_id NOT IN (SELECT f3.record_id FROM crt_wra_visit_4_overview f3)
            AND DATEDIFF(CURRENT_DATE, DATE_ADD(v3.visit_date, INTERVAL ((90)) DAY)) > 21) fu3
    WHERE fu3.record_id NOT IN (SELECT sc.record_id FROM crt_wra_study_closure sc WHERE sc.visit_number IN (1.0, 2.0, 3.0, 4.0))
    ORDER BY fu3.follow_up_3_visit_date_days_late DESC;
    COMMIT;

    -- flag completion
    SELECT 'WRA-FU-3-Missed-Overview-Data loader completed successfully.' as `|_________________| Operation_Summary |_________________|`;

END $$

DELIMITER ;
