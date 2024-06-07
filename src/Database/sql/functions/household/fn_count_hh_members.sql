/**
 * Returns a count of all screened HH Members >= 12 years
 *
 * @author Gift Jr <muyembegift@gmail.com> | 11.09.23
 * @since 0.0.1
 * @alias Count Screened Household Members By Screening ID
 * @return Number of Members Screened
 */
DROP FUNCTION IF EXISTS `getScreenedHouseholdMembers`;
DELIMITER $$
CREATE FUNCTION getScreenedHouseholdMembers(p_screening_id varchar(14))
    RETURNS INT
    NOT DETERMINISTIC
BEGIN
    DECLARE v_screened_member_count INT;

    SET v_screened_member_count = (SELECT COUNT(hhe.hhe_hh_member_id)
                                   FROM hh_enumeration hhe
                                   WHERE hhe.hh_scrn_num_obsloc = p_screening_id AND hhe.age_scorres >= 12);

    -- return the count
    RETURN (v_screened_member_count);

END $$

DELIMITER ;
