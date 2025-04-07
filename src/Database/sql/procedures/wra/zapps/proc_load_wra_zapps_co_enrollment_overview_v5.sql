/**
 * Load FU-4 WRA ZAPPS-Co-Enrollment.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 07.04.25
 * @since 0.0.1
 * @alias WRA ZAPPS-Co-Enrollment FU-4 Visit Details
 */
DROP PROCEDURE IF EXISTS `Load_WRA_ZAPPS_Co_Enrollment_Overview_V5`;

DELIMITER $$
CREATE PROCEDURE arch_etl_db.Load_WRA_ZAPPS_Co_Enrollment_Overview_V5()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load FU-4 WRA ZAPPS-Co-Enrollment Overview;', @errno, '(',
                              @sqlstate, '):',
                              @text);
            SELECT @full_error;
            RESIGNAL;
        END;
    -- Op matrices
    SET @v_tx_pre_zce_v5 := 0; -- Initial count
    SET @vv_tx_pro_zce_v5 := 0; -- After count

    START TRANSACTION;
    SET @v_tx_pre_zce_v5 = (SELECT COUNT(wra_v5.root_id)
                            FROM arch_etl_db.wra_follow_up_visit_4_repeating_instruments wra_v5
                            WHERE wra_v5.loc_fu_num1_corr_f4 IN (0, 1, 2, 3, 4));

    TRUNCATE arch_etl_db.crt_wra_visit_5_zapps_co_enrollment_overview;
    INSERT INTO arch_etl_db.crt_wra_visit_5_zapps_co_enrollment_overview(record_id,
                                                                         alternate_id,
                                                                         wra_ptid,
                                                                         member_id,
                                                                         screening_id,
                                                                         age,
                                                                         ra,
                                                                         visit_number,
                                                                         visit_name,
                                                                         visit_date)
    SELECT v5.record_id,
           v5.alternate_id,
           v5.wra_ptid,
           v5.member_id,
           v5.screening_id,
           v5.age,
           v5.ra,
           v5.visit_number,
           v5.visit_name,
           v5.visit_date
    FROM arch_etl_db.crt_wra_visit_5_overview v5
             LEFT JOIN arch_etl_db.vw_wra_consent_overview ic
                       ON (v5.record_id = ic.record_id AND v5.visit_number = ic.visit_number)
    WHERE v5.visit_outcome = 'Completed'
      AND ic.ongoing_consent_outcome = 'Accepted'
    ORDER BY v5.visit_date, v5.screening_id DESC;

    UPDATE arch_etl_db.crt_wra_visit_5_zapps_co_enrollment_overview zce
        LEFT JOIN arch_etl_db.wra_follow_up_visit_4_repeating_instruments wra_v5 ON zce.record_id = wra_v5.record_id
    SET zce.is_wra_enrolled_in_zapps     = wra_v5.loc_fu_enrolled_zapps_f4_label,
        zce.zapps_ptid                   = wra_v5.loc_fu_zapps_ptid_f4,
        zce.zapps_ptid_source            = wra_v5.loc_fu_zapps_ptid_src_f4_label,
        zce.is_wra_enrolled_in_famli_dxa = wra_v5.fu_famliid_yn_f4_label,
        zce.famli_dxa_ptid               = wra_v5.fu_famli_id_scorres_f4,
        zce.famli_dxa_id_source          = wra_v5.loc_fu_famli_id_src_f4_label
    WHERE wra_v5.wra_follow_up_visit_4_repeating_instruments_id = zce.alternate_id;
    COMMIT;

    -- Process Metrics
    SET @vv_tx_pro_zce_v5 =
            (SELECT COUNT(zce_v5.record_id) FROM arch_etl_db.crt_wra_visit_5_zapps_co_enrollment_overview zce_v5);
    SET @v_load_metrics = CONCAT_WS(' of ', @vv_tx_pro_zce_v5, @v_tx_pre_zce_v5);
    SET @v_load_info = CONCAT('WRA-ZAPPS-CO_ENROLLMENT-V5-Data: LOADING COMPLETE. ', @v_load_metrics);
    SELECT @v_load_info as `|_________________| Operation_Summary |_________________|`;

END $$

DELIMITER ;
