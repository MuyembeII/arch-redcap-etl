/**
 * Returns HH screening and verification status of a household
 *
 * @author Gift Jr <muyembegift@gmail.com> | 16.09.23
 * @since 0.0.1
 * @alias Is household verified?
 * @param varchar Household Screening ID
 * @return varchar Household Verification Status
 */
DROP FUNCTION IF EXISTS `getHouseholdVerificationStatus`;
DELIMITER $$
CREATE FUNCTION getHouseholdVerificationStatus(p_screening_id varchar(14))
    RETURNS VARCHAR(32)
    NOT DETERMINISTIC
BEGIN
    DECLARE v_hh_verification_status VARCHAR(32);

    DECLARE v_hh_verification_outcome TINYINT;

    SELECT hhs.standing_obsloc
    INTO v_hh_verification_outcome
    FROM hh_screening hhs
    WHERE hhs.hh_scrn_num_obsloc = p_screening_id
      AND hhs.household_screening_id_verification_complete = 2;


    IF v_hh_verification_outcome = 1 THEN
        SET v_hh_verification_status = 'Verified';
    ELSE
        SET v_hh_verification_status = 'Un-verified';
    END IF;

    -- return the status
    RETURN (v_hh_verification_status);

END;

