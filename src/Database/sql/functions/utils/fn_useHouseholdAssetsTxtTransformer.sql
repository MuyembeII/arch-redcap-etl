/**
 * Get cleaned HH asset
 *
 * @author Gift Jr <muyembegift@gmail.com> | 02.04.25
 * @since 0.0.1
 * @alias Upper Case Transformer | useCapFirstChar .
 * @param Free Text | un-formatted text
 * @return TEXT | formatted-text
 */
DROP FUNCTION IF EXISTS `useHH_AssetsTxtTransformer`;
DELIMITER $$
CREATE FUNCTION useHH_AssetsTxtTransformer(p_free_text MEDIUMTEXT)
    RETURNS TINYTEXT
    DETERMINISTIC
BEGIN
    DECLARE v_hh_fmt_txt TINYTEXT;
    SET @v_txt = SUBSTR(p_free_text, 3);
    SET @v_txt = CONCAT(UCASE(SUBSTRING(@v_txt, 1, 1)), LOWER(SUBSTRING(@v_txt, 2)));
    SET v_hh_fmt_txt = @v_txt;
    RETURN v_hh_fmt_txt;
END $$
DELIMITER ;