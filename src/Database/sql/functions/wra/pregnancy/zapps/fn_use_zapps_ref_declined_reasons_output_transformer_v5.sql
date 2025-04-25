/**
 * Get FU-4 transformed ZAPPS Referral declined reasons output
 *
 * @author Gift Jr <muyembegift@gmail.com> | 24.04.25
 * @since 0.0.1
 * @alias ZAPPS-Referral Reasons Declined | use_ZAPPS_RefDeclinedReasonsTransformer_V5
 * @param BIGINT | Record ID
 * @return TEXT | formatted-text
 */
DROP FUNCTION IF EXISTS `use_ZAPPS_RefDeclinedReasonsTransformer_V5`;
DELIMITER $$
CREATE FUNCTION use_ZAPPS_RefDeclinedReasonsTransformer_V5(p_record_id BIGINT)
    RETURNS MEDIUMTEXT
    DETERMINISTIC
BEGIN
    DECLARE v_zapps_ref_declined_reasons_v5 TEXT;

    DECLARE v_zapps_ref_declined_reasons_1 VARCHAR(32);
    DECLARE v_zapps_ref_declined_reasons_2 VARCHAR(32);
    DECLARE v_zapps_ref_declined_reasons_3 VARCHAR(32);
    DECLARE v_zapps_ref_declined_reasons_4 VARCHAR(32);
    DECLARE v_zapps_ref_declined_reasons_5 VARCHAR(32);
    DECLARE v_zapps_ref_declined_reasons_6 VARCHAR(32);

    SELECT IF(pa_v5.fu_ref_res_decline_f4___1 = 1, pa_v5.fu_ref_res_decline_f4___1_label, ''),
           IF(pa_v5.fu_ref_res_decline_f4___2 = 1, pa_v5.fu_ref_res_decline_f4___2_label, ''),
           IF(pa_v5.fu_ref_res_decline_f4___3 = 1, pa_v5.fu_ref_res_decline_f4___3_label, ''),
           IF(pa_v5.fu_ref_res_decline_f4___4 = 1, pa_v5.fu_ref_res_decline_f4___4_label, ''),
           IF(pa_v5.fu_ref_res_decline_f4___5 = 1, pa_v5.fu_ref_res_decline_f4___5_label, ''),
           IF(pa_v5.fu_ref_res_decline_f4___6 = 1, pa_v5.zr_fu_reas_other_f4, '')
    INTO v_zapps_ref_declined_reasons_1,
        v_zapps_ref_declined_reasons_2,
        v_zapps_ref_declined_reasons_3,
        v_zapps_ref_declined_reasons_4,
        v_zapps_ref_declined_reasons_5,
        v_zapps_ref_declined_reasons_6
    FROM wrafu_pregnancy_assessments_4 pa_v5
    WHERE CAST(pa_v5.record_id as UNSIGNED) = p_record_id;

    SET @v_ref_declined_reasons_v5 = CONCAT_WS(',',
                                               v_zapps_ref_declined_reasons_1,
                                               v_zapps_ref_declined_reasons_2,
                                               v_zapps_ref_declined_reasons_3,
                                               v_zapps_ref_declined_reasons_4,
                                               v_zapps_ref_declined_reasons_5,
                                               v_zapps_ref_declined_reasons_6);
    SET @v_ref_declined_reasons_v5 = TRIM(',' FROM @v_ref_declined_reasons_v5);
    SET v_zapps_ref_declined_reasons_v5 = REGEXP_REPLACE(@v_ref_declined_reasons_v5, ',', CONCAT(',', SPACE(1)));
    RETURN v_zapps_ref_declined_reasons_v5;
END $$
DELIMITER ;