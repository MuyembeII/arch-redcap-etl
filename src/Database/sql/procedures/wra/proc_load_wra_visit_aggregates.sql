/**
 * Load WRA CRT Visit Aggregate Report.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 26.02.25
 * @since 0.0.1
 * @alias WRA Visit Aggregates
 */
DROP PROCEDURE IF EXISTS `Load_WRA_Visit_Aggregates`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_Visit_Aggregates()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load WRA Visit Aggregates;', @errno, '(',
                              @sqlstate, '):',
                              @text);
            SELECT @full_error as Error_Details;
            RESIGNAL;
        END;

    START TRANSACTION;
    TRUNCATE arch_etl_db.crt_visit_aggregates;

    -- Load baseline enrollments
    INSERT INTO crt_visit_aggregates(record_id, screening_id, wra_ptid)
    SELECT v1.record_id, v1.screening_id, v1.wra_ptid
    FROM crt_wra_visit_1_overview v1
    ORDER BY v1.screening_id;

    -- FU1: Attempted Follow-Ups
    UPDATE crt_visit_aggregates v
        LEFT JOIN crt_wra_visit_2_overview v2 ON v2.record_id = v.record_id
    SET v.first_follow_up_visit_outcome = v2.visit_outcome
    WHERE v.wra_ptid = v2.wra_ptid;

    -- FU1: Missed Follow-Ups
    UPDATE crt_visit_aggregates v
    SET v.first_follow_up_visit_outcome = 'Missed'
    WHERE v.record_id IN (SELECT f1.record_id FROM crt_wra_missed_visit_2_overview f1);

    -- FU1: Study Closure
    UPDATE crt_visit_aggregates v
    SET v.first_follow_up_visit_outcome = 'Study-Closure'
    WHERE v.record_id IN (SELECT sc.record_id
                          FROM crt_wra_study_closure sc
                          WHERE sc.visit_number IN (1.0, 2.0));
    /*________________________________________________________________________________*/
    -- FU2: Attempted Follow-Ups
    UPDATE crt_visit_aggregates v
        LEFT JOIN crt_wra_visit_3_overview v2 ON v2.record_id = v.record_id
    SET v.second_follow_up_visit_outcome = v2.visit_outcome
    WHERE v.wra_ptid = v2.wra_ptid;

    -- FU2: Missed Follow-Ups
    UPDATE crt_visit_aggregates v
    SET v.second_follow_up_visit_outcome = 'Missed'
    WHERE v.record_id IN (SELECT f2.record_id FROM crt_wra_missed_visit_3_overview f2);

    -- FU2: Study Closure
    UPDATE crt_visit_aggregates v
    SET v.second_follow_up_visit_outcome = 'Study-Closure'
    WHERE v.record_id IN (SELECT sc.record_id
                          FROM crt_wra_study_closure sc
                          WHERE sc.visit_number = 3.0);
    /*________________________________________________________________________________*/
    -- FU3: Attempted Follow-Ups
    UPDATE crt_visit_aggregates v
        LEFT JOIN crt_wra_visit_4_overview v4 ON v4.record_id = v.record_id
    SET v.third_follow_up_visit_outcome = v4.visit_outcome
    WHERE v.wra_ptid = v4.wra_ptid
      AND v.record_id NOT IN (SELECT sc.record_id FROM crt_wra_study_closure sc);

    -- FU3: Missed Follow-Ups
    UPDATE crt_visit_aggregates v
    SET v.third_follow_up_visit_outcome = 'Missed'
    WHERE v.record_id IN (SELECT f3.record_id FROM crt_wra_missed_visit_4_overview f3);

    -- FU3: Pending Follow-Ups
    UPDATE crt_visit_aggregates v
    SET v.third_follow_up_visit_outcome = 'Pending'
    WHERE v.record_id IN (SELECT f3.record_id FROM crt_wra_pending_visit_4_overview f3)
      AND (v.third_follow_up_visit_outcome = '' OR v.third_follow_up_visit_outcome IS NULL);

    -- FU3: Study Closure
    UPDATE crt_visit_aggregates v
    SET v.third_follow_up_visit_outcome = 'Study-Closure'
    WHERE v.record_id IN (SELECT sc.record_id
                          FROM crt_wra_study_closure sc
                          WHERE sc.visit_number = 4.0);
    /*________________________________________________________________________________*/
    -- FU4: Attempted Follow-Ups
    UPDATE crt_visit_aggregates v
        LEFT JOIN crt_wra_visit_5_overview v5 ON v5.record_id = v.record_id
    SET v.fourth_follow_up_visit_outcome = v5.visit_outcome
    WHERE v.wra_ptid = v5.wra_ptid
      AND v.record_id NOT IN (SELECT sc.record_id FROM crt_wra_study_closure sc WHERE sc.visit_number IN (1.0, 2.0, 3.0, 4.0));

    -- FU4: Missed Follow-Ups
    UPDATE crt_visit_aggregates v
    SET v.fourth_follow_up_visit_outcome = 'Missed'
    WHERE v.record_id IN (SELECT f4.record_id FROM crt_wra_missed_visit_5_overview f4)
      AND v.record_id NOT IN (SELECT sc.record_id FROM crt_wra_study_closure sc WHERE sc.visit_number IN (1.0, 2.0, 3.0, 4.0));

    -- FU4: Pending Follow-Ups
    UPDATE crt_visit_aggregates v
    SET v.fourth_follow_up_visit_outcome = 'Pending'
    WHERE v.record_id IN (SELECT v4.record_id FROM crt_wra_pending_visit_5_overview v4)
      AND (v.fourth_follow_up_visit_outcome = '' OR v.fourth_follow_up_visit_outcome IS NULL)
      AND v.record_id NOT IN (SELECT sc.record_id FROM crt_wra_study_closure sc WHERE sc.visit_number IN (1.0, 2.0, 3.0, 4.0));

    -- FU4: Study Closure
    UPDATE crt_visit_aggregates v
    SET v.fourth_follow_up_visit_outcome = 'Study-Closure'
    WHERE v.record_id IN (SELECT sc.record_id
                          FROM crt_wra_study_closure sc
                          WHERE sc.visit_number = 5.0);
    /*________________________________________________________________________________*/
    -- FU5: Attempted Follow-Ups
    UPDATE crt_visit_aggregates v
        LEFT JOIN crt_wra_visit_6_overview f5 ON f5.record_id = v.record_id
    SET v.fifth_follow_up_visit_outcome = f5.visit_outcome
    WHERE v.wra_ptid = f5.wra_ptid
      AND v.record_id NOT IN (SELECT sc.record_id FROM crt_wra_study_closure sc WHERE sc.visit_number IN (1.0, 2.0, 3.0, 4.0, 5.0));

    -- FU5: Missed Follow-Ups
    UPDATE crt_visit_aggregates v
    SET v.fifth_follow_up_visit_outcome = 'Missed'
    WHERE v.record_id IN (SELECT f5.record_id FROM crt_wra_missed_visit_6_overview f5)
      AND v.record_id NOT IN (SELECT sc.record_id FROM crt_wra_study_closure sc WHERE sc.visit_number IN (1.0, 2.0, 3.0, 4.0, 5.0));

    -- TODO:: FU-5 - Memo to file
    UPDATE crt_visit_aggregates v
    SET v.fifth_follow_up_visit_outcome = 'Pending'
    WHERE v.record_id IN (SELECT f5.record_id
                          FROM crt_wra_missed_visit_6_overview f5
                          WHERE f5.follow_up_5_visit_date < DATE('2025-02-03'))
      AND v.record_id NOT IN (SELECT sc.record_id FROM crt_wra_study_closure sc WHERE sc.visit_number IN (1.0, 2.0, 3.0, 4.0, 5.0));

    -- FU5: Pending Follow-Ups
    UPDATE crt_visit_aggregates v
    SET v.fifth_follow_up_visit_outcome = 'Pending'
    WHERE v.record_id IN (SELECT f5.record_id FROM crt_wra_pending_visit_6_overview f5)
      AND (v.fifth_follow_up_visit_outcome = '' OR v.fifth_follow_up_visit_outcome IS NULL)
      AND v.record_id NOT IN (SELECT sc.record_id FROM crt_wra_study_closure sc WHERE sc.visit_number IN (1.0, 2.0, 3.0, 4.0, 5.0));

    -- FU5: Study Closure
    UPDATE crt_visit_aggregates v
    SET v.fifth_follow_up_visit_outcome = 'Study-Closure'
    WHERE v.record_id IN (SELECT sc.record_id
                          FROM crt_wra_study_closure sc
                          WHERE sc.visit_number = 6.0);
    /*________________________________________________________________________________*/
    -- Aggregates
    UPDATE crt_visit_aggregates v
    SET v.total_incomplete_follow_up_visits = get_WRA_Tx_Incomplete_Visits(v.wra_ptid),
        v.total_missed_follow_up_visits     = get_WRA_Tx_Missed_Visits(v.wra_ptid),
        v.total_complete_follow_up_visits   = get_WRA_Tx_Completed_Visits(v.wra_ptid)
    WHERE v.wra_ptid <> '';
    COMMIT;

    -- flag completion
    SELECT 'WRA-Visit-Aggregate-Data: LOADING COMPLETE' as `|_________________| Operation_Summary |_________________|`;

END $$

DELIMITER ;
