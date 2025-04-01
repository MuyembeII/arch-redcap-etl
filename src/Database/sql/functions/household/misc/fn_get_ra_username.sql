/**
 * Returns WRA Visit status
 *
 * @author Gift Jr <muyembegift@gmail.com> | 22.10.23
 * @since 0.0.1
 * @alias Get WRA visit status.
 * @param varchar Record ID
 * @return Visit Status
 */
DROP FUNCTION IF EXISTS `get_RA_Username`;
DELIMITER $$
CREATE FUNCTION get_RA_Username(ra_name VARCHAR(32))
    RETURNS VARCHAR(32)
    NOT DETERMINISTIC
BEGIN
    DECLARE v_ra_username VARCHAR(32);

    -- RA Name Sanitization
    SET @v_ra_name = LOWER(ra_name);
    SET @v_ra_name = TRIM(LEADING ' ' FROM ra_name); -- lets remove leading whitespace
    SET @v_ra_name = TRIM(TRAILING ' ' FROM ra_name);
    -- destructure first and last name
    SET @v_fn_index = LOCATE(' ', @v_ra_name);
    SET @v_first_name = TRIM(SUBSTRING(@v_ra_name, 1, @v_fn_index));
    -- SET @v_last_name = SUBSTRING_INDEX(@v_ra_name, ' ', -1);
    SET @v_last_name = TRIM(RIGHT(@v_ra_name, LENGTH(@v_ra_name) - INSTR(@v_ra_name, ' ')));

    IF @v_first_name = 'aaron' AND @v_last_name LIKE '%kaposamweo%' THEN
        SET v_ra_username = 'aaposamweo';
    ELSEIF @v_first_name = 'chiluba' AND @v_last_name LIKE '%mbulo%' THEN
        SET v_ra_username = 'cmbulo';
    ELSEIF @v_first_name = 'musanide' OR @v_first_name = 'chanda' AND @v_last_name LIKE '%banda%' THEN
        SET v_ra_username = 'cmusanide';
    ELSEIF (@v_first_name = 'chanda' OR @v_first_name = 'fidelia') AND @v_last_name LIKE '%mutale%' THEN
        SET v_ra_username = 'cmutale';
    ELSEIF @v_first_name = 'gift' AND @v_last_name LIKE '%miyombo%' THEN
        SET v_ra_username = 'gmiyombo';
    ELSEIF @v_first_name = 'george' AND @v_last_name LIKE '%muzyamba%' THEN
        SET v_ra_username = 'gmuzyamba';
    ELSEIF @v_first_name = 'inonge' AND @v_last_name LIKE '%likomba%' THEN
        SET v_ra_username = 'ilikomba';
    ELSEIF @v_first_name = 'josephine' AND @v_last_name LIKE '%daka%' THEN
        SET v_ra_username = 'jdaka';
    ELSEIF @v_first_name = 'laetitia' AND @v_last_name LIKE '%mulenga%' THEN
        SET v_ra_username = 'lmulenga';
    ELSEIF @v_first_name = 'milner' AND @v_last_name LIKE '%koni%' THEN
        SET v_ra_username = 'mkoni';
    ELSEIF @v_first_name = 'mpanza' AND @v_last_name LIKE '%siame%' THEN
        SET v_ra_username = 'msiame';
    ELSEIF @v_first_name = 'nico' AND @v_last_name LIKE '%jacobs%' THEN
        SET v_ra_username = 'njacobs';
    ELSEIF @v_first_name = 'norah' AND @v_last_name LIKE '%kangwa%' THEN
        SET v_ra_username = 'nkangwa';
    ELSEIF @v_first_name = 'regina' AND @v_last_name LIKE '%kangwa%' THEN
        SET v_ra_username = 'rkangwa';
    ELSEIF @v_first_name = 'sithembile' AND @v_last_name LIKE '%chanda%' THEN
        SET v_ra_username = 'schanda';
    ELSE
        SET v_ra_username = 'unknown';
    END IF;

    -- return REDCap username
    RETURN v_ra_username;

END $$

DELIMITER ;
