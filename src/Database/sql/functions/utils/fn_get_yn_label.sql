/**
 * Get Yes OR No label from a standard nullable bit literal
 *
 * @author Gift Jr <muyembegift@gmail.com> | 11.02.25
 * @since 0.0.1
 * @alias Get Yes Or No Label.
 * @param BIT literal - 1(Yes), 0(No)
 * @return VARCHAR(3) Yes OR No label
 */
DROP FUNCTION IF EXISTS `get_YN_Label`;
DELIMITER $$
CREATE FUNCTION get_YN_Label(p_literal BIT)
    RETURNS VARCHAR(3)
    NOT DETERMINISTIC
BEGIN
    DECLARE v_yn_label VARCHAR(3);
    IF p_literal = 1 THEN
        SET v_yn_label = 'Yes';
    ELSEIF p_literal = 0 THEN
        SET v_yn_label = 'No';
    ELSE
        SET v_yn_label = NULL;
    END IF;
    RETURN v_yn_label;
END $$

DELIMITER ;
