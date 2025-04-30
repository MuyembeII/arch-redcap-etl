/**
 * ;) :) how bou' dee?!!!
  |-------------------------------------------------------------------------------------------|
 * I want to give you WRA-Baseline Visit estimated last menstrual period(LMP) visit date...
 * For WRA's who don't recall the exact date of their LMP, we calculate the LMP using
 * provided week, month or year differentiated by the current interview visit date.
  |-------------------------------------------------------------------------------------------|
 * @author Gift Jr <muyembegift@gmail.com> | 18.04.25
 * @since 0.0.1
 * @alias WRA Estimated LMP.
 * @param BIGINT | Record ID
 * @return DATE | LMP Date
 */
DROP FUNCTION IF EXISTS `getEstimated_LMP_V1`;
DELIMITER $$
CREATE FUNCTION arch_etl_db.getEstimated_LMP_V1(p_record_id BIGINT)
    RETURNS DATE
    READS SQL DATA
    NOT DETERMINISTIC
BEGIN
    DECLARE v_estimated_lmp DATE;
    DECLARE v_current_visit_date DATE;
    -- flags
    DECLARE v_estimated_lmp_flag SMALLINT;
    DECLARE v_unknown_lmp_flag SMALLINT DEFAULT 98;
    -- recalled lmp's
    DECLARE v_lmp_weeks SMALLINT;
    DECLARE v_lmp_months SMALLINT;
    DECLARE v_lmp_years SMALLINT;

    SELECT COALESCE(pos_v1.pos_visit_date, v1.visit_date),
           pos_v1.lmp_start_weeks,
           pos_v1.lmp_start_months,
           pos_v1.lmp_start_years,
           pos_v1.lmp_cat_scorres
    INTO v_current_visit_date, v_lmp_weeks, v_lmp_months, v_lmp_years, v_estimated_lmp_flag
    FROM wra_pregnancy_overview_and_surveillance pos_v1
             JOIN arch_etl_db.crt_wra_visit_1_overview v1 on pos_v1.record_id = v1.record_id
    WHERE pos_v1.record_id = p_record_id;

    /*  |NOTE| Automatic Adjusted Day (AAD), see https://www.educba.com/mysql-date-sub/
     *  | The day will be adjusted to the maximum day in the new week/month/year. |
     */
    IF v_estimated_lmp_flag != v_unknown_lmp_flag THEN
        -- Reduce execution time performance, if LMP us unknown no need to work the DB
        IF v_estimated_lmp_flag = 0 THEN
            SET v_estimated_lmp = DATE_SUB(v_current_visit_date, INTERVAL v_lmp_weeks WEEK);
        ELSEIF v_estimated_lmp_flag = 1 THEN
            SET v_estimated_lmp = DATE_SUB(v_current_visit_date, INTERVAL v_lmp_months MONTH);
        ELSEIF v_estimated_lmp_flag = 2 THEN
            SET v_estimated_lmp = DATE_SUB(v_current_visit_date, INTERVAL v_lmp_years YEAR);
        END IF;
    ELSE
        RETURN NULL;
    END IF;

    RETURN v_estimated_lmp;
END $$

DELIMITER ;

-- SELECT getEstimatedGestationalAge_V1(2);
-- SELECT getEstimatedGestationalAge_V1(5);
-- SELECT getEstimatedGestationalAge_V1(9);
