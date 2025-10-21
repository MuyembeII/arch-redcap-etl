/**
 * Load FU-4 WRA Pregnancy Outcome Assessment.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 11.02.25
 * @since 0.0.1
 * @alias Load WRA Pregnancy Outcome Assessments FU-4
 */
DROP PROCEDURE IF EXISTS `Load_WRA_Pregnancy_Outcome_Overview_V5`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_Pregnancy_Outcome_Overview_V5()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load FU-4 WRA Pregnancy Outcome Assessments;', @errno, '(',
                              @sqlstate, '):',
                              @text);
            SELECT @full_error;
            RESIGNAL;
        END;

    START TRANSACTION;
    TRUNCATE arch_etl_db.crt_wra_visit_5_pregnancy_outcome_overview;
    INSERT INTO arch_etl_db.crt_wra_visit_5_pregnancy_outcome_overview(record_id,
                                                                       wra_ptid,
                                                                       member_id,
                                                                       screening_id,
                                                                       age,
                                                                       ra,
                                                                       visit_number,
                                                                       visit_name,
                                                                       visit_date)
    SELECT v5.record_id,
           v5.wra_ptid,
           v5.member_id,
           v5.screening_id,
           v5.age,
           v5.ra,
           v5.visit_number,
           v5.visit_name,
           v5.visit_date
    FROM crt_wra_visit_5_overview v5
    WHERE v5.visit_outcome = 'Completed'
      AND v5.record_id IN (SELECT a.record_id FROM wrafu_pregnancy_assessments_4 a WHERE a.pa_fu_visit_date_f4 IS NOT NULL)
    GROUP BY v5.visit_date, v5.screening_id
    ORDER BY v5.visit_date DESC;

    UPDATE crt_wra_visit_5_pregnancy_outcome_overview v5
        LEFT JOIN wrafu_pregnancy_assessments_4 poa_v5 ON v5.record_id = poa_v5.record_id
    SET v5.attended_anc               = IF(poa_v5.poa_ant_preg_f4 = 1, 'Yes',
                                           IF(poa_v5.poa_ant_preg_f4 = 0, 'No', poa_v5.poa_ant_preg_f4)),
        v5.tx_anc_visit               = poa_v5.poa_ant_count_f4,
        v5.tx_fetus                   =IF(poa_v5.poa_fetus_count_f4 = 5, NULL, poa_v5.poa_fetus_count_f4),
        v5.pregnancy_outcome          = CASE
                                            WHEN poa_v5.poa_preg_outcome_f4 = 1 THEN 'Delivery'
                                            WHEN poa_v5.poa_preg_outcome_f4 = 2 THEN 'Spontaneous abortion'
                                            WHEN poa_v5.poa_preg_outcome_f4 = 3 THEN 'Induced abortion'
                                            WHEN poa_v5.poa_preg_outcome_f4 = 4 THEN 'Ectopic pregnancy'
                                            WHEN poa_v5.poa_preg_outcome_f4 = 5 THEN 'Unknown'
                                            ELSE ''
            END,
        v5.pregnancy_delivery_outcome = poa_v5.poa_preg_dev_outcome_f4_label,
        v5.pregnancy_end_date         = poa_v5.poa_mae_pregend_date_f4,
        v5.weeks_pregnancy_ended      = poa_v5.poa_preg_dur_weeks_f4,
        v5.months_pregnancy_ended     = poa_v5.poa_preg_dur_months_f4,
        v5.pregnancy_delivery_date    = poa_v5.poa_pregdev_date_f4,
        v5.weeks_pregnancy_delivered  = poa_v5.poa_pregdev_dur_weeks_f4,
        v5.months_pregnancy_delivered = poa_v5.poa_pregdev_dur_months_f4
    WHERE poa_v5.pa_fu_visit_date_f4 IS NOT NULL;
    COMMIT;

    -- flag completion
    SELECT 'Pregnancy-Outcome-Data FU-4 loader completed successfully.' as `status`;

END $$

DELIMITER ;
