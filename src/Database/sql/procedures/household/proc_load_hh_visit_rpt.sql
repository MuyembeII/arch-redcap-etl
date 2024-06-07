/*_________________________| HH Visit CRT |______________________________*/
/**
 * Populates household visits staging data into the custom reporting table.
 * Since the HH Visit CRT is an explicit multi-update operation, tasks will
 * use transactions to ensure that data changes are committed as an atomic
 * operation and temporarily disables autocommit.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 24.01.24
 * @since 0.0.1
 * @alias Get Household Visit Data
 */
DROP PROCEDURE if EXISTS `GetHouseholdVisitData`;
DELIMITER $$
CREATE PROCEDURE GetHouseholdVisitData(OUT p_last_insert_id MEDIUMINT)
    COMMENT 'ARCH Pre-Screening Household Visits'
BEGIN
    -- 0.0 Procedure Exception Handlers; Handler for catching duplication error and unique field violations
    DECLARE CONTINUE HANDLER FOR 1062, 23000
        BEGIN
            SHOW ERRORS;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @error_msg =
                CONCAT_WS('|', 'Possible duplicates detected in HH Visit Data.', @errno, '(', @sqlstate, '):', @text);
            SELECT @error_msg;
        END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
        BEGIN
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error = CONCAT_WS('| ', 'HH PRE-SCREENING VISIT DATA; ', @errno, '(', @sqlstate, '):', @text);
            SELECT @full_error;
            RESIGNAL;
        END;

    START TRANSACTION;
    -- 1.0 Refresh reporting table
    TRUNCATE TABLE crt_household_visits;
    -- 2.0 Insert HH visit overview base data or non-nullable fields
    INSERT INTO crt_household_visits (hh_id, screening_id, family_id, date_of_screening)
    SELECT hss.record_id                                 as hh_id,
           hss.hh_scrn_num_obsloc                        as screening_d,
           concat(hss.hh_scrn_num_obsloc, hss.record_id) as family_id, -- a composition of the Screening ID and Record ID
           hss.interview_date_scorres                    as date_of_screening
    FROM hh_screening hss;

    -- 3.0 HH last interaction date
    UPDATE crt_household_visits hv
    SET hv.date_of_last_visit = getHouseholdLastVisitDate(hv.hh_id)
    WHERE hv.date_of_last_visit IS NULL;

    -- 3.1 HH next interaction date (estimated)
    UPDATE crt_household_visits hv
    SET hv.date_of_next_visit = DATE_ADD(getHouseholdLastVisitDate(hv.hh_id), INTERVAL 90 DAY)
    WHERE hv.date_of_next_visit IS NULL;

    -- 3.2 HH total visits
    UPDATE crt_household_visits hv
    SET hv.total_visits = getHouseholdVisitTotal(hv.hh_id)
    WHERE hv.total_visits IS NULL;

    -- 3.3 HH current interaction number
    UPDATE crt_household_visits hv
    SET hv.current_visit_number = getHouseholdCurrentVisitNumber(hv.hh_id)
    WHERE hv.current_visit_number IS NULL;

    -- 3.3 HH screening total attempt count
    UPDATE crt_household_visits hv
    SET hv.total_attempts = getHouseholdAttemptTotal(hv.hh_id)
    WHERE hv.total_attempts IS NULL;

    -- 3.4 HH screening current attempt number
    UPDATE crt_household_visits hv
    SET hv.current_attempt_number = getHouseholdCurrentAttempt(hv.hh_id)
    WHERE hv.current_attempt_number IS NULL;

    -- 3.5 HH screening current attempt number
    UPDATE crt_household_visits hv
    SET hv.household_visit_number = (hv.current_visit_number + hv.current_attempt_number)
    WHERE hv.household_visit_number IS NULL;
    COMMIT;

    -- flag completion
    SELECT LAST_INSERT_ID() INTO p_last_insert_id;
END $$

DELIMITER ;
