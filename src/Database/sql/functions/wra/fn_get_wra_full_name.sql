/**
 * Returns Formatted WRA Full Name.
 * @author Gift Jr <muyembegift@gmail.com> | 07.04.25
 * @since 0.0.1
 * @alias Get WRA Name.
 * @param BIGINT | AUX ID
 * @return TEXT | Full Name
 */
DROP FUNCTION IF EXISTS `get_WRA_FullName`;
DELIMITER $$
CREATE FUNCTION arch_etl_db.get_WRA_FullName(p_aux_id BIGINT)
    RETURNS TINYTEXT
    NOT DETERMINISTIC
BEGIN
    DECLARE v_full_name TINYTEXT;

    DECLARE v_first_name TINYTEXT;
    DECLARE v_middle_name TINYTEXT;
    DECLARE v_last_name TINYTEXT;

    SELECT useAutoTrimmer(v1.fname_scorres),
           useAutoTrimmer(v1.mname_scorres),
           useAutoTrimmer(v1.lname_scorres)
    INTO @v_fname,
        @v_mname,
        @v_lname
    FROM wra_forms_repeating_instruments v1
    WHERE v1.wra_forms_repeating_instruments_id = p_aux_id;

    SET v_first_name = CONCAT(UCASE(SUBSTRING(@v_fname, 1, 1)), LOWER(SUBSTRING(@v_fname, 2)));
    SET v_middle_name = CONCAT(UCASE(SUBSTRING(@v_mname, 1, 1)), LOWER(SUBSTRING(@v_mname, 2)));
    SET v_last_name = CONCAT(UCASE(SUBSTRING(@v_lname, 1, 1)), LOWER(SUBSTRING(@v_lname, 2)));

    IF @v_mname = '' OR @v_mname IS NULL THEN
        SET v_full_name = CONCAT_WS(' ', v_first_name, v_last_name);
    ELSE
        SET v_full_name = CONCAT_WS(' ', v_first_name, v_middle_name, v_last_name);
    END IF;

    RETURN v_full_name;
END $$

DELIMITER ;
