/**
 * Get Formatted Paragraph from Text Description Controls
 *
 * @author Gift Jr <muyembegift@gmail.com> | 12.03.25
 * @since 0.0.1
 * @alias Paragraph Transformer | useTextTransformer .
 * @param Free Text | un-formatted paragraphs
 * @return TEXT | formatted-paragraph
 */
DROP FUNCTION IF EXISTS `useTextTransformer`;
DELIMITER $$
CREATE FUNCTION useTextTransformer(p_free_text TEXT)
    RETURNS TEXT
    NOT DETERMINISTIC
BEGIN
    DECLARE v_free_text TEXT;
    -- Perform data cleaning
    SET @v_paragraph = REGEXP_REPLACE(p_free_text, '[[:space:]]+', ' ');
    -- remove double spaces
    -- load cleaned paragraph & return new free text
    SET v_free_text = @v_paragraph;
    RETURN v_free_text;
END $$
DELIMITER ;