/**
 * Get WRA age at the time of the visit
 *
 * @author Gift Jr <muyembegift@gmail.com> | 03.02.25
 * @since 0.0.1
 * @alias Get WRA Age.
 * @param Visit Date - the current visit date
 * @param WRA Record ID - the participant Record ID
 * @return INT age
 */
DROP FUNCTION IF EXISTS `get_WRA_Age`;
DELIMITER $$
CREATE FUNCTION get_WRA_Age(p_visit_date DATE, p_record_id VARCHAR(6))
    RETURNS INT
    NOT DETERMINISTIC
BEGIN
    DECLARE v_age INT;
    -- A. Fetch D.O.B from baseline enrollment
    SELECT v1.brthdat, v1.estimated_age
    INTO @v_dob, @v_est_age
    FROM wra_forms_repeating_instruments v1
    WHERE v1.record_id = p_record_id
      AND v1.wra_age > 0
    LIMIT 1;
    IF @v_dob = '' OR @v_dob IS NULL THEN
        -- B. If D.O.B is not available, use estimated age.
        SET v_age = @v_est_age;
    ELSE
        -- C. Calculation, leap year edge cases covered.
        SET v_age = TIMESTAMPDIFF(YEAR, @v_dob, p_visit_date);
    END IF;
    RETURN v_age;
END $$

DELIMITER ;
