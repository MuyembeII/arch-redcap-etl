/**
 * Returns HH member enumeration completion status of a household
 *
 * @author Gift Jr <muyembegift@gmail.com> | 15.09.23
 * @since 0.0.1
 * @alias Is household enumeration completed?
 * @param varchar Household Screening ID
 * @return varchar Household Member Enumeration Status
 */
DROP FUNCTION IF EXISTS `isHouseholdEnumerationCompleted`;
DELIMITER $$
CREATE FUNCTION isHouseholdEnumerationCompleted(p_screening_id varchar(14))
    RETURNS VARCHAR(32)
    NOT DETERMINISTIC
BEGIN

    DECLARE v_is_hh_enumerated VARCHAR(32);
    DECLARE v_females_expected INT;
    DECLARE v_enumerated_members VARCHAR(32);

    SELECT hhe.hhe_female_count
    INTO v_females_expected
    FROM hh_enumeration hhe
    WHERE hhe.hh_scrn_num_obsloc = p_screening_id
      AND hhe.redcap_repeat_instance = 1;

    SELECT COUNT(hhe.hhe_id)
    INTO v_enumerated_members
    FROM hh_enumeration hhe
    WHERE hhe.hh_scrn_num_obsloc = p_screening_id
      AND hhe.hhe_member_eligibility = 'ELIGIBLE'
      AND hhe.household_enumeration_complete = 2;

    IF v_females_expected > 0 AND v_enumerated_members <= v_females_expected THEN
        SET v_is_hh_enumerated = 'Completed';
    ELSEIF v_enumerated_members > v_females_expected THEN
        SET v_is_hh_enumerated = 'Completed|Outliers';
    ELSEIF v_females_expected > 0 AND v_enumerated_members < 1 THEN
        SET v_is_hh_enumerated = 'Incomplete';
    ELSE
        SET v_is_hh_enumerated = 'Undefined';
    END IF;

    RETURN (v_is_hh_enumerated);

END $$

DELIMITER ;
