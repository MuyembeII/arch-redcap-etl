/**
 * Load FU-2 WRA ZAPPS-Co-Enrollment.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 07.04.25
 * @since 0.0.1
 * @alias WRA ZAPPS-Co-Enrollment FU-2 Visit Details
 */
DROP PROCEDURE IF EXISTS `Load_WRA_ZAPPS_Co_Enrollment_Overview_V3`;

DELIMITER $$
CREATE PROCEDURE arch_etl_db.Load_WRA_ZAPPS_Co_Enrollment_Overview_V3()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load FU-2 WRA ZAPPS-Co-Enrollment Overview;', @errno, '(',
                              @sqlstate, '):',
                              @text);
            SELECT @full_error;
            RESIGNAL;
        END;
    -- Op matrices
    SET @v_tx_pre_zce_v3 := 0; -- Initial count
    SET @vv_tx_pro_zce_v3 := 0; -- After count

    START TRANSACTION;
    SET @v_tx_pre_zce_v3 = (SELECT COUNT(wra_v3.root_id)
                            FROM arch_etl_db.wra_follow_up_visit_2_repeating_instruments wra_v3
                            WHERE wra_v3.loc_fu_num1_corr_f2 IN (0, 1, 2, 3, 4));

    TRUNCATE arch_etl_db.crt_wra_visit_3_zapps_co_enrollment_overview;
    INSERT INTO arch_etl_db.crt_wra_visit_3_zapps_co_enrollment_overview(record_id,
                                                             alternate_id,
                                                             wra_ptid,
                                                             member_id,
                                                             screening_id,
                                                             age,
                                                             ra,
                                                             visit_number,
                                                             visit_name,
                                                             visit_date)
    SELECT v3.record_id,
           v3.alternate_id,
           v3.wra_ptid,
           v3.member_id,
           v3.screening_id,
           v3.age,
           v3.ra,
           v3.visit_number,
           v3.visit_name,
           v3.visit_date
    FROM arch_etl_db.crt_wra_visit_3_overview v3
             LEFT JOIN arch_etl_db.vw_wra_consent_overview ic
                       ON (v3.record_id = ic.record_id AND v3.visit_number = ic.visit_number)
    WHERE v3.visit_outcome = 'Completed'
      AND ic.ongoing_consent_outcome = 'Accepted'
    ORDER BY v3.visit_date, v3.screening_id DESC;

    UPDATE arch_etl_db.crt_wra_visit_3_zapps_co_enrollment_overview zce
        LEFT JOIN arch_etl_db.wra_follow_up_visit_2_repeating_instruments wra_v3 ON zce.record_id = wra_v3.record_id
    SET zce.is_wra_enrolled_in_zapps     = wra_v3.loc_fu_enrolled_zapps_f2_label,
        zce.zapps_ptid                   = wra_v3.loc_fu_zapps_ptid_f2,
        zce.zapps_ptid_source            = wra_v3.loc_fu_zapps_ptid_src_f2_label,
        zce.is_wra_enrolled_in_famli_dxa = wra_v3.fu_famliid_yn_f2_label,
        zce.famli_dxa_ptid               = wra_v3.fu_famli_id_scorres_f2,
        zce.famli_dxa_id_source          = wra_v3.loc_fu_famli_id_src_f2_label
    WHERE wra_v3.wra_follow_up_visit_2_repeating_instruments_id = zce.alternate_id;
    COMMIT;

    -- Process Metrics
    SET @vv_tx_pro_zce_v3 = (SELECT COUNT(zce_v3.record_id) FROM arch_etl_db.crt_wra_visit_3_zapps_co_enrollment_overview zce_v3);
    SET @v_load_metrics = CONCAT_WS(' of ', @vv_tx_pro_zce_v3, @v_tx_pre_zce_v3);
    SET @v_load_info = CONCAT('WRA-ZAPPS-CO_ENROLLMENT-V3-Data: LOADING COMPLETE. ', @v_load_metrics);
    SELECT @v_load_info as `|_________________| Operation_Summary |_________________|`;

END $$

DELIMITER ;
