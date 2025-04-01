/**
 * Returns GAD7 Anxiety Severity.
 * @author Gift Jr <muyembegift@gmail.com> | 28.03.25
 * @since 0.0.1
 * @alias Get GAD-7 Severity.
 * @param BIGINT | GAD-7 Total(tx) Score
 * @return Severity
 */
DROP FUNCTION IF EXISTS `getAnxietyScreeningSeverity`;
DELIMITER $$
CREATE FUNCTION arch_etl_db.getAnxietyScreeningSeverity(p_gad7_tx_score BIGINT)
    RETURNS TINYTEXT
    NOT DETERMINISTIC
BEGIN
    DECLARE v_severity TINYTEXT;
    IF p_gad7_tx_score = 0 THEN
        SET v_severity = 'None';
    ELSEIF p_gad7_tx_score > 0 AND p_gad7_tx_score <= 4 THEN
        SET v_severity = 'Minimal Anxiety';
    ELSEIF p_gad7_tx_score >= 5 AND p_gad7_tx_score <= 9 THEN
        SET v_severity = 'Mild Anxiety';
    ELSEIF p_gad7_tx_score >= 10 AND p_gad7_tx_score <= 14 THEN
        SET v_severity = 'Moderate Anxiety';
    ELSEIF p_gad7_tx_score >= 15 AND p_gad7_tx_score <= 21 THEN
        SET v_severity = 'Severe Anxiety';
    END IF;
    RETURN v_severity;
END $$

DELIMITER ;
