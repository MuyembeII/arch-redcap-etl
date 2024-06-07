/**
 * Returns the current visit number of a household
 *
 * @author Gift Jr <muyembegift@gmail.com> | 24.01.24
 * @since 0.0.1
 * @alias Get HH Visit Number
 * @param mediumint p_household_id Household/Record ID
 * @return smallint HH Visit Number
 * @notes Variables convention must be consistent. Args in the param must be prefixed -
 *        with 'p_' and variables with 'v_'. Use user-defined variables to store SELECT results.
 */
DROP FUNCTION if EXISTS `getHouseholdCurrentVisitNumber`;
DELIMITER $$
CREATE FUNCTION getHouseholdCurrentVisitNumber(p_household_id MEDIUMINT) RETURNS DECIMAL(2, 1)
    NOT DETERMINISTIC
BEGIN
    DECLARE v_hh_visit_number DECIMAL(2, 1);
    SET @v_baseline_visit_date = NULL;
    SET @v_fu_visit_date = NULL;
    -- Collect visit date by REDCap HH Enumeration events into session data variables
    SET @v_baseline_visit_date := (SELECT DISTINCT hhe_interview_date
                                  FROM hh_enumeration
                                  WHERE redcap_repeat_instrument = 'household_enumeration'
                                    AND record_id = p_household_id
                                  LIMIT 1);
    SET @v_fu_visit_date := (SELECT DISTINCT fu_hhe_interview_date
                            FROM hh_fu_enumeration
                            WHERE redcap_repeat_instrument = 'household_enumeration'
                              AND record_id = p_household_id
                            LIMIT 1);

    IF @v_fu_visit_date IS NOT NULL THEN
        SET v_hh_visit_number = 2.0;
    ELSEIF @v_baseline_visit_date IS NOT NULL THEN
        SET v_hh_visit_number = 1.0;
    ELSE
        SET v_hh_visit_number = 0.0;
    END IF;
    RETURN v_hh_visit_number;
END $$
DELIMITER ;
