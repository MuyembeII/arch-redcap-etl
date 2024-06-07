/**
 * @description Returns the HH current attempt made by an RA
 * for a particular structure querying the verbal consent
 * baseline visit.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 27.01.24
 * @since 0.0.1
 * @alias Get HH Current Attempt
 * @param mediumint p_household_id Household/Record ID
 * @return smallint HH Attempt Total. -> 0.0/0.1/0.2/0.3
 */
DROP FUNCTION if EXISTS `getHouseholdCurrentAttempt`;
DELIMITER $$
CREATE FUNCTION getHouseholdCurrentAttempt(p_household_id mediumint)
    RETURNS decimal(1, 1)
    NOT deterministic
BEGIN
    DECLARE v_hh_current_attempt decimal(1, 1) SIGNED;
    SELECT MAX(hvc.redcap_repeat_instance)
    INTO @v_attempt_count
    FROM hh_verbal_consent hvc
    WHERE hvc.record_id = p_household_id
    LIMIT 1;

    IF @v_attempt_count = 3 THEN
        SET v_hh_current_attempt = 0.3;
    ELSEIF @v_attempt_count = 2 THEN
        SET v_hh_current_attempt = 0.2;
    ELSEIF @v_attempt_count = 1 THEN
        SET v_hh_current_attempt = 0.1;
    ELSE
        SET v_hh_current_attempt = 0.0;
    END IF;
    RETURN v_hh_current_attempt;
END $$
DELIMITER ;
