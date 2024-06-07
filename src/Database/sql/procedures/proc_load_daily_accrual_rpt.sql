/**
 * Load daily accrual given a date range
 *
 * @author Gift Jr <muyembegift@gmail.com> | 18.09.23
 * @since 0.0.1
 * @alias Initiate Accrual Data By RA
 * @param date Start Date
 * @param date End Date
 * @param varchar RA username
 */
DROP PROCEDURE IF EXISTS `InitiateAccrualData`;
DELIMITER $$
CREATE PROCEDURE InitiateAccrualData(IN p_start_date DATE, IN p_end_date DATE, IN p_ra_name VARCHAR(64))
BEGIN

    DECLARE v_visit_date DATE DEFAULT p_start_date;
    DECLARE v_end_date DATE DEFAULT p_end_date;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
        BEGIN
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                CONCAT_WS(' ', 'ERROR - Failed to load daily RA accrual; RA_ID=', p_ra_name, 'RPT_DATE=', v_visit_date,
                          @errno, '(', @sqlstate, '):', @text);
            SELECT @full_error;
            RESIGNAL;
        END;

    /*Aggregates*/
    SET @v_household_screened := 0;
    SET @v_hh_visit_completed := 0;
    SET @v_hh_visit_incomplete := 0;
    SET @v_wra_screened := 0;
    SET @v_wra_enrolled := 0;
    SET @v_wra_visit_completed := 0;
    SET @v_wra_visit_incomplete := 0;

    IF p_end_date IS NULL THEN
        SET p_end_date = CURDATE();
    ELSEIF p_end_date < p_start_date THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = p_end_date;
    END IF;

    START TRANSACTION;
    REPEAT
        SET @v_household_screened = (SELECT COUNT(DISTINCT hh.hh_id)
                                     FROM crt_households hh
                                     WHERE hh.screened_by = p_ra_name
                                       AND hh.date_of_screening = v_visit_date);
        SET @v_hh_visit_completed = (SELECT COUNT(DISTINCT hh.hh_id)
                                     FROM crt_households hh
                                     WHERE hh.visit_status = 'Completed'
                                       AND hh.screened_by = p_ra_name
                                       AND hh.date_of_screening = v_visit_date);
        SET @v_hh_visit_incomplete = (SELECT COUNT(DISTINCT hh.hh_id)
                                      FROM crt_households hh
                                      WHERE hh.visit_status = 'In-complete'
                                        AND hh.screened_by = p_ra_name
                                        AND hh.date_of_screening = v_visit_date);
        SET @v_wra_screened = (SELECT COUNT(DISTINCT ce.wra_enrollment_id)
                               FROM crt_enrollments ce
                               WHERE ce.enrolled_by = p_ra_name
                                 AND ce.date_of_enrollment = v_visit_date);
        SET @v_wra_enrolled = (SELECT COUNT(DISTINCT ce.wra_enrollment_id)
                               FROM crt_enrollments ce
                               WHERE LENGTH(ce.wra_ptid) = 6
                                 AND ce.enrolled_by = p_ra_name
                                 AND ce.date_of_enrollment = v_visit_date);
        SET @v_wra_visit_completed = (SELECT COUNT(DISTINCT ce.wra_enrollment_id)
                                      FROM crt_enrollments ce
                                      WHERE ce.enrolled_by = p_ra_name
                                        AND ce.date_of_enrollment = v_visit_date
                                        AND ce.visit_status = 'Complete');
        SET @v_wra_visit_incomplete = (SELECT COUNT(DISTINCT ce.wra_enrollment_id)
                                       FROM crt_enrollments ce
                                       WHERE ce.enrolled_by = p_ra_name
                                         AND ce.date_of_enrollment = v_visit_date
                                         AND ce.visit_status = 'Incomplete');

        INSERT INTO crt_ra_accrual(ra_name, date, household_screened, hh_visit_completed, hh_visit_incomplete,
                                   wra_screened, wra_enrolled, wra_visit_completed, wra_visit_incomplete)
        VALUES (p_ra_name, v_visit_date, @v_household_screened, @v_hh_visit_completed,
                @v_hh_visit_incomplete, @v_wra_screened, @v_wra_enrolled, @v_wra_visit_completed,
                @v_wra_visit_incomplete);

        -- day tracker incrementation
        SET v_visit_date = DATE_ADD(v_visit_date, INTERVAL 1 DAY);
    UNTIL v_visit_date >= v_end_date END REPEAT;
    COMMIT;
    -- flag completion
    SELECT 1 as `status`;

END $$

DELIMITER ;
