/**
 * Get FU-3 transformed Other-Tobacco consumed output of WRA Health Behaviors in Pregnancy
 *
 * @author Gift Jr <muyembegift@gmail.com> | 23.04.25
 * @since 0.0.1
 * @alias Other-Tobacco | use_OtherTobaccoConsumedTransformer_V4 .
 * @param BIGINT | Record ID
 * @return TEXT | formatted-text
 */
DROP FUNCTION IF EXISTS `use_OtherTobaccoConsumedTransformer_V4`;
DELIMITER $$
CREATE FUNCTION use_OtherTobaccoConsumedTransformer_V4(p_record_id BIGINT)
    RETURNS TINYTEXT
    DETERMINISTIC
BEGIN
    DECLARE v_hb_other_tobacco_consumed_v4 TEXT;

    DECLARE v_hb_other_tobacco_consumed_1 VARCHAR(32);
    DECLARE v_hb_other_tobacco_consumed_2 VARCHAR(32);
    DECLARE v_hb_other_tobacco_consumed_3 VARCHAR(32);
    DECLARE v_hb_other_tobacco_consumed_4 VARCHAR(32);
    DECLARE v_hb_other_tobacco_consumed_5 VARCHAR(32);
    DECLARE v_hb_other_tobacco_consumed_6 VARCHAR(32);
    DECLARE v_hb_other_tobacco_consumed_7 VARCHAR(32);

    SELECT IF(pa_v4.fu_tob_oth_stutrt_f3___1 = 1, CONCAT_WS(',', pa_v4.fu_tob_oth_stutrt_f3___1_label, ' '), ''),
           IF(pa_v4.fu_tob_oth_stutrt_f3___2 = 1, CONCAT_WS(',', pa_v4.fu_tob_oth_stutrt_f3___2_label, ' '), ''),
           IF(pa_v4.fu_tob_oth_stutrt_f3___3 = 1, CONCAT_WS(',', pa_v4.fu_tob_oth_stutrt_f3___3_label, ' '), ''),
           IF(pa_v4.fu_tob_oth_stutrt_f3___4 = 1, CONCAT_WS(',', pa_v4.fu_tob_oth_stutrt_f3___4_label, ' '), ''),
           IF(pa_v4.fu_tob_oth_stutrt_f3___5 = 1, CONCAT_WS(',', pa_v4.fu_tob_oth_stutrt_f3___5_label, ' '), ''),
           IF(pa_v4.fu_tob_oth_stutrt_f3___6 = 1, CONCAT_WS(',', pa_v4.fu_tob_oth_stutrt_f3___6_label, ' '), ''),
           IF(pa_v4.fu_tob_oth_stutrt_f3___7 = 1, pa_v4.fu_other_tbc_use_f3, '')
    INTO v_hb_other_tobacco_consumed_1,
        v_hb_other_tobacco_consumed_2,
        v_hb_other_tobacco_consumed_3,
        v_hb_other_tobacco_consumed_4,
        v_hb_other_tobacco_consumed_5,
        v_hb_other_tobacco_consumed_6,
        v_hb_other_tobacco_consumed_7
    FROM wrafu_pregnancy_assessments_3 pa_v4
    WHERE CAST(pa_v4.record_id as UNSIGNED) = p_record_id;

    SET v_hb_other_tobacco_consumed_v4 = CONCAT(
            v_hb_other_tobacco_consumed_1,
            v_hb_other_tobacco_consumed_2,
            v_hb_other_tobacco_consumed_3,
            v_hb_other_tobacco_consumed_4,
            v_hb_other_tobacco_consumed_5,
            v_hb_other_tobacco_consumed_6,
            v_hb_other_tobacco_consumed_7);
    SET v_hb_other_tobacco_consumed_v4 = TRIM(',' FROM v_hb_other_tobacco_consumed_v4);

    RETURN v_hb_other_tobacco_consumed_v4;
END $$
DELIMITER ;