/**
 * Returns WRA estimated gestational age in days.
 * @author Gift Jr <muyembegift@gmail.com> | 09.04.25
 * @since 0.0.1
 * @alias WRA Estimated Gestational Age.
 * @param BIGINT | Record ID
 * @return MEDIUMINT | Days
 */
DROP FUNCTION IF EXISTS `getEstimatedGestationalAge_V1`;
DELIMITER $$
CREATE FUNCTION arch_etl_db.getEstimatedGestationalAge_V1(p_record_id BIGINT)
    RETURNS MEDIUMINT
    READS SQL DATA
    NOT DETERMINISTIC
BEGIN
    DECLARE v_ega MEDIUMINT DEFAULT 0;
    DECLARE v_current_visit_date DATE;
    DECLARE v_lmp_date DATE;
    DECLARE v_estimated_lmp SMALLINT;
    DECLARE v_estimated_lmp_flag VARCHAR(8);

    SELECT COALESCE(pos_v1.pos_visit_date, v1.visit_date),
           pos_v1.lmp_scdat,
           CASE pos_v1.lmp_cat_scorres
               WHEN 0 THEN pos_v1.lmp_start_weeks
               WHEN 1 THEN pos_v1.lmp_start_months
               WHEN 2 THEN pos_v1.lmp_start_years END,
           CASE pos_v1.lmp_cat_scorres
               WHEN 0 THEN 'week(s)'
               WHEN 1 THEN 'month(s)'
               WHEN 2 THEN 'year(s)' END
    INTO v_current_visit_date, v_lmp_date, v_estimated_lmp, v_estimated_lmp_flag
    FROM wra_pregnancy_overview_and_surveillance pos_v1
             JOIN arch_etl_db.crt_wra_visit_1_overview v1 on pos_v1.record_id = v1.record_id
    WHERE pos_v1.record_id = p_record_id;

    -- Use estimated LMP when exact date is not given
    IF v_estimated_lmp_flag = 'week(s)' THEN
        SET v_lmp_date = DATE_SUB(v_current_visit_date, INTERVAL v_estimated_lmp WEEK);
    ELSEIF v_estimated_lmp_flag = 'month(s)' THEN
        SET v_lmp_date = DATE_SUB(v_current_visit_date, INTERVAL v_estimated_lmp MONTH);
    ELSEIF v_estimated_lmp_flag = 'year(s)' THEN
        SET v_lmp_date = DATE_SUB(v_current_visit_date, INTERVAL v_estimated_lmp YEAR);
    END IF;
    -- Calculate the age of the fetus in the womb using the 4 ⅓ formula.
    SET @v_lmp_day = CAST(DAY(v_lmp_date) as SIGNED); -- LMP Date Day
    SET @v_curr_day = CAST(DAY(v_current_visit_date) as SIGNED ); -- Visit Date Day
    SET @v_lmp_month = CAST(MONTH(v_lmp_date) as SIGNED ); -- LMP Date Month
    SET @v_curr_month = CAST(MONTH(v_current_visit_date) as SIGNED );
    -- Visit Date Month
    -- Gestational age = {(Current date – LMP) x (4 ⅓)}
    SET @v_ga_days = (@v_curr_day - @v_lmp_day);
    SET @v_ga_months = (@v_curr_month - @v_lmp_month);
    SET @v_ga_m_weeks = @v_ga_months * (4 * (1 / 3));
    SET v_ega = @v_ga_days + (@v_ga_m_weeks * 7);

    RETURN v_ega;
END $$

DELIMITER ;

-- SELECT getEstimatedGestationalAge_V1(2);
-- SELECT getEstimatedGestationalAge_V1(5);
-- SELECT getEstimatedGestationalAge_V1(9);
