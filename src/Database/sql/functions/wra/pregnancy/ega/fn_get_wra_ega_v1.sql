/**
 * Returns WRA Baseline estimated gestational age in Week(s) and Day(s).

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
DROP FUNCTION IF EXISTS `getEstimatedGestationalAge_V1`;
DELIMITER $$
CREATE FUNCTION arch_etl_db.getEstimatedGestationalAge_V1(p_record_id BIGINT)
    RETURNS DOUBLE
    READS SQL DATA
    DETERMINISTIC
BEGIN
    DECLARE v_ega NUMERIC(4, 1);
    DECLARE v_current_visit_date DATE;
    DECLARE v_lmp_date DATE;
    DECLARE v_ega_weeks SMALLINT;
    DECLARE v_ega_days_remainder SMALLINT;

    -- WRA Baseline Pregnancy Surveillance
    SELECT COALESCE(pos_v1.pos_visit_date, v1.visit_date),
           IF(pos_v1.lmp_start_scorres = 1, pos_v1.lmp_scdat, getEstimated_LMP_V1(p_record_id))
    INTO v_current_visit_date, v_lmp_date
    FROM wra_pregnancy_overview_and_surveillance pos_v1
             JOIN arch_etl_db.crt_wra_visit_1_overview v1 on pos_v1.record_id = v1.record_id
    WHERE pos_v1.record_id = p_record_id;

    -- LMP date cannot be in the future.
    IF v_lmp_date IS NOT NULL AND v_lmp_date <= v_current_visit_date THEN
        -- Calculate the total number of days between the LMP date and the current visit date
        SET @ega_days_difference = DATEDIFF(v_current_visit_date, v_lmp_date);
        -- Calculate the number of full weeks, integer division in SQL automatically floors the result
        SET v_ega_weeks = FLOOR(@ega_days_difference / 7);
        -- Calculate the remaining number of days
        SET v_ega_days_remainder = MOD(@ega_days_difference, 7);
        -- Merge week(s) and day(s) into final EGA result
        SET v_ega = CAST(CONCAT_WS('.', v_ega_weeks, v_ega_days_remainder) as DOUBLE);
    ELSE
        RETURN NULL;
    END IF;

    RETURN v_ega;
END $$
DELIMITER ;