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
DROP PROCEDURE IF EXISTS `InitiateDailyAccrualData`;
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

    /*Aggregates*/
    SET @v_wra_followed_up := 0;
    SET @v_wra_followed_up_and_screened := 0;

    IF p_end_date IS NULL THEN
        SET p_end_date = CURDATE();
    ELSEIF p_end_date < p_start_date THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = p_end_date;
    END IF;

    START TRANSACTION;
    REPEAT

        SET @v_wra_followed_up = (SELECT COUNT(DISTINCT fu.record_id)
                                  FROM (SELECT v2.record_id,
                                               v2.wra_fu_interviewer_obsloc as ra,
                                               v2.wra_fu_visit_date         as visit_date,
                                               2.0                          as visit_number,
                                               v2.wra_fu_pp_avail_label     as is_wra_available
                                        FROM wra_follow_up_visit_repeating_instruments v2
                                        WHERE v2.wra_fu_visit_date IS NOT NULL
                                           OR v2.wra_fu_visit_date <> ''
                                        UNION
                                        SELECT v3.record_id,
                                               v3.wra_enr_interviewer_obsloc_f2 as ra,
                                               v3.scrn_obsstdat_f2              as visit_date,
                                               3.0                              as visit_number,
                                               v3.wra_enr_pp_avail_f2_label     as is_wra_available
                                        FROM wra_follow_up_visit_2_repeating_instruments v3
                                        WHERE v3.scrn_obsstdat_f2 IS NOT NULL
                                           OR v3.scrn_obsstdat_f2 <> ''
                                        UNION
                                        SELECT v4.record_id,
                                               v4.wra_fu_interviewer_obsloc_f3 as ra,
                                               v4.wra_fu_visit_date_f3         as visit_date,
                                               4.0                             as visit_number,
                                               v4.wra_fu_pp_avail_f3_label     as is_wra_available
                                        FROM wra_follow_up_visit_3_repeating_instruments v4
                                        WHERE v4.wra_fu_visit_date_f3 IS NOT NULL
                                           OR v4.wra_fu_visit_date_f3 <> ''
                                        UNION
                                        SELECT v5.record_id,
                                               v5.wra_fu_interviewer_obsloc_f4 as ra,
                                               v5.wra_fu_visit_date_f4         as visit_date,
                                               4.0                             as visit_number,
                                               v5.wra_fu_pp_avail_f4_label     as is_wra_available
                                        FROM wra_follow_up_visit_4_repeating_instruments v5
                                        WHERE v5.wra_fu_visit_date_f4 IS NOT NULL
                                           OR v5.wra_fu_visit_date_f4 <> '') fu
                                  WHERE fu.ra = p_ra_name
                                    AND fu.is_wra_available <> 'Yes'
                                    AND fu.visit_date = v_visit_date);
        SET @v_wra_followed_up_and_screened = (SELECT COUNT(DISTINCT fu.record_id)
                                               FROM (SELECT v2.record_id,
                                                            v2.wra_fu_interviewer_obsloc as ra,
                                                            v2.wra_fu_visit_date         as visit_date,
                                                            2.0                          as visit_number,
                                                            v2.wra_fu_pp_avail_label     as is_wra_available
                                                     FROM wra_follow_up_visit_repeating_instruments v2
                                                     WHERE v2.wra_fu_visit_date IS NOT NULL
                                                        OR v2.wra_fu_visit_date <> ''
                                                     UNION
                                                     SELECT v3.record_id,
                                                            v3.wra_enr_interviewer_obsloc_f2 as ra,
                                                            v3.scrn_obsstdat_f2              as visit_date,
                                                            3.0                              as visit_number,
                                                            v3.wra_enr_pp_avail_f2_label     as is_wra_available
                                                     FROM wra_follow_up_visit_2_repeating_instruments v3
                                                     WHERE v3.scrn_obsstdat_f2 IS NOT NULL
                                                        OR v3.scrn_obsstdat_f2 <> ''
                                                     UNION
                                                     SELECT v4.record_id,
                                                            v4.wra_fu_interviewer_obsloc_f3 as ra,
                                                            v4.wra_fu_visit_date_f3         as visit_date,
                                                            4.0                             as visit_number,
                                                            v4.wra_fu_pp_avail_f3_label     as is_wra_available
                                                     FROM wra_follow_up_visit_3_repeating_instruments v4
                                                     WHERE v4.wra_fu_visit_date_f3 IS NOT NULL
                                                        OR v4.wra_fu_visit_date_f3 <> ''
                                                     UNION
                                                     SELECT v5.record_id,
                                                            v5.wra_fu_interviewer_obsloc_f4 as ra,
                                                            v5.wra_fu_visit_date_f4         as visit_date,
                                                            5.0                             as visit_number,
                                                            v5.wra_fu_pp_avail_f4_label     as is_wra_available
                                                     FROM wra_follow_up_visit_4_repeating_instruments v5
                                                     WHERE v5.wra_fu_visit_date_f4 IS NOT NULL
                                                        OR v5.wra_fu_visit_date_f4 <> '') fu
                                               WHERE fu.ra = p_ra_name
                                                 AND fu.is_wra_available = 'Yes'
                                                 AND fu.visit_date = v_visit_date);

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
