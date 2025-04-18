/**
 * Returns Last Recorded UPT Result.
 * <br/>
 * Given the factor of missed visits, a traversal in the POC to capture
 * the last collected pregnancy-test excluding the current visit.
 * @author Gift Jr <muyembegift@gmail.com> | 18.03.25
 * @since 0.0.1
 * @alias Get WRA Last UPT Result.
 * @param BIGINT | Record ID
 * @param DECIMAL | Visit ID
 * @return Outcome of UPT
 */
DROP FUNCTION IF EXISTS `get_Last_UPT_Result`;
DELIMITER $$
CREATE FUNCTION get_Last_UPT_Result(p_record_id BIGINT, p_visit_id DECIMAL(10, 1))
    RETURNS VARCHAR(8)
    NOT DETERMINISTIC
BEGIN
    DECLARE v_last_test_outcome VARCHAR(8);
    SELECT poc.upt_result
    INTO v_last_test_outcome
    FROM crt_wra_point_of_collection_overview poc
    WHERE poc.record_id = p_record_id
      AND poc.visit_number < p_visit_id
    GROUP BY poc.wra_ptid, poc.visit_number
    ORDER BY poc.visit_number DESC
    LIMIT 1;
    RETURN v_last_test_outcome;
END $$

DELIMITER ;
