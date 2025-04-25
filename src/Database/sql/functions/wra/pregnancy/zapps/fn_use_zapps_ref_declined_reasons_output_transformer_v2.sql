/**
 * Get FU-1 transformed ZAPPS Referral declined reasons listed output
 *
 * @author Gift Jr <muyembegift@gmail.com> | 24.04.25
 * @since 0.0.1
 * @alias List of ZAPPS-Referral Reasons Declined | use_ZAPPS_RefDeclinedReasonsTransformer_V2
 * @param BIGINT | Record ID
 * @return TEXT | formatted-text
 */
DROP FUNCTION IF EXISTS `use_ZAPPS_RefDeclinedReasonsTransformer_V2`;
DELIMITER $$
CREATE FUNCTION use_ZAPPS_RefDeclinedReasonsTransformer_V2(p_record_id BIGINT)
    RETURNS MEDIUMTEXT
    DETERMINISTIC
BEGIN
    DECLARE v_zapps_ref_declined_reasons_v2 MEDIUMTEXT;

    DECLARE v_zapps_ref_declined_reasons_1 VARCHAR(32);
    DECLARE v_zapps_ref_declined_reasons_2 VARCHAR(32);
    DECLARE v_zapps_ref_declined_reasons_3 VARCHAR(32);
    DECLARE v_zapps_ref_declined_reasons_4 VARCHAR(32);
    DECLARE v_zapps_ref_declined_reasons_5 VARCHAR(32);
    DECLARE v_zapps_ref_declined_reasons_6 VARCHAR(32);

    SELECT IF(pa_v2.fu_ref_res_decline___1 = 1, pa_v2.fu_ref_res_decline___1_label, ''),
           IF(pa_v2.fu_ref_res_decline___2 = 1, pa_v2.fu_ref_res_decline___2_label, ''),
           IF(pa_v2.fu_ref_res_decline___3 = 1, pa_v2.fu_ref_res_decline___3_label, ''),
           IF(pa_v2.fu_ref_res_decline___4 = 1, pa_v2.fu_ref_res_decline___4_label, ''),
           IF(pa_v2.fu_ref_res_decline___5 = 1, pa_v2.fu_ref_res_decline___5_label, ''),
           IF(pa_v2.fu_ref_res_decline___6 = 1, pa_v2.zr_fu_reas_other, '')
    INTO v_zapps_ref_declined_reasons_1,
        v_zapps_ref_declined_reasons_2,
        v_zapps_ref_declined_reasons_3,
        v_zapps_ref_declined_reasons_4,
        v_zapps_ref_declined_reasons_5,
        v_zapps_ref_declined_reasons_6
    FROM wrafu_pregnancy_assessments pa_v2
    WHERE CAST(pa_v2.record_id as UNSIGNED) = p_record_id;

    SET @v_ref_declined_reasons_v2 = CONCAT_WS(',',
                                               v_zapps_ref_declined_reasons_1,
                                               v_zapps_ref_declined_reasons_2,
                                               v_zapps_ref_declined_reasons_3,
                                               v_zapps_ref_declined_reasons_4,
                                               v_zapps_ref_declined_reasons_5,
                                               v_zapps_ref_declined_reasons_6);
    SET @v_ref_declined_reasons_v2 = TRIM(',' FROM @v_ref_declined_reasons_v2);
    SET v_zapps_ref_declined_reasons_v2 = REGEXP_REPLACE(@v_ref_declined_reasons_v2, ',', CONCAT(',', SPACE(1)));

    RETURN v_zapps_ref_declined_reasons_v2;
END $$
DELIMITER ;