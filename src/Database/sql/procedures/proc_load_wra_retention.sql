/**
 * Load WRA retention data up until current date.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 01.10.24
 * @since 0.0.1
 * @alias Load WRA Retention Data
 */
DROP PROCEDURE IF EXISTS `Load_WRA_Retention_Data`;
DELIMITER $$
CREATE PROCEDURE Load_WRA_Retention_Data()
BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
        BEGIN
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS(' ', 'ERROR - Failed to load WRA retention data; ',
                              @errno, '(', @sqlstate, '):', @text);
            SELECT @full_error;
            RESIGNAL;
        END;

    /*Baseline Visit Aggregates*/
    SET @v_wra_visit_1_untraceable := 0;
    SET @v_wra_visit_1_deferred := 0;
    SET @v_wra_visit_1_extended_absence := 0;
    SET @v_wra_visit_1_ltfu := 0;
    SET @v_wra_visit_1_screened := 0;
    SET @v_wra_visit_1_screened_and_followed_up := 0;
    SET @v_wra_visit_1_remaining_total := 0;
    SET @v_wra_fu_1_visits_total := 0;

    /*First FU Visit Aggregates*/
    SET @v_wra_visit_2_untraceable := 0;
    SET @v_wra_visit_2_deferred := 0;
    SET @v_wra_visit_2_extended_absence := 0;
    SET @v_wra_visit_2_ltfu := 0;
    SET @v_wra_visit_2_screened := 0;
    SET @v_wra_visit_2_screened_and_followed_up := 0;
    SET @v_wra_visit_2_remaining_total := 0;
    SET @v_wra_fu_2_visits_total := 0;

    /*Second FU Visit Aggregates*/
    SET @v_wra_visit_3_untraceable := 0;
    SET @v_wra_visit_3_deferred := 0;
    SET @v_wra_visit_3_extended_absence := 0;
    SET @v_wra_visit_3_ltfu := 0;
    SET @v_wra_visit_3_screened := 0;
    SET @v_wra_visit_3_screened_and_followed_up := 0;
    SET @v_wra_visit_3_remaining_total := 0;
    SET @v_wra_fu_3_visits_due_total := 0;

    /*Third FU Visit Aggregates*/
    SET @v_wra_visit_4_untraceable := 0;
    SET @v_wra_visit_4_deferred := 0;
    SET @v_wra_visit_4_extended_absence := 0;
    SET @v_wra_visit_4_ltfu := 0;
    SET @v_wra_visit_4_screened := 0;
    SET @v_wra_visit_4_screened_and_followed_up := 0;
    SET @v_wra_visit_4_remaining_total := 0;
    SET @v_wra_fu_4_visits_total := 0;

    /*Fourth FU Visit Aggregates*/
    SET @v_wra_visit_5_untraceable := 0;
    SET @v_wra_visit_5_deferred := 0;
    SET @v_wra_visit_5_extended_absence := 0;
    SET @v_wra_visit_5_ltfu := 0;
    SET @v_wra_visit_5_screened := 0;
    SET @v_wra_visit_5_screened_and_followed_up := 0;
    SET @v_wra_visit_5_remaining_total := 0;
    SET @v_wra_fu_5_visits_total := 0;

    /*Fourth FU Visit Aggregates*/
    SET @v_wra_visit_6_untraceable := 0;
    SET @v_wra_visit_6_deferred := 0;
    SET @v_wra_visit_6_extended_absence := 0;
    SET @v_wra_visit_6_ltfu := 0;
    SET @v_wra_visit_6_screened := 0;
    SET @v_wra_visit_6_screened_and_followed_up := 0;
    SET @v_wra_visit_6_remaining_total := 0;
    SET @v_wra_fu_6_visits_total := 0;

    DROP TEMPORARY TABLE IF EXISTS wra_fu_visit_1_overview;
    CREATE TEMPORARY TABLE wra_fu_visit_1_overview
    (
        record_id                        BIGINT,
        screening_id                     VARCHAR(14),
        wra_ptid                         VARCHAR(6),
        last_visit_date                  DATE,
        follow_up_1_visit_date           DATE,
        follow_up_1_last_visit_date      DATE,
        follow_up_1_visit_date_days_late SMALLINT
    );

    DROP TEMPORARY TABLE IF EXISTS wra_fu_visit_2_overview;
    CREATE TEMPORARY TABLE wra_fu_visit_2_overview
    (
        record_id                        BIGINT,
        screening_id                     VARCHAR(14),
        wra_ptid                         VARCHAR(6),
        last_visit_date                  DATE,
        follow_up_2_visit_date           DATE,
        follow_up_2_last_visit_date      DATE,
        follow_up_2_visit_date_days_late SMALLINT
    );

    DROP TEMPORARY TABLE IF EXISTS wra_fu_visit_3_overview;
    CREATE TEMPORARY TABLE wra_fu_visit_3_overview
    (
        record_id                        BIGINT,
        screening_id                     VARCHAR(14),
        wra_ptid                         VARCHAR(6),
        last_visit_date                  DATE,
        follow_up_3_visit_date           DATE,
        follow_up_3_last_visit_date      DATE,
        follow_up_3_visit_date_days_late SMALLINT
    );

    DROP TEMPORARY TABLE IF EXISTS wra_fu_visit_4_overview;
    CREATE TEMPORARY TABLE wra_fu_visit_4_overview
    (
        record_id                        BIGINT,
        screening_id                     VARCHAR(14),
        wra_ptid                         VARCHAR(6),
        last_visit_date                  DATE,
        follow_up_4_visit_date           DATE,
        follow_up_4_last_visit_date      DATE,
        follow_up_4_visit_date_days_late SMALLINT
    );

    DROP TEMPORARY TABLE IF EXISTS wra_fu_visit_5_overview;
    CREATE TEMPORARY TABLE wra_fu_visit_5_overview
    (
        record_id                        BIGINT,
        screening_id                     VARCHAR(14),
        wra_ptid                         VARCHAR(6),
        last_visit_date                  DATE,
        follow_up_5_visit_date           DATE,
        follow_up_5_last_visit_date      DATE,
        follow_up_5_visit_date_days_late SMALLINT
    );

    START TRANSACTION;

    SET @v_wra_fu_1_visits_total = (SELECT COUNT(v1.record_id) as total FROM crt_wra_visit_1_overview v1);

    SET @v_wra_visit_1_remaining_total = 0;

    SET @v_wra_visit_1_ltfu = (SELECT COUNT(DISTINCT f1.record_id)
                               FROM crt_wra_visit_1_overview f1
                               WHERE f1.record_id NOT IN
                                     (SELECT v2.record_id FROM crt_wra_visit_2_overview v2));

    SET @v_wra_visit_1_screened = (SELECT COUNT(DISTINCT f1.record_id)
                                   FROM crt_wra_visit_2_overview f1
                                   WHERE f1.visit_outcome <> '');

    SET @v_wra_visit_1_screened_and_followed_up = (SELECT COUNT(DISTINCT f1.record_id)
                                                   FROM crt_wra_visit_2_overview f1
                                                   WHERE f1.visit_outcome IN ('Completed'));

    SET @v_wra_visit_1_extended_absence = (SELECT COUNT(DISTINCT f1.record_id)
                                           FROM crt_wra_visit_2_overview f1
                                           WHERE f1.visit_outcome IN ('Extended-Absence', 'No, Extended Absence'));

    SET @v_wra_visit_1_untraceable = (SELECT COUNT(DISTINCT f1.record_id)
                                      FROM crt_wra_visit_2_overview f1
                                      WHERE f1.visit_outcome = 'Untraceable');

    SET @v_wra_visit_1_deferred = (SELECT COUNT(DISTINCT f1.record_id)
                                   FROM crt_wra_visit_2_overview f1
                                   WHERE f1.visit_outcome = 'Incomplete');

    UPDATE crt_wra_retention ret
    SET ret.wra_visit_missed_appointment = @v_wra_visit_1_ltfu,
        ret.wra_visit_untraceable        = @v_wra_visit_1_untraceable,
        ret.wra_visit_deferred           = @v_wra_visit_1_deferred,
        ret.wra_visit_extended_absence   = @v_wra_visit_1_extended_absence,
        ret.wra_screened                 = @v_wra_visit_1_screened,
        ret.wra_screened_and_followed_up = @v_wra_visit_1_screened_and_followed_up,
        ret.wra_visits_total             = @v_wra_fu_1_visits_total,
        ret.wra_visit_total_remaining    = @v_wra_visit_1_remaining_total
    WHERE ret.visit_number = 2.0;

    /* --------------------------------------------------------------------------------------------------------- */
    INSERT INTO wra_fu_visit_2_overview(record_id, screening_id, wra_ptid, last_visit_date, follow_up_2_visit_date,
                                        follow_up_2_last_visit_date, follow_up_2_visit_date_days_late)
    SELECT v1.record_id,
           v1.screening_id,
           v1.wra_ptid,
           COALESCE(v3.visit_date, v1.visit_date)                    as last_visit_date,
           DATE_ADD(v1.visit_date, INTERVAL (90 + 90) DAY)           as follow_up_2_visit_date,
           DATE_ADD(v1.visit_date, INTERVAL (90 + (90 + 21)) DAY)    as follow_up_2_last_visit_date,
           DATEDIFF(CURRENT_DATE,
                    DATE_ADD(v1.visit_date, INTERVAL (90 + 90) DAY)) as follow_up_2_visit_date_days_late
    FROM crt_wra_visit_1_overview v1
             LEFT JOIN crt_wra_visit_3_overview v3 ON v1.record_id = v3.record_id
    WHERE v1.record_id NOT IN (SELECT v2.record_id FROM crt_wra_visit_2_overview v2)
      AND v1.record_id NOT IN (SELECT v3.record_id FROM crt_wra_visit_3_overview v3)
    UNION
    SELECT v2.record_id,
           v2.screening_id,
           v2.wra_ptid,
           COALESCE(v3.visit_date, v2.visit_date)                 as last_visit_date,
           DATE_ADD(v2.visit_date, INTERVAL ((90)) DAY)           as follow_up_2_visit_date,
           DATE_ADD(v2.visit_date, INTERVAL ((90 + 21)) DAY)      as follow_up_2_last_visit_date,
           DATEDIFF(CURRENT_DATE,
                    DATE_ADD(v2.visit_date, INTERVAL ((90)) DAY)) as follow_up_2_visit_date_days_late
    FROM crt_wra_visit_2_overview v2
             LEFT JOIN crt_wra_visit_3_overview v3 ON v2.record_id = v3.record_id
    WHERE v2.record_id NOT IN (SELECT v3.record_id FROM crt_wra_visit_3_overview v3);

    -- Total number of second follow-up visit due
    SET @v_wra_fu_2_visits_total = (SELECT COUNT(DISTINCT f2.record_id)
                                    FROM wra_fu_visit_2_overview f2
                                    WHERE f2.follow_up_2_visit_date_days_late > 0);

    SET @v_wra_visit_2_remaining_total = (SELECT COUNT(DISTINCT f2.record_id)
                                          FROM wra_fu_visit_2_overview f2
                                          WHERE f2.follow_up_2_visit_date_days_late < 21
                                            AND f2.record_id NOT IN
                                                (SELECT v2.record_id FROM crt_wra_visit_3_overview v2));

    SET @v_wra_visit_2_ltfu = (SELECT COUNT(DISTINCT f2.record_id)
                               FROM wra_fu_visit_2_overview f2
                               WHERE f2.follow_up_2_visit_date_days_late > 21
                                 AND f2.record_id NOT IN (SELECT DISTINCT f2o.record_id
                                                          FROM crt_wra_visit_3_overview f2o));

    SET @v_wra_visit_2_screened = (SELECT COUNT(DISTINCT f2.record_id)
                                   FROM crt_wra_visit_3_overview f2
                                   WHERE f2.visit_outcome <> '');

    SET @v_wra_visit_2_screened_and_followed_up = (SELECT COUNT(DISTINCT f2.record_id)
                                                   FROM crt_wra_visit_3_overview f2
                                                   WHERE f2.visit_outcome IN ('Completed'));

    SET @v_wra_visit_2_extended_absence = (SELECT COUNT(DISTINCT f2.record_id)
                                           FROM crt_wra_visit_3_overview f2
                                           WHERE f2.visit_outcome IN ('Extended-Absence', 'No, Extended Absence'));

    SET @v_wra_visit_2_untraceable = (SELECT COUNT(DISTINCT f2.record_id)
                                      FROM crt_wra_visit_3_overview f2
                                      WHERE f2.visit_outcome = 'Untraceable');

    SET @v_wra_visit_2_deferred = (SELECT COUNT(DISTINCT f2.record_id)
                                   FROM crt_wra_visit_3_overview f2
                                   WHERE f2.visit_outcome = 'Incomplete');

    UPDATE crt_wra_retention ret
    SET ret.wra_visit_missed_appointment = @v_wra_visit_2_ltfu,
        ret.wra_visit_untraceable        = @v_wra_visit_2_untraceable,
        ret.wra_visit_deferred           = @v_wra_visit_2_deferred,
        ret.wra_visit_extended_absence   = @v_wra_visit_2_extended_absence,
        ret.wra_screened                 = @v_wra_visit_2_screened,
        ret.wra_screened_and_followed_up = @v_wra_visit_2_screened_and_followed_up,
        ret.wra_visits_total             = @v_wra_fu_2_visits_total,
        ret.wra_visit_total_remaining    = @v_wra_visit_2_remaining_total
    WHERE ret.visit_number = 3.0;
    /*------------------------------------------------------------------------------------------------------------*/
    INSERT INTO wra_fu_visit_3_overview(record_id, screening_id, wra_ptid, last_visit_date, follow_up_3_visit_date,
                                        follow_up_3_last_visit_date, follow_up_3_visit_date_days_late)
    SELECT v1.record_id,
           v1.screening_id,
           v1.wra_ptid,
           COALESCE(v4.visit_date, v1.visit_date),
           DATE_ADD(v1.visit_date, INTERVAL ((90) + (90 + 21) + (90)) DAY)           as follow_up_3_visit_date,
           DATE_ADD(v1.visit_date, INTERVAL ((90) + (90 + 21) + (90 + 21))
                    DAY)                                                                 as follow_up_3_last_visit_date,
           DATEDIFF(CURRENT_DATE,
                    DATE_ADD(v1.visit_date, INTERVAL ((90) + (90 + 21) + (90)) DAY)) as follow_up_3_visit_date_days_late
    FROM crt_wra_visit_1_overview v1
             LEFT JOIN crt_wra_visit_4_overview v4 ON v1.record_id = v4.record_id
    WHERE v1.record_id NOT IN (SELECT f1.record_id FROM crt_wra_visit_2_overview f1)
      AND v1.record_id NOT IN (SELECT f2.record_id FROM crt_wra_visit_3_overview f2)
      AND v1.record_id NOT IN (SELECT v4.record_id FROM crt_wra_visit_4_overview v4)
    UNION
    SELECT v2.record_id,
           v2.screening_id,
           v2.wra_ptid,
           COALESCE(v4.visit_date, v2.visit_date)                             as last_visit_date,
           DATE_ADD(v2.visit_date, INTERVAL ((90 + 21) + (90)) DAY)           as follow_up_3_visit_date,
           DATE_ADD(v2.visit_date, INTERVAL ((90 + 21) + (90 + 21)) DAY)      as follow_up_3_last_visit_date,
           DATEDIFF(CURRENT_DATE,
                    DATE_ADD(v2.visit_date, INTERVAL ((90 + 21) + (90)) DAY)) as follow_up_3_visit_date_days_late
    FROM crt_wra_visit_2_overview v2
             LEFT JOIN crt_wra_visit_4_overview v4 ON v2.record_id = v4.record_id
    WHERE v2.record_id NOT IN (SELECT f2.record_id FROM crt_wra_visit_3_overview f2)
      AND v2.record_id NOT IN (SELECT v4.record_id FROM crt_wra_visit_4_overview v4)
    UNION
    SELECT v3.record_id,
           v3.screening_id,
           v3.wra_ptid,
           COALESCE(v4.visit_date, v3.visit_date)            as last_visit_date,
           DATE_ADD(v3.visit_date, INTERVAL ((90)) DAY)      as follow_up_3_visit_date,
           DATE_ADD(v3.visit_date, INTERVAL ((90 + 21)) DAY) as follow_up_3_last_visit_date,
           DATEDIFF(CURRENT_DATE,
                    DATE_ADD(v3.visit_date, INTERVAL ((90))
                             DAY))                           as follow_up_3_visit_date_days_late
    FROM crt_wra_visit_3_overview v3
             LEFT JOIN crt_wra_visit_4_overview v4 ON v3.record_id = v4.record_id
    WHERE v3.record_id NOT IN (SELECT v4.record_id
                               FROM crt_wra_visit_4_overview v4);

    -- Total number of third follow-up visit due
    SET @v_wra_fu_3_visits_due_total = (SELECT COUNT(DISTINCT f3.record_id)
                                        FROM wra_fu_visit_3_overview f3
                                        WHERE f3.follow_up_3_visit_date_days_late > 0
                                          AND f3.follow_up_3_visit_date IS NOT NULL);

    SET @v_wra_visit_3_remaining_total = (SELECT COUNT(DISTINCT f3.record_id)
                                          FROM wra_fu_visit_3_overview f3
                                          WHERE f3.follow_up_3_visit_date_days_late < 21
                                            AND f3.record_id NOT IN
                                                (SELECT v4.record_id FROM crt_wra_visit_4_overview v4)
                                            AND f3.follow_up_3_visit_date IS NOT NULL);

    SET @v_wra_visit_3_ltfu = (SELECT COUNT(DISTINCT f3.record_id)
                               FROM wra_fu_visit_3_overview f3
                               WHERE f3.follow_up_3_visit_date_days_late > 21
                                 AND f3.record_id NOT IN (SELECT DISTINCT f2o.record_id
                                                          FROM crt_wra_visit_4_overview f2o)
                                 AND f3.follow_up_3_visit_date IS NOT NULL);

    SET @v_wra_visit_3_screened = (SELECT COUNT(DISTINCT f3.record_id)
                                   FROM crt_wra_visit_4_overview f3
                                   WHERE f3.visit_outcome <> '');

    SET @v_wra_visit_3_screened_and_followed_up = (SELECT COUNT(DISTINCT f3.record_id)
                                                   FROM crt_wra_visit_4_overview f3
                                                   WHERE f3.visit_outcome IN ('Completed'));

    SET @v_wra_visit_3_extended_absence = (SELECT COUNT(DISTINCT f3.record_id)
                                           FROM crt_wra_visit_4_overview f3
                                           WHERE f3.visit_outcome IN ('Extended-Absence', 'No, Extended Absence'));

    SET @v_wra_visit_3_untraceable = (SELECT COUNT(DISTINCT f3.record_id)
                                      FROM crt_wra_visit_4_overview f3
                                      WHERE f3.visit_outcome = 'Untraceable');

    SET @v_wra_visit_3_deferred = (SELECT COUNT(DISTINCT f3.record_id)
                                   FROM crt_wra_visit_4_overview f3
                                   WHERE f3.visit_outcome = 'Incomplete');

    UPDATE crt_wra_retention ret
    SET ret.wra_visit_missed_appointment = @v_wra_visit_3_ltfu,
        ret.wra_visit_untraceable        = @v_wra_visit_3_untraceable,
        ret.wra_visit_deferred           = @v_wra_visit_3_deferred,
        ret.wra_visit_extended_absence   = @v_wra_visit_3_extended_absence,
        ret.wra_screened                 = @v_wra_visit_3_screened,
        ret.wra_screened_and_followed_up = @v_wra_visit_3_screened_and_followed_up,
        ret.wra_visits_total             = @v_wra_fu_3_visits_due_total,
        ret.wra_visit_total_remaining    = @v_wra_visit_3_remaining_total
    WHERE ret.visit_number = 4.0;
    /*------------------------------------------------------------------------------------------------------------*/
    INSERT INTO wra_fu_visit_4_overview(record_id, screening_id, wra_ptid, last_visit_date, follow_up_4_visit_date,
                                        follow_up_4_last_visit_date, follow_up_4_visit_date_days_late)
    SELECT v1.record_id,
           v1.screening_id,
           v1.wra_ptid,
           COALESCE(v5.visit_date, v1.visit_date)                              as last_visit_date,
           DATE_ADD(v1.visit_date, INTERVAL (90 + 90 + 90 + 90) DAY)           as follow_up_4_visit_date,
           DATE_ADD(v1.visit_date, INTERVAL ((90 + 90 + 90 + 90) + 21)
                    DAY)                                                           as follow_up_4_last_visit_date,
           DATEDIFF(CURRENT_DATE,
                    DATE_ADD(v1.visit_date, INTERVAL (90 + 90 + 90 + 90) DAY)) as follow_up_4_visit_date_days_late
    FROM crt_wra_visit_1_overview v1
             LEFT JOIN crt_wra_visit_5_overview v5 ON v1.record_id = v5.record_id
    WHERE v1.record_id NOT IN (SELECT f1.record_id FROM crt_wra_visit_2_overview f1)
      AND v1.record_id NOT IN (SELECT f2.record_id FROM crt_wra_visit_3_overview f2)
      AND v1.record_id NOT IN (SELECT f3.record_id FROM crt_wra_visit_4_overview f3)
      AND v1.record_id NOT IN (SELECT f4.record_id FROM crt_wra_visit_5_overview f4)
    UNION
    SELECT v2.record_id,
           v2.screening_id,
           v2.wra_ptid,
           COALESCE(v5.visit_date, v2.visit_date)                                       as last_visit_date,
           DATE_ADD(v2.visit_date, INTERVAL ((90 + 21) + (90 + 21) + 90) DAY)           as follow_up_4_visit_date,
           DATE_ADD(v2.visit_date, INTERVAL ((90 + 21) + (90 + 21) + (90 + 21))
                    DAY)                                                                as follow_up_4_last_visit_date,
           DATEDIFF(CURRENT_DATE,
                    DATE_ADD(v2.visit_date, INTERVAL ((90 + 21) + (90 + 21) + 90) DAY)) as follow_up_4_visit_date_days_late
    FROM crt_wra_visit_2_overview v2
             LEFT JOIN crt_wra_visit_5_overview v5 ON v2.record_id = v5.record_id
    WHERE v2.record_id NOT IN (SELECT f2.record_id FROM crt_wra_visit_3_overview f2)
      AND v2.record_id NOT IN (SELECT f3.record_id FROM crt_wra_visit_4_overview f3)
      AND v2.record_id NOT IN (SELECT f4.record_id FROM crt_wra_visit_5_overview f4)
    UNION
    SELECT v3.record_id,
           v3.screening_id,
           v3.wra_ptid,
           COALESCE(v5.visit_date, v3.visit_date)                        as last_visit_date,
           DATE_ADD(v3.visit_date, INTERVAL ((90 + 21) + 90) DAY)        as follow_up_4_visit_date,
           DATE_ADD(v3.visit_date, INTERVAL ((90 + 21) + (90 + 21)) DAY) as follow_up_4_last_visit_date,
           DATEDIFF(CURRENT_DATE,
                    DATE_ADD(v3.visit_date, INTERVAL ((90 + 21) + 90)
                             DAY))                                       as follow_up_4_visit_date_days_late
    FROM crt_wra_visit_3_overview v3
             LEFT JOIN crt_wra_visit_5_overview v5 ON v3.record_id = v5.record_id
    WHERE v3.record_id NOT IN (SELECT f3.record_id FROM crt_wra_visit_4_overview f3)
      AND v3.record_id NOT IN (SELECT f4.record_id FROM crt_wra_visit_5_overview f4)
    UNION
    SELECT v4.record_id,
           v4.screening_id,
           v4.wra_ptid,
           COALESCE(v5.visit_date, v4.visit_date)                 as last_visit_date,
           DATE_ADD(v4.visit_date, INTERVAL ((90)) DAY)           as follow_up_4_visit_date,
           DATE_ADD(v4.visit_date, INTERVAL ((90 + 21)) DAY)      as follow_up_4_last_visit_date,
           DATEDIFF(CURRENT_DATE,
                    DATE_ADD(v4.visit_date, INTERVAL ((90)) DAY)) as follow_up_4_visit_date_days_late
    FROM crt_wra_visit_4_overview v4
             LEFT JOIN crt_wra_visit_5_overview v5 ON v4.record_id = v5.record_id
    WHERE v4.record_id NOT IN (SELECT f4.record_id FROM crt_wra_visit_5_overview f4);

    -- Total number of fourth follow-up visit due
    SET @v_wra_fu_4_visits_due_total = (SELECT COUNT(DISTINCT f4.record_id)
                                        FROM wra_fu_visit_4_overview f4
                                        WHERE f4.follow_up_4_visit_date_days_late > 0
                                          AND f4.follow_up_4_visit_date IS NOT NULL);

    SET @v_wra_visit_4_remaining_total = (SELECT COUNT(DISTINCT f4.record_id)
                                          FROM wra_fu_visit_4_overview f4
                                          WHERE f4.follow_up_4_visit_date_days_late < 21
                                            AND f4.record_id NOT IN
                                                (SELECT v5.record_id FROM crt_wra_visit_5_overview v5)
                                            AND f4.follow_up_4_visit_date IS NOT NULL);

    SET @v_wra_visit_4_ltfu = (SELECT COUNT(DISTINCT f4.record_id)
                               FROM wra_fu_visit_4_overview f4
                               WHERE f4.follow_up_4_visit_date_days_late > 21
                                 AND f4.record_id NOT IN (SELECT DISTINCT f5o.record_id
                                                          FROM crt_wra_visit_5_overview f5o)
                                 AND f4.follow_up_4_visit_date IS NOT NULL);

    SET @v_wra_visit_4_screened = (SELECT COUNT(DISTINCT f4.record_id)
                                   FROM crt_wra_visit_5_overview f4
                                   WHERE f4.visit_outcome <> '');

    SET @v_wra_visit_4_screened_and_followed_up = (SELECT COUNT(DISTINCT f4.record_id)
                                                   FROM crt_wra_visit_5_overview f4
                                                   WHERE f4.visit_outcome IN ('Completed'));

    SET @v_wra_visit_4_extended_absence = (SELECT COUNT(DISTINCT f4.record_id)
                                           FROM crt_wra_visit_5_overview f4
                                           WHERE f4.visit_outcome IN ('Extended-Absence', 'No, Extended Absence'));

    SET @v_wra_visit_4_untraceable = (SELECT COUNT(DISTINCT f4.record_id)
                                      FROM crt_wra_visit_5_overview f4
                                      WHERE f4.visit_outcome = 'Untraceable');

    SET @v_wra_visit_4_deferred = (SELECT COUNT(DISTINCT f4.record_id)
                                   FROM crt_wra_visit_5_overview f4
                                   WHERE f4.visit_outcome = 'Incomplete');

    UPDATE crt_wra_retention ret
    SET ret.wra_visit_missed_appointment = @v_wra_visit_5_ltfu,
        ret.wra_visit_untraceable        = @v_wra_visit_5_untraceable,
        ret.wra_visit_deferred           = @v_wra_visit_5_deferred,
        ret.wra_visit_extended_absence   = @v_wra_visit_5_extended_absence,
        ret.wra_screened                 = @v_wra_visit_5_screened,
        ret.wra_screened_and_followed_up = @v_wra_visit_5_screened_and_followed_up,
        ret.wra_visits_total             = @v_wra_fu_5_visits_due_total,
        ret.wra_visit_total_remaining    = @v_wra_visit_5_remaining_total
    WHERE ret.visit_number = 5.0;

    /*------------------------------------------------------------------------------------------------------------*/
    INSERT INTO wra_fu_visit_5_overview(record_id, screening_id, wra_ptid, last_visit_date, follow_up_5_visit_date,
                                        follow_up_5_last_visit_date, follow_up_5_visit_date_days_late)
    SELECT v1.record_id,
           v1.screening_id,
           v1.wra_ptid,
           COALESCE(v6.visit_date, v1.visit_date)                              as last_visit_date,
           DATE_ADD(v1.visit_date, INTERVAL (90 + 90 + 90 + 90 + 90) DAY)           as follow_up_5_visit_date,
           DATE_ADD(v1.visit_date, INTERVAL ((90 + 90 + 90 + 90 + 90) + 21)
                    DAY)                                                           as follow_up_5_last_visit_date,
           DATEDIFF(CURRENT_DATE,
                    DATE_ADD(v1.visit_date, INTERVAL (90 + 90 + 90 + 90 + 90) DAY)) as follow_up_5_visit_date_days_late
    FROM crt_wra_visit_1_overview v1
             LEFT JOIN crt_wra_visit_6_overview v6 ON v1.record_id = v6.record_id
    WHERE v1.record_id NOT IN (SELECT f1.record_id FROM crt_wra_visit_2_overview f1)
      AND v1.record_id NOT IN (SELECT f2.record_id FROM crt_wra_visit_3_overview f2)
      AND v1.record_id NOT IN (SELECT f3.record_id FROM crt_wra_visit_4_overview f3)
      AND v1.record_id NOT IN (SELECT f4.record_id FROM crt_wra_visit_5_overview f4)
      AND v1.record_id NOT IN (SELECT f5.record_id FROM crt_wra_visit_6_overview f5)
    UNION
    SELECT v2.record_id,
           v2.screening_id,
           v2.wra_ptid,
           COALESCE(v6.visit_date, v2.visit_date)                                       as last_visit_date,
           DATE_ADD(v2.visit_date, INTERVAL (90 + 90 + 90 + 90) DAY)           as follow_up_5_visit_date,
           DATE_ADD(v2.visit_date, INTERVAL ((90 + 90 + 90 + 90) + (90 + 21)) DAY)                                                                as follow_up_4_last_visit_date,
           DATEDIFF(CURRENT_DATE, DATE_ADD(v2.visit_date, INTERVAL (90 + 90 + 90 + 90) DAY)) as follow_up_5_visit_date_days_late
    FROM crt_wra_visit_2_overview v2
             LEFT JOIN crt_wra_visit_6_overview v6 ON v2.record_id = v6.record_id
    WHERE v2.record_id NOT IN (SELECT f2.record_id FROM crt_wra_visit_3_overview f2)
      AND v2.record_id NOT IN (SELECT f3.record_id FROM crt_wra_visit_4_overview f3)
      AND v2.record_id NOT IN (SELECT f4.record_id FROM crt_wra_visit_5_overview f4)
      AND v2.record_id NOT IN (SELECT f5.record_id FROM crt_wra_visit_6_overview f5)
    UNION
    SELECT v3.record_id,
           v3.screening_id,
           v3.wra_ptid,
           COALESCE(v6.visit_date, v3.visit_date)                        as last_visit_date,
           DATE_ADD(v3.visit_date, INTERVAL (90 + 90 + 90) DAY)        as follow_up_5_visit_date,
           DATE_ADD(v3.visit_date, INTERVAL (90 + 90 + (90 + 21)) DAY) as follow_up_5_last_visit_date,
           DATEDIFF(CURRENT_DATE,
                    DATE_ADD(v3.visit_date, INTERVAL (90 + 90 + 90) DAY))                                       as follow_up_5_visit_date_days_late
    FROM crt_wra_visit_3_overview v3
             LEFT JOIN crt_wra_visit_6_overview v6 ON v3.record_id = v6.record_id
    WHERE v3.record_id NOT IN (SELECT f3.record_id FROM crt_wra_visit_4_overview f3)
      AND v3.record_id NOT IN (SELECT f4.record_id FROM crt_wra_visit_5_overview f4)
      AND v3.record_id NOT IN (SELECT f4.record_id FROM crt_wra_visit_6_overview f4)
    UNION
    SELECT v4.record_id,
           v4.screening_id,
           v4.wra_ptid,
           COALESCE(v6.visit_date, v4.visit_date)                 as last_visit_date,
           DATE_ADD(v4.visit_date, INTERVAL ((90 + 90)) DAY)           as follow_up_5_visit_date,
           DATE_ADD(v4.visit_date, INTERVAL ((90 + 90 + 21)) DAY)      as follow_up_5_last_visit_date,
           DATEDIFF(CURRENT_DATE,
                    DATE_ADD(v4.visit_date, INTERVAL ((90 + 90)) DAY)) as follow_up_5_visit_date_days_late
    FROM crt_wra_visit_4_overview v4
             LEFT JOIN crt_wra_visit_6_overview v6 ON v4.record_id = v6.record_id
    WHERE v4.record_id NOT IN (SELECT f4.record_id FROM crt_wra_visit_5_overview f4)
      AND v4.record_id NOT IN (SELECT f5.record_id FROM crt_wra_visit_6_overview f5)
    UNION
    SELECT v5.record_id,
           v5.screening_id,
           v5.wra_ptid,
           COALESCE(v6.visit_date, v5.visit_date)                 as last_visit_date,
           DATE_ADD(v5.visit_date, INTERVAL ((90)) DAY)           as follow_up_5_visit_date,
           DATE_ADD(v5.visit_date, INTERVAL ((90 + 21)) DAY)      as follow_up_5_last_visit_date,
           DATEDIFF(CURRENT_DATE,
                    DATE_ADD(v5.visit_date, INTERVAL ((90)) DAY)) as follow_up_5_visit_date_days_late
    FROM crt_wra_visit_5_overview v5
             LEFT JOIN crt_wra_visit_6_overview v6 ON v5.record_id = v6.record_id
    WHERE v5.record_id NOT IN (SELECT f5.record_id FROM crt_wra_visit_6_overview f5);

    -- Total number of fifth follow-up visit due
    SET @v_wra_fu_5_visits_due_total = (SELECT COUNT(DISTINCT f5.record_id)
                                        FROM wra_fu_visit_5_overview f5
                                        WHERE f5.follow_up_5_visit_date_days_late > 0
                                          AND f5.follow_up_5_visit_date IS NOT NULL);

    SET @v_wra_visit_5_remaining_total = (SELECT COUNT(DISTINCT f5.record_id)
                                          FROM wra_fu_visit_5_overview f5
                                          WHERE f5.follow_up_5_visit_date_days_late < 21
                                            AND f5.record_id NOT IN
                                                (SELECT v6.record_id FROM crt_wra_visit_6_overview v6)
                                            AND f5.follow_up_5_visit_date IS NOT NULL);

    SET @v_wra_visit_5_ltfu = (SELECT COUNT(DISTINCT f5.record_id)
                               FROM wra_fu_visit_5_overview f5
                               WHERE f5.follow_up_5_visit_date_days_late > 21
                                 AND f5.record_id NOT IN (SELECT DISTINCT f5o.record_id
                                                          FROM crt_wra_visit_6_overview f5o)
                                 AND f5.follow_up_5_visit_date IS NOT NULL);

    SET @v_wra_visit_5_screened = (SELECT COUNT(DISTINCT f5.record_id)
                                   FROM crt_wra_visit_6_overview f5
                                   WHERE f5.visit_outcome <> '');

    SET @v_wra_visit_5_screened_and_followed_up = (SELECT COUNT(DISTINCT f5.record_id)
                                                   FROM crt_wra_visit_6_overview f5
                                                   WHERE f5.visit_outcome IN ('Completed'));

    SET @v_wra_visit_5_extended_absence = (SELECT COUNT(DISTINCT f5.record_id)
                                           FROM crt_wra_visit_6_overview f5
                                           WHERE f5.visit_outcome IN ('Extended-Absence', 'No, Extended Absence'));

    SET @v_wra_visit_5_untraceable = (SELECT COUNT(DISTINCT f5.record_id)
                                      FROM crt_wra_visit_6_overview f5
                                      WHERE f5.visit_outcome = 'Untraceable');

    SET @v_wra_visit_5_deferred = (SELECT COUNT(DISTINCT f5.record_id)
                                   FROM crt_wra_visit_6_overview f5
                                   WHERE f5.visit_outcome = 'Incomplete');

    UPDATE crt_wra_retention ret
    SET ret.wra_visit_missed_appointment = @v_wra_visit_5_ltfu,
        ret.wra_visit_untraceable        = @v_wra_visit_5_untraceable,
        ret.wra_visit_deferred           = @v_wra_visit_5_deferred,
        ret.wra_visit_extended_absence   = @v_wra_visit_5_extended_absence,
        ret.wra_screened                 = @v_wra_visit_5_screened,
        ret.wra_screened_and_followed_up = @v_wra_visit_5_screened_and_followed_up,
        ret.wra_visits_total             = @v_wra_fu_5_visits_due_total,
        ret.wra_visit_total_remaining    = @v_wra_visit_5_remaining_total
    WHERE ret.visit_number = 6.0;
    COMMIT;
    -- flag completion
    SELECT 1 as `status`;

END $$

DELIMITER ;
