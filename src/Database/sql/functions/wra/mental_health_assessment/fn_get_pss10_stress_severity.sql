/**
 * Returns PSS10 Stress Assessment Severity.
 * @author Gift Jr <muyembegift@gmail.com> | 01.04.25
 * @since 0.0.1
 * @alias Get PSS-10 Severity.
 * @param BIGINT | PSS-10 Total(tx) Score
 * @return Severity
 */
DROP FUNCTION IF EXISTS `getStressAssessmentSeverity`;
DELIMITER $$
CREATE FUNCTION arch_etl_db.getStressAssessmentSeverity(p_pss10_tx_score BIGINT)
    RETURNS TINYTEXT
    NOT DETERMINISTIC
BEGIN
    DECLARE v_severity TINYTEXT;
    IF p_pss10_tx_score = 0 THEN
        SET v_severity = 'None';
    ELSEIF p_pss10_tx_score > 0 AND p_pss10_tx_score <= 13 THEN
        SET v_severity = 'Low Stress';
    ELSEIF p_pss10_tx_score >= 14 AND p_pss10_tx_score <= 26 THEN
        SET v_severity = 'Moderate Stress';
    ELSEIF p_pss10_tx_score >= 27 AND p_pss10_tx_score <= 40 THEN
        SET v_severity = 'High Perceived Stress';
    ELSE
        SET v_severity = '';
    END IF;
    RETURN v_severity;
END $$

DELIMITER ;
