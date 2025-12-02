/**
 * Utility to remove piped option from REDCap choice format.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 27.01.24
 * @since 0.0.1
 * @alias Trimmer.
 * @param TEXT
 * @return TEXT
 */
DROP FUNCTION IF EXISTS `useAutoChoiceTrimmer`;
DELIMITER $$
CREATE FUNCTION useAutoChoiceTrimmer(p_txt TEXT)
    RETURNS TEXT
    NOT DETERMINISTIC
BEGIN
    DECLARE v_text TEXT;

    SET @piped_choice_pos = LOCATE('{', p_txt); -- find the location of the opening bracket
    SET @text = LEFT(p_txt, (@piped_choice_pos - 1)); -- get leftmost string
    SET v_text = TRIM(@text); -- removing excessive internal spaces
    RETURN v_text;
END $$
DELIMITER ;
