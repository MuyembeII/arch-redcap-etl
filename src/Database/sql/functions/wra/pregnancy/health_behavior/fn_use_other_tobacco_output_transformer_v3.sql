/**
 * Get FU-2 transformed Other-Tobacco consumed output of WRA Health Behaviors in Pregnancy
 *
 * @author Gift Jr <muyembegift@gmail.com> | 23.04.25
 * @since 0.0.1
 * @alias Other-Tobacco | use_OtherTobaccoConsumedTransformer_V3 .
 * @param BIGINT | Record ID
 * @return TEXT | formatted-text
 */
DROP FUNCTION IF EXISTS `use_OtherTobaccoConsumedTransformer_V3`;
DELIMITER $$
CREATE FUNCTION use_OtherTobaccoConsumedTransformer_V3(p_record_id BIGINT)
    RETURNS TINYTEXT
    DETERMINISTIC
BEGIN
    DECLARE v_hb_other_tobacco_consumed_v3 TEXT;
    DECLARE v_hb_other_tobacco_consumed_1 VARCHAR(32);
    DECLARE v_hb_other_tobacco_consumed_2 VARCHAR(32);
    DECLARE v_hb_other_tobacco_consumed_3 VARCHAR(32);
    DECLARE v_hb_other_tobacco_consumed_4 VARCHAR(32);
    DECLARE v_hb_other_tobacco_consumed_5 VARCHAR(32);
    DECLARE v_hb_other_tobacco_consumed_6 VARCHAR(32);
    DECLARE v_hb_other_tobacco_consumed_7 VARCHAR(32);

    SELECT IF(pa_v3.fu_tob_oth_stutrt_f2___1 = 1, pa_v3.fu_tob_oth_stutrt_f2___1_label, ''),
           IF(pa_v3.fu_tob_oth_stutrt_f2___2 = 1, pa_v3.fu_tob_oth_stutrt_f2___2_label, ''),
           IF(pa_v3.fu_tob_oth_stutrt_f2___3 = 1, pa_v3.fu_tob_oth_stutrt_f2___3_label, ''),
           IF(pa_v3.fu_tob_oth_stutrt_f2___4 = 1, pa_v3.fu_tob_oth_stutrt_f2___4_label, ''),
           IF(pa_v3.fu_tob_oth_stutrt_f2___5 = 1, pa_v3.fu_tob_oth_stutrt_f2___5_label, ''),
           IF(pa_v3.fu_tob_oth_stutrt_f2___6 = 1, pa_v3.fu_tob_oth_stutrt_f2___6_label, ''),
           IF(pa_v3.fu_tob_oth_stutrt_f2___7 = 1, pa_v3.fu_other_tbc_use_f2, '')
    INTO v_hb_other_tobacco_consumed_1,
        v_hb_other_tobacco_consumed_2,
        v_hb_other_tobacco_consumed_3,
        v_hb_other_tobacco_consumed_4,
        v_hb_other_tobacco_consumed_5,
        v_hb_other_tobacco_consumed_6,
        v_hb_other_tobacco_consumed_7
    FROM wrafu_pregnancy_assessments_2 pa_v3
    WHERE CAST(pa_v3.record_id as UNSIGNED) = p_record_id;
    -- transform activated options into immutable list
    SET @v_other_tobacco_consumed_v3 = CONCAT_WS(
            ',',
            v_hb_other_tobacco_consumed_1,
            v_hb_other_tobacco_consumed_2,
            v_hb_other_tobacco_consumed_3,
            v_hb_other_tobacco_consumed_4,
            v_hb_other_tobacco_consumed_5,
            v_hb_other_tobacco_consumed_6,
            v_hb_other_tobacco_consumed_7);
    SET @v_other_tobacco_consumed_v3 = TRIM(',' FROM TRIM(@v_other_tobacco_consumed_v3));
    SET v_hb_other_tobacco_consumed_v3 = REGEXP_REPLACE(@v_other_tobacco_consumed_v3, ',', CONCAT(',', SPACE(1)));
    RETURN v_hb_other_tobacco_consumed_v3;
END $$
DELIMITER ;