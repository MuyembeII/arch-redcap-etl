/**
 * Returns Number of Days Since the WRA Enrollment.
 * @author Gift Jr <muyembegift@gmail.com> | 28.03.25
 * @since 0.0.1
 * @alias Get Days Since Last Baseline Visit.
 * @param BIGINT | Record ID
 * @param DATE | Current Visit Date
 * @return MEDIUMINT | Days
 */
DROP FUNCTION IF EXISTS `arch_etl_db.getDaysSinceBaselineVisit`;
DELIMITER $$
CREATE FUNCTION arch_etl_db.getDaysSinceBaselineVisit(p_record_id BIGINT, p_current_visit_date DATE)
    RETURNS MEDIUMINT
    READS SQL DATA
    NOT DETERMINISTIC
BEGIN
    DECLARE v_number_of_days MEDIUMINT DEFAULT 0;
    SELECT DATEDIFF(p_current_visit_date, baseline_visit.visit_date) as number_of_days
    INTO v_number_of_days
    FROM crt_wra_visit_1_overview baseline_visit
    WHERE baseline_visit.record_id = p_record_id;
    RETURN v_number_of_days;
END $$

DELIMITER ;
