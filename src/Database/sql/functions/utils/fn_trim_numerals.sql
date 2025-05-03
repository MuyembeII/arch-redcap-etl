/**
 * Simple utility to trim numerals from a given literal.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 03.05.25
 * @since 0.0.1
 * @alias Numeral Trimmer.
 * @param CHAR | raw literal with numerals
 * @return CHAR | trimmed string
 */
DROP FUNCTION IF EXISTS `useNumeralTrimmer`;
DELIMITER $$
CREATE FUNCTION useNumeralTrimmer(p_txt CHAR(128))
    RETURNS CHAR(128)
    NOT DETERMINISTIC
BEGIN
    DECLARE v_index, v_txt_length SMALLINT DEFAULT 1;
    DECLARE ret CHAR(128) DEFAULT '';
    DECLARE v_literal CHAR(1);
    SET v_txt_length = CHAR_LENGTH(p_txt);
    REPEAT
        BEGIN
            SET v_literal = MID(p_txt, v_index, 1);
            IF v_literal REGEXP '[-/]' THEN
                SET ret = CONCAT(ret, v_literal);
            END IF;
            SET v_index = v_index + 1;
        END;
    UNTIL v_index > v_txt_length END REPEAT;
    RETURN ret;
END $$
DELIMITER ;