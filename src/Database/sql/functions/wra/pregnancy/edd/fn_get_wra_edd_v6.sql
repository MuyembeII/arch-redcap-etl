/**
 * Returns WRA estimated date of delivery.
 * @author Gift Jr <muyembegift@gmail.com> | 14.04.25
 * @since 0.0.1
 * @alias WRA Estimated Date of Delivery.
 * @param BIGINT | Record ID
 * @return DATE | EDD
 */
DROP FUNCTION IF EXISTS `getEstimatedDateOfDelivery_V6`;
DELIMITER $$
CREATE FUNCTION arch_etl_db.getEstimatedDateOfDelivery_V6(p_record_id BIGINT)
    RETURNS DATE
    READS SQL DATA
    NOT DETERMINISTIC
BEGIN
    DECLARE v_edd DATE;
    DECLARE v_current_visit_date DATE;
    DECLARE v_fu_lmp_date DATE;
    DECLARE v_estimated_fu_lmp SMALLINT;
    DECLARE v_estimated_fu_lmp_flag VARCHAR(8);

    SELECT COALESCE(pos_v6.ps_fu_visit_date_f5, v6.visit_date),
           pos_v6.fu_lmp_scdat_f5,
           CASE pos_v6.fu_lmp_cat_scorres_f5
               WHEN 0 THEN pos_v6.fu_lmp_start_weeks_f5
               WHEN 1 THEN pos_v6.fu_lmp_start_months_f5
               WHEN 2 THEN pos_v6.fu_lmp_start_years_f5 END,
           CASE pos_v6.fu_lmp_cat_scorres_f5
               WHEN 0 THEN 'week(s)'
               WHEN 1 THEN 'month(s)'
               WHEN 2 THEN 'year(s)' END
    INTO v_current_visit_date, v_fu_lmp_date, v_estimated_fu_lmp, v_estimated_fu_lmp_flag
    FROM wrafu_pregnancy_surveillance_6 pos_v6
             JOIN arch_etl_db.crt_wra_visit_5_overview v6 on pos_v6.record_id = v6.record_id
    WHERE pos_v6.record_id = p_record_id;

    -- Use estimated LMP when exact date is not given
    IF v_estimated_fu_lmp_flag = 'week(s)' THEN
        SET v_fu_lmp_date = DATE_SUB(v_current_visit_date, INTERVAL v_estimated_fu_lmp WEEK);
    ELSEIF v_estimated_fu_lmp_flag = 'month(s)' THEN
        SET v_fu_lmp_date = DATE_SUB(v_current_visit_date, INTERVAL v_estimated_fu_lmp MONTH);
    ELSEIF v_estimated_fu_lmp_flag = 'year(s)' THEN
        SET v_fu_lmp_date = DATE_SUB(v_current_visit_date, INTERVAL v_estimated_fu_lmp YEAR);
    END IF;
    -- Calculate the 
    SET @v_delivery_date = DATE_ADD(v_fu_lmp_date, INTERVAL 1 YEAR);
    SET @v_delivery_date = DATE_SUB(@v_delivery_date, INTERVAL 3 MONTH);
    SET v_edd = DATE_ADD(@v_delivery_date, INTERVAL 7 DAY);

    RETURN v_edd;
END $$

DELIMITER ;
