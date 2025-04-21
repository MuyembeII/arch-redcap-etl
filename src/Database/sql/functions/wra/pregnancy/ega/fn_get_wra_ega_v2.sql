/**
 * Returns WRA Follow-Up 1 estimated gestational age in Week(s) and Day(s).

 * By using the LMP date and the current visit date to find the difference in
 * days, the result is casted into weeks and then the remainder of days appended
 * is appended after the week expression i,.e 29.4 is denoted as 29 weeks and 4
 * days. Note that the days expression range is 1 to 7.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 09.04.25
 * @since 0.0.1
 * @alias WRA Estimated Gestational Age.
 * @param BIGINT | Record ID
 * @return DOUBLE | Week(s) and Day(s)
 * @see https://github.com/GITmarvel/EDD-and-EGA-calculation
 */
DROP FUNCTION IF EXISTS `getEstimatedGestationalAge_V2`;
DELIMITER $$
CREATE FUNCTION arch_etl_db.getEstimatedGestationalAge_V2(p_record_id BIGINT)
    RETURNS DOUBLE
    READS SQL DATA
    DETERMINISTIC
BEGIN
    DECLARE v_ega NUMERIC(4, 1);
    DECLARE v_current_visit_date DATE;
    DECLARE v_fu_lmp_date DATE;

    SELECT COALESCE(ps_v2.ps_fu_visit_date, v2.visit_date),
           IF(ps_v2.fu_lmp_start_scorres = 1, ps_v2.fu_lmp_scdat, getEstimated_LMP_V1(p_record_id))
    INTO v_current_visit_date, v_fu_lmp_date
    FROM wrafu_pregnancy_surveillance ps_v2
             JOIN arch_etl_db.crt_wra_visit_2_overview v2 on ps_v2.record_id = v2.record_id
    WHERE ps_v2.record_id = p_record_id;

    -- LMP date cannot be in the future.
    IF v_fu_lmp_date IS NOT NULL AND v_fu_lmp_date <= v_current_visit_date THEN
        -- Calculate the total number of days between the LMP date and the current visit date
        SET @ega_days_difference = DATEDIFF(v_current_visit_date, v_fu_lmp_date);
        -- Calculate the number of full weeks, integer division in SQL automatically floors the result
        SET @ega_weeks = @ega_days_difference / 7;
        -- Calculate the remaining number of days
        SET @ega_remainder_days = @ega_days_difference % 7;
        -- Merge week(s) and day(s) into final EGA result
        SET v_ega = CAST(CONCAT_WS('.', @ega_weeks, @ega_remainder_days) as DOUBLE);
    ELSE
        RETURN NULL;
    END IF;

    RETURN v_ega;
END $$

DELIMITER ;
