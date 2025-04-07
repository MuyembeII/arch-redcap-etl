/**
 * Load FU-5 WRA ZAPPS-Co-Enrollment.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 07.04.25
 * @since 0.0.1
 * @alias WRA ZAPPS-Co-Enrollment FU-5 Visit Details
 */
DROP PROCEDURE IF EXISTS `Load_WRA_ZAPPS_Co_Enrollment_Overview_V6`;

DELIMITER $$
CREATE PROCEDURE arch_etl_db.Load_WRA_ZAPPS_Co_Enrollment_Overview_V6()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load FU-5 WRA ZAPPS-Co-Enrollment Overview;', @errno, '(',
                              @sqlstate, '):',
                              @text);
            SELECT @full_error;
            RESIGNAL;
        END;
    -- Op matrices
    SET @v_tx_pre_zce_v6 := 0; -- Initial count
    SET @vv_tx_pro_zce_v6 := 0; -- After count

    START TRANSACTION;
    SET @v_tx_pre_zce_v6 = (SELECT COUNT(wra_v6.root_id)
                            FROM arch_etl_db.wra_follow_up_visit_5_repeating_instruments wra_v6
                            WHERE wra_v6.loc_fu_num1_corr_f5 IN (0, 1, 2, 3, 4));

    TRUNCATE arch_etl_db.crt_wra_visit_6_zapps_co_enrollment_overview;
    INSERT INTO arch_etl_db.crt_wra_visit_6_zapps_co_enrollment_overview(record_id,
                                                                         alternate_id,
                                                                         wra_ptid,
                                                                         member_id,
                                                                         screening_id,
                                                                         age,
                                                                         ra,
                                                                         visit_number,
                                                                         visit_name,
                                                                         visit_date)
    SELECT v6.record_id,
           v6.alternate_id,
           v6.wra_ptid,
           v6.member_id,
           v6.screening_id,
           v6.age,
           v6.ra,
           v6.visit_number,
           v6.visit_name,
           v6.visit_date
    FROM arch_etl_db.crt_wra_visit_6_overview v6
             LEFT JOIN arch_etl_db.vw_wra_consent_overview ic
                       ON (v6.record_id = ic.record_id AND v6.visit_number = ic.visit_number)
    WHERE v6.visit_outcome = 'Completed'
      AND ic.ongoing_consent_outcome = 'Accepted'
    ORDER BY v6.visit_date, v6.screening_id DESC;

    UPDATE arch_etl_db.crt_wra_visit_6_zapps_co_enrollment_overview zce
        LEFT JOIN arch_etl_db.wra_follow_up_visit_5_repeating_instruments wra_v6 ON zce.record_id = wra_v6.record_id
    SET zce.is_wra_enrolled_in_zapps     = wra_v6.loc_fu_enrolled_zapps_f5_label,
        zce.zapps_ptid                   = wra_v6.loc_fu_zapps_ptid_f5,
        zce.zapps_ptid_source            = wra_v6.loc_fu_zapps_ptid_src_f5_label,
        zce.is_wra_enrolled_in_famli_dxa = wra_v6.fu_famliid_yn_f5_label,
        zce.famli_dxa_ptid               = wra_v6.fu_famli_id_scorres_f5,
        zce.famli_dxa_id_source          = wra_v6.loc_fu_famli_id_src_f5_label
    WHERE wra_v6.wra_follow_up_visit_5_repeating_instruments_id = zce.alternate_id;
    COMMIT;

    -- Process Metrics
    SET @vv_tx_pro_zce_v6 =
            (SELECT COUNT(zce_v6.record_id) FROM arch_etl_db.crt_wra_visit_6_zapps_co_enrollment_overview zce_v6);
    SET @v_load_metrics = CONCAT_WS(' of ', @vv_tx_pro_zce_v6, @v_tx_pre_zce_v6);
    SET @v_load_info = CONCAT('WRA-ZAPPS-CO_ENROLLMENT-V6-Data: LOADING COMPLETE. ', @v_load_metrics);
    SELECT @v_load_info as `|_________________| Operation_Summary |_________________|`;

END $$

DELIMITER ;
