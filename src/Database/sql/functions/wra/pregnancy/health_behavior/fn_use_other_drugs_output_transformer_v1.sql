/**
 * Get Baseline transformed Other-Drugs consumed output of WRA Health Behaviors in Pregnancy
 *
 * @author Gift Jr <muyembegift@gmail.com> | 23.04.25
 * @since 0.0.1
 * @alias Other-Tobacco | use_OtherTobaccoConsumedTransformer_V1 .
 * @param BIGINT | Record ID
 * @return TEXT | formatted-text
 */
DROP FUNCTION IF EXISTS `useOtherDrugsConsumedTransformer_V1`;
DELIMITER $$
CREATE FUNCTION useOtherDrugsConsumedTransformer_V1(p_record_id BIGINT)
    RETURNS TINYTEXT
    DETERMINISTIC
BEGIN
    DECLARE v_hb_other_drugs_consumed_v1 TEXT;

    DECLARE v_hb_other_drugs_consumed_1 VARCHAR(32);
    DECLARE v_hb_other_drugs_consumed_2 VARCHAR(32);
    DECLARE v_hb_other_drugs_consumed_3 VARCHAR(32);
    DECLARE v_hb_other_drugs_consumed_4 VARCHAR(32);
    DECLARE v_hb_other_drugs_consumed_5 VARCHAR(32);
    DECLARE v_hb_other_drugs_consumed_6 VARCHAR(32);
    DECLARE v_hb_other_drugs_consumed_7 VARCHAR(32);

    SELECT IF(pa_v1.np_drug_sutrt___1 = 1, pa_v1.np_drug_sutrt___1_label, ''),
           IF(pa_v1.np_drug_sutrt___2 = 1, pa_v1.np_drug_sutrt___2_label, ''),
           IF(pa_v1.np_drug_sutrt___3 = 1, pa_v1.np_drug_sutrt___3_label, ''),
           IF(pa_v1.np_drug_sutrt___4 = 1, pa_v1.np_drug_sutrt___4_label, ''),
           IF(pa_v1.np_drug_sutrt___5 = 1, pa_v1.np_drug_sutrt___5_label, ''),
           IF(pa_v1.np_drug_sutrt___6 = 1, pa_v1.np_drug_sutrt___6_label, ''),
           IF(pa_v1.np_drug_sutrt___7 = 1, pa_v1.np_drug_sutrt_othr, '')
    INTO v_hb_other_drugs_consumed_1,
        v_hb_other_drugs_consumed_2,
        v_hb_other_drugs_consumed_3,
        v_hb_other_drugs_consumed_4,
        v_hb_other_drugs_consumed_5,
        v_hb_other_drugs_consumed_6,
        v_hb_other_drugs_consumed_7
    FROM wra_pregnancy_assessments pa_v1
    WHERE CAST(pa_v1.record_id as UNSIGNED) = p_record_id;

    SET @v_other_drugs_consumed_v1 = CONCAT_WS(
            ',',
            v_hb_other_drugs_consumed_1,
            v_hb_other_drugs_consumed_2,
            v_hb_other_drugs_consumed_3,
            v_hb_other_drugs_consumed_4,
            v_hb_other_drugs_consumed_5,
            v_hb_other_drugs_consumed_6,
            v_hb_other_drugs_consumed_7);
    SET @v_other_drugs_consumed_v1 = TRIM(',' FROM @v_other_drugs_consumed_v1);
    SET v_hb_other_drugs_consumed_v1 = REGEXP_REPLACE(@v_other_drugs_consumed_v1, ',', CONCAT(',', SPACE(1)));
    RETURN v_hb_other_drugs_consumed_v1;
END $$
DELIMITER ;