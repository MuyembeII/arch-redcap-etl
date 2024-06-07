/**
 * Returns a count of all eligible WRA's in HH
 *
 * @author Gift Jr <muyembegift@gmail.com> | 11.09.23
 * @since 0.0.1
 * @alias Count Eligible WRA By Screening ID
 * @return Number of WRA's
 */
DROP FUNCTION if EXISTS `countHHEligibleWRAByScreeningID`;
DELIMITER $$
CREATE FUNCTION countHHEligibleWRAByScreeningID(p_screening_id varchar(14))
    RETURNS TINYINT
    NOT DETERMINISTIC
BEGIN
    DECLARE v_wra_count SMALLINT;
    SET v_wra_count = (SELECT COUNT(hhe.hhe_id)
                       FROM hh_enumeration hhe
                       WHERE hhe.hhe_member_eligibility = 'ELIGIBLE'
                         AND hhe.hh_scrn_num_obsloc = p_screening_id);

    -- return the count
    RETURN (v_wra_count);

END $$

DELIMITER ;
