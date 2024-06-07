/**
 * Returns Household Screening status of a household
 *
 * @author Gift Jr <muyembegift@gmail.com> | 14.09.23
 * @since 0.0.1
 * @alias Get household screening status.
 * @param varchar Household Screening ID
 * @return Household Screening Status
 */
DROP FUNCTION if EXISTS `getHouseholdScreeningStatus`;
DELIMITER $$
CREATE FUNCTION getHouseholdScreeningStatus(p_screening_id varchar(14))
    RETURNS varchar(32)
    NOT DETERMINISTIC
BEGIN
    DECLARE v_hh_screening_status VARCHAR(32);
    DECLARE v_hh_standing_obsloc TINYINT;
    DECLARE v_hh_household_screening_id_verification_complete TINYINT;

    SELECT hhs.standing_obsloc
    INTO v_hh_standing_obsloc
    FROM hh_screening hhs
    WHERE hhs.hh_scrn_num_obsloc = p_screening_id;

    SELECT hhs.household_screening_id_verification_complete
    INTO v_hh_household_screening_id_verification_complete
    FROM hh_screening hhs
    WHERE hhs.hh_scrn_num_obsloc = p_screening_id;

    /*----------------------------------------------------------------------------------------------------------------*/

    IF v_hh_standing_obsloc = 0 THEN
        SET v_hh_screening_status = 'Dwelling Destroyed/Not Dwelling';
    ELSEIF v_hh_standing_obsloc = 2 THEN
        SET v_hh_screening_status = 'Dwelling Not Found';
    ELSEIF v_hh_standing_obsloc = 1 THEN
        SET v_hh_screening_status = 'Dwelling Available';
    ELSEIF v_hh_standing_obsloc = 1 AND v_hh_household_screening_id_verification_complete = 2 THEN
        SET v_hh_screening_status = 'Screened';
    ELSE
        SET v_hh_screening_status = 'Un-screened';
    END IF;

    -- return the screening status
    RETURN (v_hh_screening_status);

END $$

DELIMITER ;
