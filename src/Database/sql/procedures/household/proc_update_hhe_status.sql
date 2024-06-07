DROP PROCEDURE IF EXISTS `UpdateHHEnumerationStatus`;
DELIMITER $$
CREATE PROCEDURE UpdateHHEnumerationStatus()
BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
        BEGIN
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error = CONCAT_WS(' ', 'HH ENUM DATA UPDATE OPS ERROR; ', @errno, '(', @sqlstate, '):', @text);
            SELECT @full_error;
            RESIGNAL;
        END;

    START TRANSACTION;
    -- Update Gender
    UPDATE hh_enumeration hhe
    SET hhe.sex         = 2,
        hhe.hhe_sex_txt = 'Female'
    WHERE hhe.sex = 0 OR hhe.sex = 2 AND hhe.hhe_sex_txt = '';

    UPDATE hh_enumeration hhe
    SET hhe.hhe_sex_txt = 'Male'
    WHERE hhe.redcap_repeat_instance = 1
      AND hhe.sex = 1;

    -- Update Eligibility
    UPDATE hh_enumeration hhe
    SET hhe.hhe_member_eligibility = 'ELIGIBLE'
    WHERE hhe.hhe_member_eligibility = ''
      AND (hhe.age_scorres >= 15 AND hhe.age_scorres <= 49)
      AND hhe.sex = 2
      AND hhe.hhe_p_live_here = 1;

    -- Update Eligibility
    UPDATE hh_enumeration hhe
    SET hhe.hhe_member_eligibility = 'NOT ELIGIBLE'
    WHERE hhe.hhe_member_eligibility = ''
        AND (hhe.age_scorres < 15 OR hhe.age_scorres > 49)
       OR hhe.sex = 1
       OR hhe.hhe_p_live_here != 1;
    COMMIT;

    -- flag completion
    SELECT 1 as `status`;

END $$

DELIMITER ;
