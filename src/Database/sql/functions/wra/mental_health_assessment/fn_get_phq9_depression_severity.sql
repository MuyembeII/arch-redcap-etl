/**
 * Returns PHQ9 Depression Severity.
 * @author Gift Jr <muyembegift@gmail.com> | 28.03.25
 * @since 0.0.1
 * @alias Get Referral Reasons.
 * @param BIGINT | PHQ-9 Total(tx) Score
 * @return Severity
 */
DROP FUNCTION IF EXISTS `arch_etl_db.getDepressionScreeningSeverity`;
DELIMITER $$
CREATE FUNCTION arch_etl_db.getDepressionScreeningSeverity(p_phq9_tx_score BIGINT)
    RETURNS TINYTEXT
    NOT DETERMINISTIC
BEGIN
    DECLARE v_severity TINYTEXT;
    IF p_phq9_tx_score = 0 THEN
        SET v_severity = 'None';
    ELSEIF p_phq9_tx_score > 0 AND p_phq9_tx_score <= 4 THEN
        SET v_severity = 'Minimal Depression';
    ELSEIF p_phq9_tx_score >= 5 AND p_phq9_tx_score <= 9 THEN
        SET v_severity = 'Mild Depression';
    ELSEIF p_phq9_tx_score >= 10 AND p_phq9_tx_score <= 14 THEN
        SET v_severity = 'Moderate Depression';
    ELSEIF p_phq9_tx_score >= 15 AND p_phq9_tx_score <= 19 THEN
        SET v_severity = 'Moderately Severe Depression';
    ELSEIF p_phq9_tx_score >= 20 AND p_phq9_tx_score <= 27 THEN
        SET v_severity = 'Severe Depression';
    END IF;
    RETURN v_severity;
END $$

DELIMITER ;
