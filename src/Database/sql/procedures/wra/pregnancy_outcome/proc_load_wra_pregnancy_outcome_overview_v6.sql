/**
 * Load FU-5 WRA Pregnancy Outcome Assessment.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 11.02.25
 * @since 0.0.1
 * @alias Load WRA Pregnancy Outcome Assessments FU-5
 */
DROP PROCEDURE IF EXISTS `Load_WRA_Pregnancy_Outcome_Overview_V6`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_Pregnancy_Outcome_Overview_V6()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load FU-5 WRA Pregnancy Outcome Assessments;', @errno, '(',
                              @sqlstate, '):',
                              @text);
            SELECT @full_error;
            RESIGNAL;
        END;

    START TRANSACTION;
    TRUNCATE arch_etl_db.crt_wra_visit_6_pregnancy_outcome_overview;
    INSERT INTO arch_etl_db.crt_wra_visit_6_pregnancy_outcome_overview(record_id,
                                                                       wra_ptid,
                                                                       member_id,
                                                                       screening_id,
                                                                       age,
                                                                       ra,
                                                                       visit_number,
                                                                       visit_name,
                                                                       visit_date)
    SELECT v6.record_id,
           v6.wra_ptid,
           v6.member_id,
           v6.screening_id,
           v6.age,
           v6.ra,
           v6.visit_number,
           v6.visit_name,
           v6.visit_date
    FROM crt_wra_visit_6_overview v6
    WHERE v6.visit_outcome = 'Completed'
      AND v6.record_id IN (SELECT a.record_id FROM wrafu_pregnancy_assessments_5 a WHERE a.pa_fu_visit_date_f5 IS NOT NULL)
    GROUP BY v6.visit_date, v6.screening_id
    ORDER BY v6.visit_date DESC;

    UPDATE crt_wra_visit_6_pregnancy_outcome_overview v6
        LEFT JOIN wrafu_pregnancy_assessments_5 poa_v6 ON v6.record_id = poa_v6.record_id
    SET v6.attended_anc               = IF(poa_v6.poa_ant_preg_f5 = 1, 'Yes',
                                           IF(poa_v6.poa_ant_preg_f5 = 0, 'No', poa_v6.poa_ant_preg_f5)),
        v6.tx_anc_visit               = poa_v6.poa_ant_count_f5,
        v6.tx_fetus                   =IF(poa_v6.poa_fetus_count_f5 = 5, NULL, poa_v6.poa_fetus_count_f5),
        v6.pregnancy_outcome          = CASE
                                            WHEN poa_v6.poa_preg_outcome_f5 = 1 THEN 'Delivery'
                                            WHEN poa_v6.poa_preg_outcome_f5 = 2 THEN 'Spontaneous abortion'
                                            WHEN poa_v6.poa_preg_outcome_f5 = 3 THEN 'Induced abortion'
                                            WHEN poa_v6.poa_preg_outcome_f5 = 4 THEN 'Ectopic pregnancy'
                                            WHEN poa_v6.poa_preg_outcome_f5 = 5 THEN 'Unknown'
                                            ELSE ''
            END,
        v6.pregnancy_delivery_outcome = poa_v6.poa_preg_dev_outcome_f5_label,
        v6.pregnancy_end_date         = poa_v6.poa_mae_pregend_date_f5,
        v6.weeks_pregnancy_ended      = poa_v6.poa_preg_dur_weeks_f5,
        v6.months_pregnancy_ended     = poa_v6.poa_preg_dur_months_f5,
        v6.pregnancy_delivery_date    = poa_v6.poa_pregdev_date_f5,
        v6.weeks_pregnancy_delivered  = poa_v6.poa_pregdev_dur_weeks_f5,
        v6.months_pregnancy_delivered = poa_v6.poa_pregdev_dur_months_f5
    WHERE poa_v6.pa_fu_visit_date_f5 IS NOT NULL;
    COMMIT;

    -- flag completion
    SELECT 'Pregnancy-Outcome-Data FU-5 loader completed successfully.' as `status`;

END $$

DELIMITER ;
