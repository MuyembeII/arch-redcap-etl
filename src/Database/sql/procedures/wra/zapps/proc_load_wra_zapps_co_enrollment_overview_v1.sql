/**
 * Load Baseline WRA ZAPPS Co-Enrollment.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 07.04.25
 * @since 0.0.1
 * @alias WRA ZAPPS Co-Enrollment
 */
DROP PROCEDURE IF EXISTS `Load_WRA_ZAPPS_Co_Enrollment_Overview_V1`;

DELIMITER $$
CREATE PROCEDURE arch_etl_db.Load_WRA_ZAPPS_Co_Enrollment_Overview_V1()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load Baseline WRA ZAPPS Co-Enrollment;', @errno, '(',
                              @sqlstate, '):',
                              @text);
            SELECT @full_error;
            RESIGNAL;
        END;
    -- Op matrices
    SET @v_tx_pre_zce_v1 := 0; -- Initial count
    SET @vv_tx_pro_zce_v1 := 0; -- After count

    START TRANSACTION;
    SET @v_tx_pre_zce_v1 = (SELECT COUNT(wra_v1.root_id)
                            FROM arch_etl_db.wra_forms_repeating_instruments wra_v1
                            WHERE wra_v1.loc_other_contacts IN (0, 1));

    TRUNCATE arch_etl_db.crt_wra_visit_1_zapps_co_enrollment_overview;
    INSERT INTO arch_etl_db.crt_wra_visit_1_zapps_co_enrollment_overview(record_id,
                                                                         alternate_id,
                                                                         wra_ptid,
                                                                         member_id,
                                                                         screening_id,
                                                                         age,
                                                                         ra,
                                                                         visit_number,
                                                                         visit_name,
                                                                         visit_date)
    SELECT v1.record_id,
           v1.alternate_id,
           v1.wra_ptid,
           v1.member_id,
           v1.screening_id,
           v1.age,
           v1.ra,
           v1.visit_number,
           v1.visit_name,
           v1.visit_date
    FROM arch_etl_db.crt_wra_visit_1_overview v1
    ORDER BY v1.visit_date, v1.screening_id DESC;

    UPDATE arch_etl_db.crt_wra_visit_1_zapps_co_enrollment_overview zce
        LEFT JOIN arch_etl_db.wra_forms_repeating_instruments wra_v1 ON zce.record_id = wra_v1.record_id
    SET zce.is_wra_enrolled_in_zapps     = wra_v1.loc_enrolled_zapps_label,
        zce.zapps_ptid                   = wra_v1.loc_zapps_ptid,
        zce.zapps_ptid_source            = wra_v1.loc_zapps_ptid_src_label,
        zce.is_wra_enrolled_in_famli_dxa = wra_v1.famliid_yn_label,
        zce.famli_dxa_ptid               = wra_v1.famli_id_scorres,
        zce.famli_dxa_id_source          = wra_v1.loc_famli_id_src_label
    WHERE wra_v1.wra_forms_repeating_instruments_id = zce.alternate_id;
    COMMIT;

    -- Process Metrics
    SET @vv_tx_pro_zce_v1 = (SELECT COUNT(zce_v1.record_id) FROM arch_etl_db.crt_wra_visit_1_zapps_co_enrollment_overview zce_v1);
    SET @v_load_metrics = CONCAT_WS(' of ', @vv_tx_pro_zce_v1, @v_tx_pre_zce_v1);
    SET @v_load_info = CONCAT('WRA-ZAPPS-CO_ENROLLMENT-V1-Data: LOADING COMPLETE. ', @v_load_metrics);
    SELECT @v_load_info as `|_________________| Operation_Summary |_________________|`;

END $$

DELIMITER ;
