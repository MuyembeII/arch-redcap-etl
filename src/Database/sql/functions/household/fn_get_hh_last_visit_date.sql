/**
 * Returns the last visit date interview interaction of a household. The REDCap
 * ARCH Pre-Screening HH Enumeration Forms will be used as source of visit dates
 * since it appears as the last point of HH dara collection.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 24.01.24
 * @since 0.0.1
 * @alias Get HH Last Visit Date
 * @param mediumint p_household_id Household/Record ID
 * @return date HH Last Visit Date
 */
DROP FUNCTION IF EXISTS `getHouseholdLastVisitDate`;
DELIMITER $$
CREATE FUNCTION getHouseholdLastVisitDate(p_household_id MEDIUMINT)
    RETURNS DATE
    NOT DETERMINISTIC
BEGIN
    DECLARE v_last_visit_date DATE;
    -- Collect visit date by REDCap events
    SET @v_baseline_visit_date =
        (SELECT DISTINCT hhe_interview_date
         FROM hh_enumeration
         WHERE redcap_repeat_instrument = 'household_enumeration'
           AND record_id = p_household_id LIMIT 1);
    SET @v_fu_visit_date =
        (SELECT DISTINCT fu_hhe_interview_date
         FROM hh_fu_enumeration
         WHERE redcap_repeat_instrument = 'household_enumeration'
           AND record_id = p_household_id LIMIT 1);
    -- Round-robbin filtering starting with the last visit/event
    IF @v_fu_visit_date > @v_baseline_visit_date THEN
        SET v_last_visit_date = @v_fu_visit_date;
    ELSE
        SET v_last_visit_date = @v_baseline_visit_date;
    END IF;
    RETURN v_last_visit_date;
END $$
DELIMITER ;
