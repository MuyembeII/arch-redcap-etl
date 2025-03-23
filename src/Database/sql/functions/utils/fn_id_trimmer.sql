/**
 * Utility to remove leading, trailing, and excessive internal whitespace, and parentheses from ARCH ID's
 *
 * @author Gift Jr <muyembegift@gmail.com> | 27.01.24
 * @since 0.0.1
 * @alias Trimmer.
 * @param TEXT
 * @return TEXT
 */
DROP FUNCTION IF EXISTS `useIdTrimmer`;
DELIMITER $$
CREATE FUNCTION useIdTrimmer(p_txt TEXT)
    RETURNS TEXT
    NOT DETERMINISTIC
BEGIN
    DECLARE v_text TEXT;
    SET @text = REGEXP_REPLACE(p_txt, '^[\r\n ]*(.*)', '\\1'); -- removing whitespaces and newlines
    SET @text = REGEXP_REPLACE(@text, '[[:space:]]+', ''); -- removing excessive internal spaces
    SET @text = REGEXP_REPLACE(@text, '\\(', ''); -- remove opening parenthesis
    SET v_text = REGEXP_REPLACE(@text, '\\)', ''); -- remove closing parenthesis
    RETURN v_text;
END $$

DELIMITER ;
