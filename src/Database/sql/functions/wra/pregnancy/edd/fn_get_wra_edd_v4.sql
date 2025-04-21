/**
 * Returns WRA FU-3 estimated date of delivery(EDD) using Naegele’s rule.
 * @author Gift Jr <muyembegift@gmail.com> | 11.04.25
 * @since 0.0.1
 * @alias WRA Estimated Date of Delivery.
 * @param BIGINT | Record ID
 * @return DATE | EDD
 * @see https://www.ncbi.nlm.nih.gov/sites/books/NBK536986/
 */
DROP FUNCTION IF EXISTS `getEstimatedDateOfDelivery_V4`;
DELIMITER $$
CREATE FUNCTION arch_etl_db.getEstimatedDateOfDelivery_V4(p_record_id BIGINT)
    RETURNS DATE
    READS SQL DATA
    NOT DETERMINISTIC
BEGIN
    DECLARE v_edd,v_fu_lmp_date DATE;
    -- WRA FU-3 Pregnancy Surveillance
    SELECT IF(pos_v4.fu_lmp_start_scorres_f3 = 1, pos_v4.fu_lmp_scdat_f3, getEstimated_LMP_V1(p_record_id))
    INTO v_fu_lmp_date
    FROM wrafu_pregnancy_surveillance_3 pos_v4
             JOIN arch_etl_db.crt_wra_visit_4_overview v4 on pos_v4.record_id = v4.record_id
    WHERE pos_v4.record_id = p_record_id;
    -- LMP date cannot be in the future.
    IF v_fu_lmp_date IS NOT NULL THEN
        SET @v_delivery_date = DATE_ADD(v_fu_lmp_date, INTERVAL 1 YEAR);
        SET @v_delivery_date = DATE_SUB(@v_delivery_date, INTERVAL 3 MONTH);
        SET v_edd = DATE_ADD(@v_delivery_date, INTERVAL 7 DAY);
    ELSE
        RETURN NULL;
    END IF;
    RETURN v_edd;
END $$

DELIMITER ;
