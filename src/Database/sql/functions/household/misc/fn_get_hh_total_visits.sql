/**
 * Returns the total visit interactions of a household. The visit number is
 * queried by the REDCap event names starting with the initial visit at baseline.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 24.01.24
 * @since 0.0.1
 * @alias Get HH Visit Total
 * @param mediumint p_household_id Household/Record ID
 * @return smallint HH Visit Total
 */
DROP FUNCTION if EXISTS `getHouseholdVisitTotal`;
DELIMITER $$
CREATE FUNCTION getHouseholdVisitTotal(p_household_id mediumint)
    RETURNS TINYINT
    NOT DETERMINISTIC
BEGIN
    DECLARE v_hh_visit_total TINYINT;
    SET @v_baseline_visit_date = (SELECT DISTINCT hhe_interview_date
                                  FROM hh_enumeration
                                  WHERE redcap_repeat_instrument = 'household_enumeration'
                                    AND record_id = p_household_id
                                  LIMIT 1);
    SET @v_fu_visit_date = (SELECT DISTINCT fu_hhe_interview_date
                            FROM hh_fu_enumeration
                            WHERE redcap_repeat_instrument = 'household_enumeration'
                              AND record_id = p_household_id
                            LIMIT 1);
    IF @v_fu_visit_date > @v_baseline_visit_date THEN
        SET v_hh_visit_total = 2;
    ELSE
        SET v_hh_visit_total = 1;
    END IF;
    RETURN v_hh_visit_total;
END $$
DELIMITER ;
