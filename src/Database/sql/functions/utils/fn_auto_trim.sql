/**
 * Utility to remove leading, trailing, and excessive internal whitespace from strings
 *
 * @author Gift Jr <muyembegift@gmail.com> | 27.01.24
 * @since 0.0.1
 * @alias Trimmer.
 * @param TEXT
 * @return TEXT
 */
DROP FUNCTION IF EXISTS `useAutoTrimmer`;
DELIMITER $$
CREATE FUNCTION useAutoTrimmer(p_txt TEXT)
    RETURNS TEXT
    NOT DETERMINISTIC
BEGIN
    DECLARE v_text TEXT;
    SET @text = REGEXP_REPLACE(p_txt, '^[\r\n ]*(.*)', '\\1'); -- removing whitespaces and newlines
    SET v_text = REGEXP_REPLACE(@text, '[[:space:]]+', ' '); -- removing excessive internal spaces
    RETURN v_text;
END $$

DELIMITER ;
