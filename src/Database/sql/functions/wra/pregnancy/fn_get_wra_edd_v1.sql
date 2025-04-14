/**
 * Returns WRA estimated date of delivery.
 * @author Gift Jr <muyembegift@gmail.com> | 11.04.25
 * @since 0.0.1
 * @alias WRA Estimated Date of Delivery.
 * @param BIGINT | Record ID
 * @return DATE | EDD
 */
DROP FUNCTION IF EXISTS `getEstimatedDateOfDelivery_V1`;
DELIMITER $$
CREATE FUNCTION arch_etl_db.getEstimatedDateOfDelivery_V1(p_record_id BIGINT)
    RETURNS DATE
    READS SQL DATA
    NOT DETERMINISTIC
BEGIN
    DECLARE v_edd DATE;
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
    IF v_estimated_lmp_flag = 'week(s)' AND LENGTH(v_lmp_date) < 10 THEN
        SET v_lmp_date = DATE_SUB(v_current_visit_date, INTERVAL v_estimated_lmp WEEK);
    ELSEIF v_estimated_lmp_flag = 'month(s)' AND LENGTH(v_lmp_date) < 10 THEN
        SET v_lmp_date = DATE_SUB(v_current_visit_date, INTERVAL v_estimated_lmp MONTH);
    ELSEIF v_estimated_lmp_flag = 'year(s)' AND LENGTH(v_lmp_date) < 10 THEN
        SET v_lmp_date = DATE_SUB(v_current_visit_date, INTERVAL v_estimated_lmp YEAR);
    END IF;
    -- Calculate the 
    SET @v_delivery_date = DATE_ADD(v_lmp_date, INTERVAL 1 YEAR);
    SET @v_delivery_date = DATE_SUB(@v_delivery_date, INTERVAL 3 MONTH);
    SET v_edd = DATE_ADD(@v_delivery_date, INTERVAL 7 DAY);

    RETURN v_edd;
END $$

DELIMITER ;
