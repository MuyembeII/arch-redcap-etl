/**
 * Get FU-4 transformed Other-Tobacco consumed output of WRA Health Behaviors in Pregnancy
 *
 * @author Gift Jr <muyembegift@gmail.com> | 23.04.25
 * @since 0.0.1
 * @alias Other-Tobacco | use_OtherTobaccoConsumedTransformer_V5 .
 * @param BIGINT | Record ID
 * @return TEXT | formatted-text
 */
DROP FUNCTION IF EXISTS `use_OtherTobaccoConsumedTransformer_V5`;
DELIMITER $$
CREATE FUNCTION use_OtherTobaccoConsumedTransformer_V5(p_record_id BIGINT)
    RETURNS TINYTEXT
    DETERMINISTIC
BEGIN
    DECLARE v_hb_other_tobacco_consumed_v5 TEXT;
    DECLARE v_hb_other_tobacco_consumed_1 VARCHAR(32);
    DECLARE v_hb_other_tobacco_consumed_2 VARCHAR(32);
    DECLARE v_hb_other_tobacco_consumed_3 VARCHAR(32);
    DECLARE v_hb_other_tobacco_consumed_4 VARCHAR(32);
    DECLARE v_hb_other_tobacco_consumed_5 VARCHAR(32);
    DECLARE v_hb_other_tobacco_consumed_6 VARCHAR(32);
    DECLARE v_hb_other_tobacco_consumed_7 VARCHAR(32);

    SELECT IF(pa_v5.fu_tob_oth_stutrt_f4___1 = 1, pa_v5.fu_tob_oth_stutrt_f4___1_label, ''),
           IF(pa_v5.fu_tob_oth_stutrt_f4___2 = 1, pa_v5.fu_tob_oth_stutrt_f4___2_label, ''),
           IF(pa_v5.fu_tob_oth_stutrt_f4___3 = 1, pa_v5.fu_tob_oth_stutrt_f4___3_label, ''),
           IF(pa_v5.fu_tob_oth_stutrt_f4___4 = 1, pa_v5.fu_tob_oth_stutrt_f4___4_label, ''),
           IF(pa_v5.fu_tob_oth_stutrt_f4___5 = 1, pa_v5.fu_tob_oth_stutrt_f4___5_label, ''),
           IF(pa_v5.fu_tob_oth_stutrt_f4___6 = 1, pa_v5.fu_tob_oth_stutrt_f4___6_label, ''),
           IF(pa_v5.fu_tob_oth_stutrt_f4___7 = 1, pa_v5.fu_other_tbc_use_f4, '')
    INTO v_hb_other_tobacco_consumed_1,
        v_hb_other_tobacco_consumed_2,
        v_hb_other_tobacco_consumed_3,
        v_hb_other_tobacco_consumed_4,
        v_hb_other_tobacco_consumed_5,
        v_hb_other_tobacco_consumed_6,
        v_hb_other_tobacco_consumed_7
    FROM wrafu_pregnancy_assessments_4 pa_v5
    WHERE CAST(pa_v5.record_id as UNSIGNED) = p_record_id;
    -- transform activated options into immutable list
    SET @v_other_tobacco_consumed_v5 = CONCAT_WS(
            ',',
            v_hb_other_tobacco_consumed_1,
            v_hb_other_tobacco_consumed_2,
            v_hb_other_tobacco_consumed_3,
            v_hb_other_tobacco_consumed_4,
            v_hb_other_tobacco_consumed_5,
            v_hb_other_tobacco_consumed_6,
            v_hb_other_tobacco_consumed_7);
    SET @v_other_tobacco_consumed_v5 = TRIM(',' FROM TRIM(@v_other_tobacco_consumed_v5));
    SET v_hb_other_tobacco_consumed_v5 = REGEXP_REPLACE(@v_other_tobacco_consumed_v5, ',', CONCAT(',', SPACE(1)));
    RETURN v_hb_other_tobacco_consumed_v5;
END $$
DELIMITER ;