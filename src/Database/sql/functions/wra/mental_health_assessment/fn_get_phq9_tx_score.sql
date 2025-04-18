/**
 * Returns PHQ9 Score.
 * @author Gift Jr <muyembegift@gmail.com> | 25.03.25
 * @since 0.0.1
 * @alias Depression Screening Score.
 * @param BIGINT | DS ID
 * @return Score
 */
DROP FUNCTION IF EXISTS `getDepressionScreeningScore`;
DELIMITER $$
CREATE FUNCTION getDepressionScreeningScore(p_id BIGINT)
    RETURNS SMALLINT
    NOT DETERMINISTIC
BEGIN

    DECLARE v_p1 SMALLINT;
    DECLARE v_p2 SMALLINT;
    DECLARE v_p3 SMALLINT;
    DECLARE v_p4 SMALLINT;
    DECLARE v_p5 SMALLINT;
    DECLARE v_p6 SMALLINT;
    DECLARE v_p7 SMALLINT;
    DECLARE v_p8 SMALLINT;
    DECLARE v_p9 SMALLINT;

    SET @v_tx_0 := '';

    SELECT mh.phq9_interest_scorres,
           mh.phq9_dprs_scorres,
           mh.phq9_sleep_scorres,
           mh.phq9_tired_scorres,
           mh.phq9_app_scorres ,
           mh.phq9_bad_scorres,
           mh.phq9_conc_scorres,
           mh.phq9_slow_scorres,
           mh.phq9_hurt_scorres
    INTO v_p1,
        v_p2,
        v_p3,
        v_p4,
        v_p5,
        v_p6,
        v_p7,
        v_p8,
        v_p9
    FROM wra_mental_health_assessment mh
    WHERE mh.wra_mental_health_assessment_id = p_id;

    SET @v_tx_mh = (v_p1 + v_p2 + v_p3 + v_p4 + v_p5 + v_p6 + v_p7 + v_p8 + v_p9);

    RETURN @v_tx_mh;
END $$

DELIMITER ;
