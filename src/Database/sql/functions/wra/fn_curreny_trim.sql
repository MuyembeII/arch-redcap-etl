/**
 * Utility to remove leading, trailing, and excessive internal whitespace from cash amount
 *
 * @author Gift Jr <muyembegift@gmail.com> | 19.04.25
 * @since 0.0.1
 * @alias Trimmer.
 * @param TEXT
 * @return TEXT
 */
DROP FUNCTION IF EXISTS `useCurrencyTrimmer`;
DELIMITER $$
CREATE FUNCTION useCurrencyTrimmer(p_txt TEXT)
    RETURNS TEXT
    NOT DETERMINISTIC
BEGIN
    DECLARE v_text TEXT;
    SET @text = REGEXP_REPLACE(p_txt, '^[\r\n ]*(.*)', '\\1'); -- removing whitespaces and newlines
    SET @text = REGEXP_REPLACE(@text, '[[:space:]]+', ' '); -- removing excessive internal spaces
    SET v_text = REGEXP_REPLACE(@text, '\\D', ''); -- replace all non-digit characters
    RETURN v_text;
END $$

DELIMITER ;
