/**
 * Load FU-2 WRA Pregnancy Outcome Assessment.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 11.02.25
 * @since 0.0.1
 * @alias Load WRA Pregnancy Outcome Assessments FU-2
 */
DROP PROCEDURE IF EXISTS `Load_WRA_Pregnancy_Outcome_Overview_V3`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_Pregnancy_Outcome_Overview_V3()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load FU-3 WRA Pregnancy Outcome Assessments;', @errno, '(',
                              @sqlstate, '):',
                              @text);
            SELECT @full_error;
            RESIGNAL;
        END;

    START TRANSACTION;
    TRUNCATE arch_etl_db.crt_wra_visit_3_pregnancy_outcome_overview;
    INSERT INTO arch_etl_db.crt_wra_visit_3_pregnancy_outcome_overview(record_id,
                                                                       wra_ptid,
                                                                       member_id,
                                                                       screening_id,
                                                                       age,
                                                                       ra,
                                                                       visit_number,
                                                                       visit_name,
                                                                       visit_date)
    SELECT v3.record_id,
           v3.wra_ptid,
           v3.member_id,
           v3.screening_id,
           v3.age,
           v3.ra,
           v3.visit_number,
           v3.visit_name,
           v3.visit_date
    FROM crt_wra_visit_3_overview v3
    WHERE v3.visit_outcome = 'Completed'
      AND v3.record_id IN (SELECT a.record_id FROM wrafu_pregnancy_assessments_2 a WHERE a.pa_fu_visit_date_f2 IS NOT NULL)
    GROUP BY v3.visit_date, v3.screening_id
    ORDER BY v3.visit_date DESC;

    UPDATE crt_wra_visit_3_pregnancy_outcome_overview v3
        LEFT JOIN wrafu_pregnancy_assessments_2 poa_v3 ON v3.record_id = poa_v3.record_id
    SET v3.attended_anc               = IF(poa_v3.poa_ant_preg_f2 = 1, 'Yes',
                                           IF(poa_v3.poa_ant_preg_f2 = 0, 'No', poa_v3.poa_ant_preg_f2)),
        v3.tx_anc_visit               = poa_v3.poa_ant_count_f2,
        v3.tx_fetus                   =IF(poa_v3.poa_fetus_count_f2 = 5, NULL, poa_v3.poa_fetus_count_f2),
        v3.pregnancy_outcome          = CASE
                                            WHEN poa_v3.poa_preg_outcome_f2 = 1 THEN 'Delivery'
                                            WHEN poa_v3.poa_preg_outcome_f2 = 2 THEN 'Spontaneous abortion'
                                            WHEN poa_v3.poa_preg_outcome_f2 = 3 THEN 'Induced abortion'
                                            WHEN poa_v3.poa_preg_outcome_f2 = 4 THEN 'Ectopic pregnancy'
                                            WHEN poa_v3.poa_preg_outcome_f2 = 5 THEN 'Unknown'
                                            ELSE ''
            END,
        v3.pregnancy_delivery_outcome = poa_v3.poa_preg_dev_outcome_f2_label,
        v3.pregnancy_end_date         = poa_v3.poa_mae_pregend_date_f2,
        v3.weeks_pregnancy_ended      = poa_v3.poa_preg_dur_weeks_f2,
        v3.months_pregnancy_ended     = poa_v3.poa_preg_dur_months_f2,
        v3.pregnancy_delivery_date    = poa_v3.poa_pregdev_date_f2,
        v3.weeks_pregnancy_delivered  = poa_v3.poa_pregdev_dur_weeks_f2,
        v3.months_pregnancy_delivered = poa_v3.poa_pregdev_dur_months_f2
    WHERE poa_v3.pa_fu_visit_date_f2 IS NOT NULL;
    COMMIT;

    -- flag completion
    SELECT 'Pregnancy-Outcome-Data FU-2 loader completed successfully.' as `status`;

END $$

DELIMITER ;
