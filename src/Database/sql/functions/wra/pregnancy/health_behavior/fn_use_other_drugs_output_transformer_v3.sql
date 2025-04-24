/**
 * Get FU-2 transformed Other-Drugs consumed output of WRA Health Behaviors in Pregnancy
 *
 * @author Gift Jr <muyembegift@gmail.com> | 24.04.25
 * @since 0.0.1
 * @alias Other-Drugs | useOtherDrugsConsumedTransformer_V3 .
 * @param BIGINT | Record ID
 * @return TEXT | formatted-text
 */
DROP FUNCTION IF EXISTS `useOtherDrugsConsumedTransformer_V3`;
DELIMITER $$
CREATE FUNCTION useOtherDrugsConsumedTransformer_V3(p_record_id BIGINT)
    RETURNS TINYTEXT
    DETERMINISTIC
BEGIN
    DECLARE v_hb_other_drugs_consumed_v3 TEXT;

    DECLARE v_hb_other_drugs_consumed_1 VARCHAR(32);
    DECLARE v_hb_other_drugs_consumed_2 VARCHAR(32);
    DECLARE v_hb_other_drugs_consumed_3 VARCHAR(32);
    DECLARE v_hb_other_drugs_consumed_4 VARCHAR(32);
    DECLARE v_hb_other_drugs_consumed_5 VARCHAR(32);
    DECLARE v_hb_other_drugs_consumed_6 VARCHAR(32);
    DECLARE v_hb_other_drugs_consumed_7 VARCHAR(32);

    SELECT IF(pa_v3.np_fu_drug_sutrt_f2___1 = 1, CONCAT_WS(',', pa_v3.np_fu_drug_sutrt_f2___1_label, ' '), ''),
           IF(pa_v3.np_fu_drug_sutrt_f2___2 = 1, CONCAT_WS(',', pa_v3.np_fu_drug_sutrt_f2___2_label, ' '), ''),
           IF(pa_v3.np_fu_drug_sutrt_f2___3 = 1, CONCAT_WS(',', pa_v3.np_fu_drug_sutrt_f2___3_label, ' '), ''),
           IF(pa_v3.np_fu_drug_sutrt_f2___4 = 1, CONCAT_WS(',', pa_v3.np_fu_drug_sutrt_f2___4_label, ' '), ''),
           IF(pa_v3.np_fu_drug_sutrt_f2___5 = 1, CONCAT_WS(',', pa_v3.np_fu_drug_sutrt_f2___5_label, ' '), ''),
           IF(pa_v3.np_fu_drug_sutrt_f2___6 = 1, CONCAT_WS(',', pa_v3.np_fu_drug_sutrt_f2___6_label, ' '), ''),
           IF(pa_v3.np_fu_drug_sutrt_f2___7 = 1, pa_v3.np_fu_drug_sutrt_othr_f2, '')
    INTO v_hb_other_drugs_consumed_1,
        v_hb_other_drugs_consumed_2,
        v_hb_other_drugs_consumed_3,
        v_hb_other_drugs_consumed_4,
        v_hb_other_drugs_consumed_5,
        v_hb_other_drugs_consumed_6,
        v_hb_other_drugs_consumed_7
    FROM wrafu_pregnancy_assessments_2 pa_v3
    WHERE CAST(pa_v3.record_id as UNSIGNED) = p_record_id;

    SET v_hb_other_drugs_consumed_v3 = CONCAT(
            v_hb_other_drugs_consumed_1,
            v_hb_other_drugs_consumed_2,
            v_hb_other_drugs_consumed_3,
            v_hb_other_drugs_consumed_4,
            v_hb_other_drugs_consumed_5,
            v_hb_other_drugs_consumed_6,
            v_hb_other_drugs_consumed_7);
    SET v_hb_other_drugs_consumed_v3 = TRIM(',' FROM TRIM(v_hb_other_drugs_consumed_v3));

    RETURN v_hb_other_drugs_consumed_v3;
END $$
DELIMITER ;