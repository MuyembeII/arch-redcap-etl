/**
 * Returns verbal consent status of a household
 *
 * @author Gift Jr <muyembegift@gmail.com> | 13.09.23
 * @since 0.0.1
 * @alias Is household verbal consent given.
 * @param varchar Household Screening ID
 * @return Verbal Consent Status
 */
DROP FUNCTION IF EXISTS `isHouseholdVerbalConsentGiven`;
DELIMITER $$
CREATE FUNCTION isHouseholdVerbalConsentGiven(p_screening_id varchar(14))
    RETURNS VARCHAR(32)
    NOT DETERMINISTIC
BEGIN
    DECLARE v_is_verbal_consent_given VARCHAR(32);

    DECLARE v_vc_hh_available_1 TINYINT;
    DECLARE v_vc_hh_available_2 TINYINT;
    DECLARE v_vc_hh_available_3 TINYINT;

    DECLARE v_vc_hhm_ebn_1 BIT;
    DECLARE v_vc_hhm_ebn_2 BIT;
    DECLARE v_vc_hhm_ebn_3 BIT;

    DECLARE v_vc_vc_given_by_adult_1 BIT;
    DECLARE v_vc_vc_given_by_adult_2 BIT;
    DECLARE v_vc_vc_given_by_adult_3 BIT;


    SELECT vc.vc_hh_available
    INTO v_vc_hh_available_1
    FROM hh_verbal_consent vc
    WHERE vc.redcap_repeat_instance = 1
      AND vc.hh_scrn_num_obsloc = p_screening_id;

    SELECT vc.vc_hh_available
    INTO v_vc_hh_available_2
    FROM hh_verbal_consent vc
    WHERE vc.redcap_repeat_instance = 2
      AND vc.hh_scrn_num_obsloc = p_screening_id;

    SELECT vc.vc_hh_available
    INTO v_vc_hh_available_3
    FROM hh_verbal_consent vc
    WHERE vc.redcap_repeat_instance = 3
      AND vc.hh_scrn_num_obsloc = p_screening_id;

    SELECT vc.vc_hhm_ebn
    INTO v_vc_hhm_ebn_1
    FROM hh_verbal_consent vc
    WHERE vc.redcap_repeat_instance = 1
      AND vc.hh_scrn_num_obsloc = p_screening_id;

    SELECT vc.vc_hhm_ebn
    INTO v_vc_hhm_ebn_2
    FROM hh_verbal_consent vc
    WHERE vc.redcap_repeat_instance = 2
      AND vc.hh_scrn_num_obsloc = p_screening_id;

    SELECT vc.vc_hhm_ebn
    INTO v_vc_hhm_ebn_3
    FROM hh_verbal_consent vc
    WHERE vc.redcap_repeat_instance = 3
      AND vc.hh_scrn_num_obsloc = p_screening_id;

    SELECT vc.vc_vc_given_by_adult
    INTO v_vc_vc_given_by_adult_1
    FROM hh_verbal_consent vc
    WHERE vc.redcap_repeat_instance = 1
      AND vc.hh_scrn_num_obsloc = p_screening_id;

    SELECT vc.vc_vc_given_by_adult
    INTO v_vc_vc_given_by_adult_2
    FROM hh_verbal_consent vc
    WHERE vc.redcap_repeat_instance = 2
      AND vc.hh_scrn_num_obsloc = p_screening_id;

    SELECT vc.vc_vc_given_by_adult
    INTO v_vc_vc_given_by_adult_3
    FROM hh_verbal_consent vc
    WHERE vc.redcap_repeat_instance = 3
      AND vc.hh_scrn_num_obsloc = p_screening_id;

    /*------------------------------------------------------------------------------------------------*/

    IF v_vc_hh_available_3 = 1 AND v_vc_vc_given_by_adult_3 = 1 THEN
        SET v_is_verbal_consent_given = 'Consented';
    ELSEIF v_vc_hh_available_3 = 2 OR v_vc_hh_available_3 = 3 OR v_vc_hh_available_3 = 6 OR v_vc_hhm_ebn_3 THEN
        SET v_is_verbal_consent_given = 'Differed';
    ELSEIF v_vc_hh_available_2 = 1 AND v_vc_vc_given_by_adult_2 = 1 THEN
        SET v_is_verbal_consent_given = 'Consented';
    ELSEIF v_vc_hh_available_2 = 2 OR v_vc_hh_available_2 = 3 OR v_vc_hh_available_2 = 6 OR v_vc_hhm_ebn_2 THEN
        SET v_is_verbal_consent_given = 'Differed';
    ELSEIF v_vc_hh_available_1 = 1 AND v_vc_vc_given_by_adult_1 = 1 THEN
        SET v_is_verbal_consent_given = 'Consented';
    ELSEIF v_vc_hh_available_1 = 2 OR v_vc_hh_available_1 = 3 OR v_vc_hh_available_1 = 6 OR v_vc_hhm_ebn_1 THEN
        SET v_is_verbal_consent_given = 'Differed';
    ELSE
        SET v_is_verbal_consent_given = 'Un-consented';
    END IF;

    -- return the status
    RETURN (v_is_verbal_consent_given);

END $$

DELIMITER ;
