/**
 * Load WRA FU-2 Missed Appointments.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 27.02.25
 * @since 0.0.1
 * @alias WRA FU-2 Missed Appointment
 */
DROP PROCEDURE IF EXISTS `Load_WRA_Missed_Visit_V3`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_Missed_Visit_V3()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load WRA FU-2 Missed Visit;', @errno, '(',
                              @sqlstate, '):',
                              @text);
            SELECT @full_error as Error_Details;
            RESIGNAL;
        END;

    START TRANSACTION;
    TRUNCATE arch_etl_db.crt_wra_missed_visit_3_overview;

    INSERT INTO arch_etl_db.crt_wra_missed_visit_3_overview(record_id,
                                                            screening_id,
                                                            wra_ptid,
                                                            last_visit_date)
    SELECT *
    FROM (SELECT v1.record_id,
                 v1.screening_id,
                 v1.wra_ptid,
                 v1.visit_date as last_visit_date
          FROM crt_wra_visit_1_overview v1
          WHERE v1.record_id NOT IN (SELECT f1.record_id FROM crt_wra_visit_2_overview f1)
            AND v1.record_id NOT IN (SELECT f2.record_id FROM crt_wra_visit_3_overview f2)
          UNION
          SELECT v2.record_id,
                 v2.screening_id,
                 v2.wra_ptid,
                 v2.visit_date as last_visit_date
          FROM crt_wra_visit_2_overview v2
          WHERE v2.record_id NOT IN (SELECT f2.record_id FROM crt_wra_visit_3_overview f2)) fu2
    WHERE fu2.record_id NOT IN
          (SELECT sc.record_id FROM crt_wra_study_closure sc WHERE sc.visit_number IN (1.0, 2.0, 3.0))
    ORDER BY fu2.last_visit_date DESC;
    COMMIT;

    -- flag completion
    SELECT 'WRA-FU-2-Missed-Overview-Data loader completed successfully.' as `|_________________| Operation_Summary |_________________|`;

END $$

DELIMITER ;
