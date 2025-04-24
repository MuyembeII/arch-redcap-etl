/**
 * Get FU-5 transformed ZAPPS Referral declined reasons output
 *
 * @author Gift Jr <muyembegift@gmail.com> | 24.04.25
 * @since 0.0.1
 * @alias ZAPPS-Referral Reasons Declined | use_ZAPPS_RefDeclinedReasonsTransformer_V6
 * @param BIGINT | Record ID
 * @return TEXT | formatted-text
 */
DROP FUNCTION IF EXISTS `use_ZAPPS_RefDeclinedReasonsTransformer_V6`;
DELIMITER $$
CREATE FUNCTION use_ZAPPS_RefDeclinedReasonsTransformer_V6(p_record_id BIGINT)
    RETURNS TINYTEXT
    DETERMINISTIC
BEGIN
    DECLARE v_zapps_ref_declined_reasons_v6 TEXT;

    DECLARE v_zapps_ref_declined_reasons_1 VARCHAR(32);
    DECLARE v_zapps_ref_declined_reasons_2 VARCHAR(32);
    DECLARE v_zapps_ref_declined_reasons_3 VARCHAR(32);
    DECLARE v_zapps_ref_declined_reasons_4 VARCHAR(32);
    DECLARE v_zapps_ref_declined_reasons_5 VARCHAR(32);
    DECLARE v_zapps_ref_declined_reasons_6 VARCHAR(32);

    SELECT IF(pa_v6.fu_ref_res_decline_f5___1 = 1, CONCAT_WS(',', pa_v6.fu_ref_res_decline_f5___1_label, ' '), ''),
           IF(pa_v6.fu_ref_res_decline_f5___2 = 1, CONCAT_WS(',', pa_v6.fu_ref_res_decline_f5___2_label, ' '), ''),
           IF(pa_v6.fu_ref_res_decline_f5___3 = 1, CONCAT_WS(',', pa_v6.fu_ref_res_decline_f5___3_label, ' '), ''),
           IF(pa_v6.fu_ref_res_decline_f5___4 = 1, CONCAT_WS(',', pa_v6.fu_ref_res_decline_f5___4_label, ' '), ''),
           IF(pa_v6.fu_ref_res_decline_f5___5 = 1, CONCAT_WS(',', pa_v6.fu_ref_res_decline_f5___5_label, ' '), ''),
           IF(pa_v6.fu_ref_res_decline_f5___6 = 1, pa_v6.zr_fu_reas_other_f5, '')
    INTO v_zapps_ref_declined_reasons_1,
        v_zapps_ref_declined_reasons_2,
        v_zapps_ref_declined_reasons_3,
        v_zapps_ref_declined_reasons_4,
        v_zapps_ref_declined_reasons_5,
        v_zapps_ref_declined_reasons_6
    FROM wrafu_pregnancy_assessments_5 pa_v6
    WHERE CAST(pa_v6.record_id as UNSIGNED) = p_record_id;

    SET v_zapps_ref_declined_reasons_v6 = CONCAT(
            v_zapps_ref_declined_reasons_1,
            v_zapps_ref_declined_reasons_2,
            v_zapps_ref_declined_reasons_3,
            v_zapps_ref_declined_reasons_4,
            v_zapps_ref_declined_reasons_5,
            v_zapps_ref_declined_reasons_6);
    SET v_zapps_ref_declined_reasons_v6 = TRIM(',' FROM v_zapps_ref_declined_reasons_v6);

    RETURN v_zapps_ref_declined_reasons_v6;
END $$
DELIMITER ;