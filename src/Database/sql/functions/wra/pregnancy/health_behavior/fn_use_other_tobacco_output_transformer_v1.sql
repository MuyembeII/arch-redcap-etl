/**
 * Get Baseline transformed Other-Tobacco consumed output of WRA Health Behaviors in Pregnancy
 *
 * @author Gift Jr <muyembegift@gmail.com> | 23.04.25
 * @since 0.0.1
 * @alias Other-Tobacco | use_OtherTobaccoConsumedTransformer_V1 .
 * @param BIGINT | Record ID
 * @return TEXT | formatted-text
 */
DROP FUNCTION IF EXISTS `use_OtherTobaccoConsumedTransformer_V1`;
DELIMITER $$
CREATE FUNCTION use_OtherTobaccoConsumedTransformer_V1(p_record_id BIGINT)
    RETURNS TINYTEXT
    DETERMINISTIC
BEGIN
    DECLARE v_hb_other_tobacco_consumed_v1 TEXT;

    DECLARE v_hb_other_tobacco_consumed_1 VARCHAR(32);
    DECLARE v_hb_other_tobacco_consumed_2 VARCHAR(32);
    DECLARE v_hb_other_tobacco_consumed_3 VARCHAR(32);
    DECLARE v_hb_other_tobacco_consumed_4 VARCHAR(32);
    DECLARE v_hb_other_tobacco_consumed_5 VARCHAR(32);
    DECLARE v_hb_other_tobacco_consumed_6 VARCHAR(32);
    DECLARE v_hb_other_tobacco_consumed_7 VARCHAR(32);

    SELECT IF(pa_v1.tob_oth_sutrt___1 = 1, CONCAT_WS(',', pa_v1.tob_oth_sutrt___1_label, ' '), ''),
           IF(pa_v1.tob_oth_sutrt___2 = 1, CONCAT_WS(',', pa_v1.tob_oth_sutrt___2_label, ' '), ''),
           IF(pa_v1.tob_oth_sutrt___3 = 1, CONCAT_WS(',', pa_v1.tob_oth_sutrt___3_label, ' '), ''),
           IF(pa_v1.tob_oth_sutrt___4 = 1, CONCAT_WS(',', pa_v1.tob_oth_sutrt___4_label, ' '), ''),
           IF(pa_v1.tob_oth_sutrt___5 = 1, CONCAT_WS(',', pa_v1.tob_oth_sutrt___5_label, ' '), ''),
           IF(pa_v1.tob_oth_sutrt___6 = 1, CONCAT_WS(',', pa_v1.tob_oth_sutrt___6_label, ' '), ''),
           IF(pa_v1.tob_oth_sutrt___7 = 1, pa_v1.other_tbc_use, '')
    INTO v_hb_other_tobacco_consumed_1,
        v_hb_other_tobacco_consumed_2,
        v_hb_other_tobacco_consumed_3,
        v_hb_other_tobacco_consumed_4,
        v_hb_other_tobacco_consumed_5,
        v_hb_other_tobacco_consumed_6,
        v_hb_other_tobacco_consumed_7
    FROM wra_pregnancy_assessments pa_v1
    WHERE CAST(pa_v1.record_id as UNSIGNED) = p_record_id;

    SET v_hb_other_tobacco_consumed_v1 = CONCAT(
            v_hb_other_tobacco_consumed_1,
            v_hb_other_tobacco_consumed_2,
            v_hb_other_tobacco_consumed_3,
            v_hb_other_tobacco_consumed_4,
            v_hb_other_tobacco_consumed_5,
            v_hb_other_tobacco_consumed_6,
            v_hb_other_tobacco_consumed_7);
    SET v_hb_other_tobacco_consumed_v1 = TRIM(',' FROM TRIM(v_hb_other_tobacco_consumed_v1));

    RETURN v_hb_other_tobacco_consumed_v1;
END $$
DELIMITER ;