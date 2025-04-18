/**
 * Returns WRAs total number of missed visits.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 15.01.25
 * @since 0.0.1
 * @alias Get WRA Tx Missed Visits.
 * @param varchar WRA PTID
 * @return Tx Number of Missed Visits
 */
DROP FUNCTION IF EXISTS `get_WRA_Tx_Missed_Visits`;
DELIMITER $$
CREATE FUNCTION get_WRA_Tx_Missed_Visits(p_wra_ptid VARCHAR(6))
    RETURNS INT
    NOT DETERMINISTIC
BEGIN
    DECLARE v_total INT DEFAULT 0;

    SELECT v.first_follow_up_visit_outcome,
           v.second_follow_up_visit_outcome,
           v.third_follow_up_visit_outcome,
           v.fourth_follow_up_visit_outcome
    INTO @v_first_follow_up_visit_outcome, @v_second_follow_up_visit_outcome, @v_third_follow_up_visit_outcome, @v_fourth_follow_up_visit_outcome
    FROM crt_visit_aggregates v
    WHERE v.wra_ptid = p_wra_ptid;

    -- Start with first visit
    IF @v_first_follow_up_visit_outcome = 'Missed' THEN
        SET v_total = 1;
    ELSE
        SET v_total = v_total;
    END IF;

    IF @v_second_follow_up_visit_outcome = 'Missed' THEN
        SET v_total = v_total + 1;
    ELSE
        SET v_total = v_total;
    END IF;

    IF @v_third_follow_up_visit_outcome = 'Missed' THEN
        SET v_total = v_total + 1;
    ELSE
        SET v_total = v_total;
    END IF;

    IF @v_fourth_follow_up_visit_outcome = 'Missed' THEN
        SET v_total = v_total + 1;
    ELSE
        SET v_total = v_total;
    END IF;

    -- Return status as result
    RETURN v_total;
END $$

DELIMITER ;
