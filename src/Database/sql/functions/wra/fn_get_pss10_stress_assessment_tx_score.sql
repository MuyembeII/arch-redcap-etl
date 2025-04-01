/**
 * Returns PSS-10 Score.
 * @author Gift Jr <muyembegift@gmail.com> | 01.04.25
 * @since 0.0.1
 * @alias Perceived Stress Assessment Score.
 * @param BIGINT | DS ID
 * @return Score
 */
DROP FUNCTION IF EXISTS `getStressAssessmentScore`;
DELIMITER $$
CREATE FUNCTION getStressAssessmentScore(p_id BIGINT)
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
    DECLARE v_p10 SMALLINT;

    SET @v_tx_0 := '';

    SELECT mh.pss_upset_scorres,
           mh.pss_no_ctrl_scorres,
           mh.pss_nervous_scorres,
           CASE
               WHEN mh.pss_confid_scorres = 0 THEN 4
               WHEN mh.pss_confid_scorres = 1 THEN 3
               WHEN mh.pss_confid_scorres = 2 THEN 2
               WHEN mh.pss_confid_scorres = 3 THEN 1
               WHEN mh.pss_confid_scorres = 4 THEN 0
               END,
           CASE
               WHEN mh.pss_yrway_scorres = 0 THEN 4
               WHEN mh.pss_yrway_scorres = 1 THEN 3
               WHEN mh.pss_yrway_scorres = 2 THEN 2
               WHEN mh.pss_yrway_scorres = 3 THEN 1
               WHEN mh.pss_yrway_scorres = 4 THEN 0
               END,
           mh.pss_cope_scorres,
           CASE
               WHEN mh.pss_ctrl_scorres = 0 THEN 4
               WHEN mh.pss_ctrl_scorres = 1 THEN 3
               WHEN mh.pss_ctrl_scorres = 2 THEN 2
               WHEN mh.pss_ctrl_scorres = 3 THEN 1
               WHEN mh.pss_ctrl_scorres = 4 THEN 0
               END,
           CASE
               WHEN mh.pss_ontop_scorres = 0 THEN 4
               WHEN mh.pss_ontop_scorres = 1 THEN 3
               WHEN mh.pss_ontop_scorres = 2 THEN 2
               WHEN mh.pss_ontop_scorres = 3 THEN 1
               WHEN mh.pss_ontop_scorres = 4 THEN 0
               END,
           mh.pss_anger_scorres,
           mh.pss_dfclt_scorres
    INTO v_p1,
        v_p2,
        v_p3,
        v_p4,
        v_p5,
        v_p6,
        v_p7,
        v_p8,
        v_p9,
        v_p10
    FROM wra_mental_health_assessment mh
    WHERE mh.wra_mental_health_assessment_id = p_id;

    SET @v_tx_mh = (v_p1 + v_p2 + v_p3 + v_p4 + v_p5 + v_p6 + v_p7 + v_p8 + v_p9 + v_p10);

    RETURN @v_tx_mh;
END $$

DELIMITER ;
