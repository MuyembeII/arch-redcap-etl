/**
 * Capitalize the first letter of every word in a string
 *
 * @author Gift Jr <muyembegift@gmail.com> | 24.03.25
 * @since 0.0.1
 * @alias Upper Case Transformer | useStringCapFirst .
 * @param Free Text | un-formatted text
 * @return TEXT | formatted-text
 */
DROP FUNCTION IF EXISTS `useStringCapFirst`;
DELIMITER $$
CREATE FUNCTION useStringCapFirst(p_free_text MEDIUMTEXT)
    RETURNS MEDIUMTEXT
    DETERMINISTIC
BEGIN
    DECLARE len MEDIUMINT;
    DECLARE i MEDIUMINT;

    SET len = CHAR_LENGTH(p_free_text);
    SET p_free_text = LOWER(p_free_text);
    SET i = 0;

    WHILE (i < len)
        DO
            IF (MID(p_free_text, i, 1) = ' ' OR i = 0) THEN
                IF (i < len) THEN
                    SET p_free_text = CONCAT(
                            LEFT(p_free_text, i),
                            UPPER(MID(p_free_text, i + 1, 1)),
                            RIGHT(p_free_text, len - i - 1)
                                      );
                END IF;
            END IF;
            SET i = i + 1;
        END WHILE;

    RETURN p_free_text;
END $$
DELIMITER ;