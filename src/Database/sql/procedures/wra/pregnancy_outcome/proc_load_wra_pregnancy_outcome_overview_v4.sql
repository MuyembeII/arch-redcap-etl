/**
 * Load FU-3 WRA Pregnancy Outcome Assessment.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 11.02.25
 * @since 0.0.1
 * @alias Load WRA Pregnancy Outcome Assessments FU-3
 */
DROP PROCEDURE IF EXISTS `Load_WRA_Pregnancy_Outcome_Overview_V4`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_Pregnancy_Outcome_Overview_V4()
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
    TRUNCATE arch_etl_db.crt_wra_visit_4_pregnancy_outcome_overview;
    INSERT INTO arch_etl_db.crt_wra_visit_4_pregnancy_outcome_overview(record_id,
                                                                       wra_ptid,
                                                                       member_id,
                                                                       screening_id,
                                                                       age,
                                                                       ra,
                                                                       visit_number,
                                                                       visit_name,
                                                                       visit_date)
    SELECT v4.record_id,
           v4.wra_ptid,
           v4.member_id,
           v4.screening_id,
           v4.age,
           v4.ra,
           v4.visit_number,
           v4.visit_name,
           v4.visit_date
    FROM crt_wra_visit_4_overview v4
    WHERE v4.visit_outcome = 'Completed'
      AND v4.record_id IN (SELECT a.record_id FROM wrafu_pregnancy_assessments_3 a WHERE a.poa_ant_att_f3 IS NOT NULL)
    GROUP BY v4.visit_date, v4.screening_id
    ORDER BY v4.visit_date DESC;

    UPDATE crt_wra_visit_4_pregnancy_outcome_overview v4
        LEFT JOIN wrafu_pregnancy_assessments_3 poa_v4 ON v4.record_id = poa_v4.record_id
    SET v4.attended_anc               = IF(poa_v4.poa_ant_preg_f3 = 1, 'Yes',
                                           IF(poa_v4.poa_ant_preg_f3 = 0, 'No', poa_v4.poa_ant_preg_f3)),
        v4.tx_anc_visit               = poa_v4.poa_ant_count_f3,
        v4.tx_fetus                   =IF(poa_v4.poa_fetus_count_f3 = 5, NULL, poa_v4.poa_fetus_count_f3),
        v4.pregnancy_outcome          = CASE
                                            WHEN poa_v4.poa_preg_outcome_f3 = 1 THEN 'Delivery'
                                            WHEN poa_v4.poa_preg_outcome_f3 = 2 THEN 'Spontaneous abortion'
                                            WHEN poa_v4.poa_preg_outcome_f3 = 3 THEN 'Induced abortion'
                                            WHEN poa_v4.poa_preg_outcome_f3 = 4 THEN 'Ectopic pregnancy'
                                            WHEN poa_v4.poa_preg_outcome_f3 = 5 THEN 'Unknown'
                                            ELSE ''
            END,
        v4.pregnancy_delivery_outcome = poa_v4.poa_preg_dev_outcome_f3_label,
        v4.pregnancy_end_date         = poa_v4.poa_mae_pregend_date_f3,
        v4.weeks_pregnancy_ended      = poa_v4.poa_preg_dur_weeks_f3,
        v4.months_pregnancy_ended     = poa_v4.poa_preg_dur_months_f3,
        v4.pregnancy_delivery_date    = poa_v4.poa_pregdev_date_f3,
        v4.weeks_pregnancy_delivered  = poa_v4.poa_pregdev_dur_weeks_f3,
        v4.months_pregnancy_delivered = poa_v4.poa_pregdev_dur_months_f3
    WHERE poa_v4.poa_ant_preg_f3 IN (0, 1);
    COMMIT;

    -- flag completion
    SELECT 'Pregnancy-Outcome-Data FU-3 loader completed successfully.' as `status`;

END $$

DELIMITER ;
