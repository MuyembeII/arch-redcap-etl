/**
 * Get FU-5 transformed Other-Tobacco consumed output of WRA Health Behaviors in Pregnancy
 *
 * @author Gift Jr <muyembegift@gmail.com> | 23.04.25
 * @since 0.0.1
 * @alias Other-Tobacco | use_OtherTobaccoConsumedTransformer_V6 .
 * @param BIGINT | Record ID
 * @return TEXT | formatted-text
 */
DROP FUNCTION IF EXISTS `use_OtherTobaccoConsumedTransformer_V6`;
DELIMITER $$
CREATE FUNCTION use_OtherTobaccoConsumedTransformer_V6(p_record_id BIGINT)
    RETURNS TINYTEXT
    DETERMINISTIC
BEGIN
    DECLARE v_hb_other_tobacco_consumed_v6 TEXT;
    DECLARE v_hb_other_tobacco_consumed_1 VARCHAR(32);
    DECLARE v_hb_other_tobacco_consumed_2 VARCHAR(32);
    DECLARE v_hb_other_tobacco_consumed_3 VARCHAR(32);
    DECLARE v_hb_other_tobacco_consumed_4 VARCHAR(32);
    DECLARE v_hb_other_tobacco_consumed_5 VARCHAR(32);
    DECLARE v_hb_other_tobacco_consumed_6 VARCHAR(32);
    DECLARE v_hb_other_tobacco_consumed_7 VARCHAR(32);

    SELECT IF(pa_v6.fu_tob_oth_stutrt_f5___1 = 1, CONCAT_WS(',', pa_v6.fu_tob_oth_stutrt_f5___1_label, ' '), ''),
           IF(pa_v6.fu_tob_oth_stutrt_f5___2 = 1, CONCAT_WS(',', pa_v6.fu_tob_oth_stutrt_f5___2_label, ' '), ''),
           IF(pa_v6.fu_tob_oth_stutrt_f5___3 = 1, CONCAT_WS(',', pa_v6.fu_tob_oth_stutrt_f5___3_label, ' '), ''),
           IF(pa_v6.fu_tob_oth_stutrt_f5___4 = 1, CONCAT_WS(',', pa_v6.fu_tob_oth_stutrt_f5___4_label, ' '), ''),
           IF(pa_v6.fu_tob_oth_stutrt_f5___5 = 1, CONCAT_WS(',', pa_v6.fu_tob_oth_stutrt_f5___5_label, ' '), ''),
           IF(pa_v6.fu_tob_oth_stutrt_f5___6 = 1, CONCAT_WS(',', pa_v6.fu_tob_oth_stutrt_f5___6_label, ' '), ''),
           IF(pa_v6.fu_tob_oth_stutrt_f5___7 = 1, pa_v6.fu_other_tbc_use_f5, '')
    INTO v_hb_other_tobacco_consumed_1,
        v_hb_other_tobacco_consumed_2,
        v_hb_other_tobacco_consumed_3,
        v_hb_other_tobacco_consumed_4,
        v_hb_other_tobacco_consumed_5,
        v_hb_other_tobacco_consumed_6,
        v_hb_other_tobacco_consumed_7
    FROM wrafu_pregnancy_assessments_5 pa_v6
    WHERE CAST(pa_v6.record_id as UNSIGNED) = p_record_id;
    -- transform activated options into immutable list
    SET @v_other_tobacco_consumed_v6 = CONCAT_WS(
            ',',
            v_hb_other_tobacco_consumed_1,
            v_hb_other_tobacco_consumed_2,
            v_hb_other_tobacco_consumed_3,
            v_hb_other_tobacco_consumed_4,
            v_hb_other_tobacco_consumed_5,
            v_hb_other_tobacco_consumed_6,
            v_hb_other_tobacco_consumed_7);
    SET @v_other_tobacco_consumed_v6 = TRIM(',' FROM TRIM(@v_other_tobacco_consumed_v6));
    SET v_hb_other_tobacco_consumed_v6 = REGEXP_REPLACE(@v_other_tobacco_consumed_v6, ',', CONCAT(',', SPACE(1)));
    RETURN v_hb_other_tobacco_consumed_v6;
END $$
DELIMITER ;