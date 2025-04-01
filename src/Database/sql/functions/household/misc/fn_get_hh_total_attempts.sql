/**
 * @description Returns the HH total number attempts made by an RA
 * for a particular structure querying the verbal consent
 * baseline visit.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 27.01.24
 * @since 0.0.1
 * @alias Get HH Attempt Total
 * @param mediumint p_household_id Household/Record ID
 * @return smallint HH Attempt Total. -1:0:1:2:3
 */
DROP FUNCTION if EXISTS `getHouseholdAttemptTotal`;
DELIMITER $$
CREATE FUNCTION getHouseholdAttemptTotal(p_household_id mediumint)
    RETURNS tinyint
    NOT deterministic
BEGIN
    /** Counting all the HH-ID NON NULL values; deferment placed in Verbal Consent instrument. **/
    DECLARE v_hh_attempt_total smallint SIGNED;
    SELECT COUNT(hvc.record_id) INTO @v_total FROM hh_verbal_consent hvc WHERE hvc.record_id = p_household_id;
    IF @v_total < 0 THEN
        SET v_hh_attempt_total = -1;
    ELSEIF @v_total = 1 OR @v_total = 2 OR @v_total = 3 THEN
        SET v_hh_attempt_total = @v_total;
    ELSE
        SET v_hh_attempt_total = 0;
    END IF;
    RETURN v_hh_attempt_total;
END $$
DELIMITER ;

/**
<|-----------___________----------___________-----------___________-------------|>
-- targeted group of record IDs against the count, saving this for later :' :)
     SELECT hvc.record_id, COUNT(*) as attempt_id
     FROM hh_verbal_consent hvc
     WHERE record_id = p_household_id
     GROUP BY hvc.record_id;
<|-----------___________------------___________-----------___________-----------|>
**/
