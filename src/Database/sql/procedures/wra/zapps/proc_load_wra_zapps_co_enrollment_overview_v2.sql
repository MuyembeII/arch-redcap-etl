/**
 * Load FU-1 WRA ZAPPS-Co-Enrollment.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 07.04.25
 * @since 0.0.1
 * @alias WRA ZAPPS-Co-Enrollment FU-1 Visit Details
 */
DROP PROCEDURE IF EXISTS `Load_WRA_ZAPPS_Co_Enrollment_Overview_V2`;

DELIMITER $$
CREATE PROCEDURE arch_etl_db.Load_WRA_ZAPPS_Co_Enrollment_Overview_V2()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load FU-1 WRA ZAPPS-Co-Enrollment Overview;', @errno, '(',
                              @sqlstate, '):',
                              @text);
            SELECT @full_error;
            RESIGNAL;
        END;
    -- Op matrices
    SET @v_tx_pre_zce_v2 := 0; -- Initial count
    SET @vv_tx_pro_zce_v2 := 0; -- After count

    START TRANSACTION;
    SET @v_tx_pre_zce_v2 = (SELECT COUNT(wra_v2.root_id)
                            FROM arch_etl_db.wra_follow_up_visit_repeating_instruments wra_v2
                            WHERE wra_v2.loc_fu_num1_corr IN (0, 1, 2, 3, 4));

    TRUNCATE arch_etl_db.crt_wra_visit_2_zapps_co_enrollment_overview;
    INSERT INTO arch_etl_db.crt_wra_visit_2_zapps_co_enrollment_overview(record_id,
                                                             alternate_id,
                                                             wra_ptid,
                                                             member_id,
                                                             screening_id,
                                                             age,
                                                             ra,
                                                             visit_number,
                                                             visit_name,
                                                             visit_date)
    SELECT v2.record_id,
           v2.alternate_id,
           v2.wra_ptid,
           v2.member_id,
           v2.screening_id,
           v2.age,
           v2.ra,
           v2.visit_number,
           v2.visit_name,
           v2.visit_date
    FROM arch_etl_db.crt_wra_visit_2_overview v2
             LEFT JOIN arch_etl_db.vw_wra_consent_overview ic
                       ON (v2.record_id = ic.record_id AND v2.visit_number = ic.visit_number)
    WHERE v2.visit_outcome = 'Completed'
      AND ic.ongoing_consent_outcome = 'Accepted'
    ORDER BY v2.visit_date, v2.screening_id DESC;

    UPDATE arch_etl_db.crt_wra_visit_2_zapps_co_enrollment_overview zce
        LEFT JOIN arch_etl_db.wra_follow_up_visit_repeating_instruments wra_v2 ON zce.record_id = wra_v2.record_id
    SET zce.is_wra_enrolled_in_zapps     = wra_v2.loc_fu_enrolled_zapps_label,
        zce.zapps_ptid                   = wra_v2.loc_fu_zapps_ptid,
        zce.zapps_ptid_source            = wra_v2.loc_fu_zapps_ptid_src_label,
        zce.is_wra_enrolled_in_famli_dxa = wra_v2.fu_famliid_yn_label,
        zce.famli_dxa_ptid               = wra_v2.fu_famli_id_scorres,
        zce.famli_dxa_id_source          = wra_v2.loc_fu_famli_id_src_label
    WHERE wra_v2.wra_follow_up_visit_repeating_instruments_id = zce.alternate_id;
    COMMIT;

    -- Process Metrics
    SET @vv_tx_pro_zce_v2 = (SELECT COUNT(zce_v2.record_id) FROM arch_etl_db.crt_wra_visit_2_zapps_co_enrollment_overview zce_v2);
    SET @v_load_metrics = CONCAT_WS(' of ', @vv_tx_pro_zce_v2, @v_tx_pre_zce_v2);
    SET @v_load_info = CONCAT('WRA-ZAPPS-CO_ENROLLMENT-V2-Data: LOADING COMPLETE. ', @v_load_metrics);
    SELECT @v_load_info as `|_________________| Operation_Summary |_________________|`;

END $$

DELIMITER ;
