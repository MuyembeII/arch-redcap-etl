/**
 * Returns WRAs current HH screening ID
 *
 * @author Gift Jr <muyembegift@gmail.com> | 22.08.24
 * @since 0.0.1
 * @alias Get WRA HH SID.
 * @param varchar Record ID
 * @return HH SID
 */
DROP FUNCTION IF EXISTS `get_WRA_HH_Screening_ID`;
DELIMITER $$
CREATE FUNCTION get_WRA_HH_Screening_ID(p_record_id BIGINT)
    RETURNS VARCHAR(14)
    NOT DETERMINISTIC
BEGIN
    DECLARE v_hh_screening_id VARCHAR(14);

    -- Get HH SID Visit 6.0
    SELECT v6.fu_loc_same_hh_lv_f5,
           CONCAT_WS('-', v6.wra_fu_cluster_new_f5_label, v6.wra_fu_sbn_new_f5_label, v6.wra_fu_hun_new_f5_label,
                     v6.wra_fu_hhn_new_f5_label)
    INTO @v_v6_same_hh, @v_v6_new_hh
    FROM wra_follow_up_visit_5_repeating_instruments v6
    WHERE v6.record_id = p_record_id
      AND v6.wra_fu_pp_avail_f5 = 1;

    -- Get HH SID Visit 5.0
    SELECT v5.fu_loc_same_hh_lv_f4,
           CONCAT_WS('-', v5.wra_fu_cluster_new_f4_label, v5.wra_fu_sbn_new_f4_label, v5.wra_fu_hun_new_f4_label,
                     v5.wra_fu_hhn_new_f4_label)
    INTO @v_v5_same_hh, @v_v5_new_hh
    FROM wra_follow_up_visit_4_repeating_instruments v5
    WHERE v5.record_id = p_record_id
      AND v5.wra_fu_pp_avail_f4 = 1;

    -- Get HH SID Visit 4.0
    SELECT v4.fu_loc_same_hh_lv_f3,
           CONCAT_WS('-', v4.wra_fu_cluster_prev_f3_label, v4.wra_fu_sbn_prev_f3_label, v4.wra_fu_hun_prev_f3_label,
                     v4.wra_fu_hhn_prev_f3_label)
    INTO @v_v4_same_hh, @v_v4_new_hh
    FROM wra_follow_up_visit_3_repeating_instruments v4
    WHERE v4.record_id = p_record_id
      AND v4.wra_fu_pp_avail_f3 = 1;

    -- Get HH SID Visit 3.0
    SELECT v3.fu_loc_same_hh_lv_f2,
           CONCAT_WS('-', v3.wra_fu_cluster_new_label, v3.wra_fu_sbn_new_label, v3.wra_fu_hun_new_label,
                     v3.wra_fu_hhn_new_label)
    INTO @v_v3_same_hh, @v_v3_new_hh
    FROM wra_follow_up_visit_2_repeating_instruments v3
    WHERE v3.record_id = p_record_id
      AND v3.wra_enr_pp_avail_f2 = 1;

    -- Get HH SID Visit 2.0
    SELECT v2.fu_loc_same_hh_lv,
           CONCAT_WS('-', v2.wra_fu_cluster_prev_label, v2.wra_fu_sbn_prev_label, v2.wra_fu_hun_prev_label,
                     v2.wra_fu_hhn_prev_label)
    INTO @v_v2_same_hh, @v_v2_new_hh
    FROM wra_follow_up_visit_repeating_instruments v2
    WHERE v2.record_id = p_record_id
      AND v2.wra_fu_pp_avail = 1;

    -- Get HH SID Visit 1.0
    SELECT v1.hh_scrn_num_obsloc
    INTO @v_v1_hh
    FROM wra_forms_repeating_instruments v1
    WHERE v1.record_id = p_record_id
      AND v1.wra_enr_pp_avail = 1;

    -- Start with last visit
    IF @v_v6_same_hh = 0 THEN
        SET v_hh_screening_id = @v_v6_new_hh;
    ELSEIF @v_v5_same_hh = 0 THEN
        SET v_hh_screening_id = @v_v5_new_hh;
    ELSEIF @v_v4_same_hh = 0 THEN
        SET v_hh_screening_id = @v_v4_new_hh;
    ELSEIF @v_v3_same_hh = 0 THEN
        SET v_hh_screening_id = @v_v3_new_hh;
    ELSEIF @v_v2_same_hh = 0 THEN
        SET v_hh_screening_id = @v_v2_new_hh;
    ELSE
        SET v_hh_screening_id = @v_v1_hh;
    END IF;

    -- Latest HH Screening ID
    RETURN v_hh_screening_id;
END $$

DELIMITER ;
