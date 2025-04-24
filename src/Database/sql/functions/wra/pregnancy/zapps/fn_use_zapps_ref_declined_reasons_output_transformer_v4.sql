/**
 * Get FU-3 transformed ZAPPS Referral declined reasons output
 *
 * @author Gift Jr <muyembegift@gmail.com> | 24.04.25
 * @since 0.0.1
 * @alias ZAPPS-Referral Reasons Declined | use_ZAPPS_RefDeclinedReasonsTransformer_V4
 * @param BIGINT | Record ID
 * @return TEXT | formatted-text
 */
DROP FUNCTION IF EXISTS `use_ZAPPS_RefDeclinedReasonsTransformer_V4`;
DELIMITER $$
CREATE FUNCTION use_ZAPPS_RefDeclinedReasonsTransformer_V4(p_record_id BIGINT)
    RETURNS TINYTEXT
    DETERMINISTIC
BEGIN
    DECLARE v_zapps_ref_declined_reasons_v4 TEXT;

    DECLARE v_zapps_ref_declined_reasons_1 VARCHAR(32);
    DECLARE v_zapps_ref_declined_reasons_2 VARCHAR(32);
    DECLARE v_zapps_ref_declined_reasons_3 VARCHAR(32);
    DECLARE v_zapps_ref_declined_reasons_4 VARCHAR(32);
    DECLARE v_zapps_ref_declined_reasons_5 VARCHAR(32);
    DECLARE v_zapps_ref_declined_reasons_6 VARCHAR(32);

    SELECT IF(pa_v4.fu_ref_res_decline_f3___1 = 1, CONCAT_WS(',', pa_v4.fu_ref_res_decline_f3___1_label, ' '), ''),
           IF(pa_v4.fu_ref_res_decline_f3___2 = 1, CONCAT_WS(',', pa_v4.fu_ref_res_decline_f3___2_label, ' '), ''),
           IF(pa_v4.fu_ref_res_decline_f3___3 = 1, CONCAT_WS(',', pa_v4.fu_ref_res_decline_f3___3_label, ' '), ''),
           IF(pa_v4.fu_ref_res_decline_f3___4 = 1, CONCAT_WS(',', pa_v4.fu_ref_res_decline_f3___4_label, ' '), ''),
           IF(pa_v4.fu_ref_res_decline_f3___5 = 1, CONCAT_WS(',', pa_v4.fu_ref_res_decline_f3___5_label, ' '), ''),
           IF(pa_v4.fu_ref_res_decline_f3___6 = 1, pa_v4.zr_fu_reas_other_f3, '')
    INTO v_zapps_ref_declined_reasons_1,
        v_zapps_ref_declined_reasons_2,
        v_zapps_ref_declined_reasons_3,
        v_zapps_ref_declined_reasons_4,
        v_zapps_ref_declined_reasons_5,
        v_zapps_ref_declined_reasons_6
    FROM wrafu_pregnancy_assessments_3 pa_v4
    WHERE CAST(pa_v4.record_id as UNSIGNED) = p_record_id;

    SET v_zapps_ref_declined_reasons_v4 = CONCAT(
            v_zapps_ref_declined_reasons_1,
            v_zapps_ref_declined_reasons_2,
            v_zapps_ref_declined_reasons_3,
            v_zapps_ref_declined_reasons_4,
            v_zapps_ref_declined_reasons_5,
            v_zapps_ref_declined_reasons_6);
    SET v_zapps_ref_declined_reasons_v4 = TRIM(',' FROM v_zapps_ref_declined_reasons_v4);

    RETURN v_zapps_ref_declined_reasons_v4;
END $$
DELIMITER ;