/**
 * Returns GAD-7 Score.
 * @author Gift Jr <muyembegift@gmail.com> | 25.03.25
 * @since 0.0.1
 * @alias Anxiety Screening Score.
 * @param BIGINT | DS ID
 * @return Score
 */
DROP FUNCTION IF EXISTS `getStressScreeningScore`;
DELIMITER $$
CREATE FUNCTION getStressScreeningScore(p_id BIGINT)
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

    SET @v_tx_0 := '';

    SELECT mh.anx_1,
           mh.anx_2,
           mh.anx_3,
           mh.anx_4,
           mh.anx_5,
           mh.anx_6,
           mh.anx_7
    INTO v_p1,
        v_p2,
        v_p3,
        v_p4,
        v_p5,
        v_p6,
        v_p7
    FROM wra_mental_health_assessment mh
    WHERE mh.wra_mental_health_assessment_id = p_id;

    SET @v_tx_mh = (v_p1 + v_p2 + v_p3 + v_p4 + v_p5 + v_p6 + v_p7);

    RETURN @v_tx_mh;
END $$

DELIMITER ;
