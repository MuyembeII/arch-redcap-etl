/**
 * Returns WRA estimated gestational age in days.
 * @author Gift Jr <muyembegift@gmail.com> | 14.04.25
 * @since 0.0.1
 * @alias WRA Estimated Gestational Age.
 * @param BIGINT | Record ID
 * @return MEDIUMINT | Days
 */
DROP FUNCTION IF EXISTS `getEstimatedGestationalAge_V4`;
DELIMITER $$
CREATE FUNCTION arch_etl_db.getEstimatedGestationalAge_V4(p_record_id BIGINT)
    RETURNS MEDIUMINT
    READS SQL DATA
    NOT DETERMINISTIC
BEGIN
    DECLARE v_ega MEDIUMINT DEFAULT 0;
    DECLARE v_current_visit_date DATE;
    DECLARE v_fu_lmp_date DATE;
    DECLARE v_estimated_fu_lmp SMALLINT;
    DECLARE v_estimated_fu_lmp_flag VARCHAR(8);

    SELECT COALESCE(ps_v4.ps_fu_visit_date_f3, v4.visit_date),
           ps_v4.fu_lmp_scdat_f3,
           CASE ps_v4.fu_lmp_cat_scorres_f3
               WHEN 0 THEN ps_v4.fu_lmp_start_weeks_f3
               WHEN 1 THEN ps_v4.fu_lmp_start_months_f3
               WHEN 2 THEN ps_v4.fu_lmp_start_years_f3 END,
           CASE ps_v4.fu_lmp_cat_scorres_f3
               WHEN 0 THEN 'week(s)'
               WHEN 1 THEN 'month(s)'
               WHEN 2 THEN 'year(s)' END
    INTO v_current_visit_date, v_fu_lmp_date, v_estimated_fu_lmp, v_estimated_fu_lmp_flag
    FROM wrafu_pregnancy_surveillance_3 ps_v4
             JOIN arch_etl_db.crt_wra_visit_4_overview v4 on ps_v4.record_id = v4.record_id
    WHERE ps_v4.record_id = p_record_id;

    -- Use estimated LMP when exact date is not given
    IF v_estimated_fu_lmp_flag = 'week(s)' THEN
        SET v_fu_lmp_date = DATE_SUB(v_current_visit_date, INTERVAL v_estimated_fu_lmp WEEK);
    ELSEIF v_estimated_fu_lmp_flag = 'month(s)' THEN
        SET v_fu_lmp_date = DATE_SUB(v_current_visit_date, INTERVAL v_estimated_fu_lmp MONTH);
    ELSEIF v_estimated_fu_lmp_flag = 'year(s)' THEN
        SET v_fu_lmp_date = DATE_SUB(v_current_visit_date, INTERVAL v_estimated_fu_lmp YEAR);
    END IF;
    -- Calculate the age of the fetus in the womb using the 4 ⅓ formula.
    SET @v_fu_lmp_day = CAST(DAY(v_fu_lmp_date) as UNSIGNED); -- LMP Date Day
    SET @v_curr_day = CAST(DAY(v_current_visit_date) as UNSIGNED); -- Visit Date Day
    SET @v_fu_lmp_month = CAST(MONTH(v_fu_lmp_date) as UNSIGNED); -- LMP Date Month
    SET @v_curr_month = CAST(MONTH(v_current_visit_date) as UNSIGNED);
    -- Visit Date Month
    -- Gestational age = {(Current date – LMP) x (4 ⅓)}
    SET @v_ga_days = (@v_curr_day - @v_fu_lmp_day);
    SET @v_ga_months = (@v_curr_month - @v_fu_lmp_month);
    SET @v_ga_m_weeks = @v_ga_months * (4 * (1 / 3));
    SET v_ega = @v_ga_days + (@v_ga_m_weeks * 7);

    RETURN v_ega;
END $$

DELIMITER ;
