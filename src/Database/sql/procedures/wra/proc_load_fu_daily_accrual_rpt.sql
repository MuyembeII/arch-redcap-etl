/**
 * Load daily accrual given a date range
 *
 * @author Gift Jr <muyembegift@gmail.com> | 20.08.24
 * @since 0.0.1
 * @alias Initiate Accrual Data By RA
 * @param date Start Date
 * @param date End Date
 * @param varchar RA username
 */
DROP PROCEDURE IF EXISTS `InitiateDailyFUAccrualData`;
DELIMITER $$
CREATE PROCEDURE InitiateDailyFUAccrualData(IN p_start_date DATE, IN p_end_date DATE, IN p_ra_name VARCHAR(64))
BEGIN

    DECLARE v_visit_date DATE DEFAULT p_start_date;
    DECLARE v_end_date DATE DEFAULT p_end_date;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
        BEGIN
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS(' ', 'ERROR - Failed to load daily RA accrual; RA_ID=', p_ra_name, 'RPT_DATE=',
                              v_visit_date,
                              @errno, '(', @sqlstate, '):', @text);
            SELECT @full_error;
            RESIGNAL;
        END;

    DROP TEMPORARY TABLE IF EXISTS arch_etl_db.visits_overview;
    CREATE TEMPORARY TABLE arch_etl_db.visits_overview
    (
        record_id     INT,
        ra            VARCHAR(32),
        visit_date    DATE,
        visit_number  DECIMAL(10, 1) NOT NULL,
        visit_outcome TINYTEXT
    );

    /*Aggregates*/
    SET @v_wra_followed_up := 0;
    SET @v_wra_followed_up_and_screened := 0;

    IF p_end_date IS NULL THEN
        SET p_end_date = CURDATE();
    ELSEIF p_end_date < p_start_date THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = p_end_date;
    END IF;

    START TRANSACTION;

    INSERT INTO visits_overview(record_id, ra, visit_date, visit_number, visit_outcome)
    SELECT o.record_id, o.ra, o.visit_date, o.visit_number, o.visit_outcome
    FROM (SELECT v1.record_id,
                 v1.ra,
                 v1.visit_date,
                 v1.visit_number,
                 v1.visit_outcome
          FROM crt_wra_visit_1_overview v1
          UNION
          SELECT v2.record_id,
                 v2.ra,
                 v2.visit_date,
                 v2.visit_number,
                 v2.visit_outcome
          FROM crt_wra_visit_2_overview v2
          UNION
          SELECT v3.record_id,
                 v3.ra,
                 v3.visit_date,
                 v3.visit_number,
                 v3.visit_outcome
          FROM crt_wra_visit_3_overview v3
          UNION
          SELECT v4.record_id,
                 v4.ra,
                 v4.visit_date,
                 v4.visit_number,
                 v4.visit_outcome
          FROM crt_wra_visit_4_overview v4
          UNION
          SELECT v5.record_id,
                 v5.ra,
                 v5.visit_date,
                 v5.visit_number,
                 v5.visit_outcome
          FROM crt_wra_visit_5_overview v5
          UNION
          SELECT v6.record_id,
                 v6.ra,
                 v6.visit_date,
                 v6.visit_number,
                 v6.visit_outcome
          FROM crt_wra_visit_6_overview v6) o
    ORDER BY o.visit_date DESC;

    REPEAT

        SET @v_wra_followed_up = (SELECT COUNT(DISTINCT v.record_id)
                                  FROM visits_overview v
                                  WHERE v.ra = p_ra_name
                                    AND v.visit_outcome IN (
                                                            'Migrated',
                                                            'Untraceable',
                                                            'Extended-Absence',
                                                            'Incomplete'
                                      )
                                    AND v.visit_date = v_visit_date);

        SET @v_wra_followed_up_and_screened = (SELECT COUNT(DISTINCT v.record_id)
                                               FROM visits_overview v
                                               WHERE v.ra = p_ra_name
                                                 AND v.visit_outcome IN ('Completed', 'Enrolled')
                                                 AND v.visit_date = v_visit_date);

        INSERT INTO crt_ra_fu_accrual(ra_name, date, wra_followed_up, wra_followed_up_and_screened)
        VALUES (p_ra_name, v_visit_date, @v_wra_followed_up, @v_wra_followed_up_and_screened);

        -- day tracker incrementation
        SET v_visit_date = DATE_ADD(v_visit_date, INTERVAL 1 DAY);
    UNTIL v_visit_date >= v_end_date END REPEAT;
    COMMIT;
    -- flag completion
    SELECT 1 as `status`;

END $$

DELIMITER ;
