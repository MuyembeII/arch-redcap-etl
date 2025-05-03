/**
 * Utility to format date string to 8601 ISO standard to reconcile discrepancies that can result
 * from the various day–date conventions, cultures and time zones that impact data collection.
 * Also scripted is partial date handling, this is inevitable for time specific questions. A
 * total of four(4) cases have been distinguished.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 30.04.25
 * @since 0.0.1
 * @alias Date Handler.
 * @param TEXT | raw date
 * @return DATE | transformed ISO date
 * @see https://www.iso.org/iso-8601-date-and-time-format.html
 * @see https://bengribaudo.com/blog/2011/12/16/1721/storing-incomplete-partial-dates-in-sql-databases
 */
DROP FUNCTION IF EXISTS `use_ISO_DateTrimmer`;
DELIMITER $$
CREATE FUNCTION use_ISO_DateTrimmer(p_date_txt TEXT)
    RETURNS DATE
    NOT DETERMINISTIC
BEGIN
    DECLARE v_fmt_iso_date DATE;
    DECLARE v_day VARCHAR(2) DEFAULT '00';
    DECLARE v_month VARCHAR(2) DEFAULT '00';
    DECLARE v_year VARCHAR(4) DEFAULT '0000';
    -- Option to allow storage for partial dates
    SET sql_mode = ALLOW_INVALID_DATES;
    SET v_fmt_iso_date = STR_TO_DATE(CONCAT_WS('-', v_year, v_month, v_day), '%d,%m,%Y');
    SET @sd1 = '';
    SET @sd2 = '';
    SET @sd3 = '';
    SET @sd4 = '';

    IF LENGTH(p_date_txt) = 10 THEN
        -- CASE 1: Complete long date e.g 23/11/2024, 04-09-1988. LEN = 10.
        SET v_day = LEFT(p_date_txt, 2);
        SET v_month = MID(p_date_txt, 4, 2);
    ELSEIF (LENGTH(p_date_txt) > 7 AND LENGTH(p_date_txt) < 10) AND LENGTH(useNumeralTrimmer(p_date_txt)) = 2 THEN
        -- CASE 2: Complete short dates E.g. 01-05-24, 4/12/2023, 8-8-24, 15/9/2023 LEN = 8 : 9.
        SET @sd1 = SUBSTR(p_date_txt, 2, 1);
        IF @sd1 REGEXP '[-/]' THEN
            -- single digit day e.g. 4/12/2023, 8-8-24
            SET v_day = LPAD(LEFT(p_date_txt, 1), 2, '00');
            SET @sd2 = SUBSTR(p_date_txt, 4, 1);
            IF @sd2 REGEXP '[-/]' THEN
                -- single digit day & month e.g 8-8-24
                SET v_month = LPAD(MID(p_date_txt, 3, 1), 2, '00');
            ELSE
                -- single digit day & double digit month e.g 4/12/2023
                SET v_month = LPAD(MID(p_date_txt, 3, 2), 2, '00');
            END IF;
        ELSE
            -- double digit day e.g 01-05-24, 15/9/2023
            SET v_day = LPAD(LEFT(p_date_txt, 2), 2, '00');
            SET @sd3 = SUBSTR(p_date_txt, 5, 1);
            IF @sd3 REGEXP '[-/]' THEN
                -- double digit day & single digit month e.g 15/9/2023
                SET v_month = LPAD(MID(p_date_txt, 4, 1), 2, '00');
            ELSE
                -- double digit month & double digit month e.g 01-05-24
                SET v_month = LPAD(MID(p_date_txt, 4, 2), 2, '00');
            END IF;

        END IF;
    ELSEIF (LENGTH(p_date_txt) >= 5 AND LENGTH(p_date_txt) <= 10) AND LENGTH(useNumeralTrimmer(p_date_txt)) = 1 THEN
        -- CASE 4: Partial Date(Missing Day) e.g. 11/2024, 9-1988, 02-23. LEN = 5 : 7
        SET @sd4 = SUBSTR(p_date_txt, 2, 1);
        SET v_day = '00';
        IF @sd4 REGEXP '[-/]' THEN
            -- single digit month e.g. 9-1988
            SET v_month = LPAD(LEFT(p_date_txt, 1), 2, '00');
        ELSE
            -- double digit month e.g. 11/2024
            SET v_month = LPAD(LEFT(p_date_txt, 2), 2, '00');
        END IF;
    ELSE
        RETURN v_fmt_iso_date;
    END IF;
    -- titenga ma pendo yabili yali ku mpela, kusogolo izibika kudala ni 20 siima chinja
    SET v_year = LPAD(RIGHT(p_date_txt, 2), 4, 20);
    SET v_fmt_iso_date = STR_TO_DATE(CONCAT_WS(',', v_day, v_month, v_year), '%d,%m,%Y');
    RETURN v_fmt_iso_date;
END $$

DELIMITER ;