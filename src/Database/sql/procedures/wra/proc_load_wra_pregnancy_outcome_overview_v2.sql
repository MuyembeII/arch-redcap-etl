/**
 * Load FU-2 WRA Pregnancy Outcome Assessment.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 11.02.25
 * @since 0.0.1
 * @alias Load WRA Pregnancy Outcome Assessments FU-2
 */
DROP PROCEDURE IF EXISTS `Load_WRA_Pregnancy_Assessment_Overview_V2`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_Pregnancy_Assessment_Overview_V2()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load FU-2 WRA Pregnancy Outcome Assessments;', @errno, '(',
                              @sqlstate, '):',
                              @text);
            SELECT @full_error;
            RESIGNAL;
        END;

    START TRANSACTION;
    TRUNCATE arch_etl_db.crt_wra_visit_2_pregnancy_outcome_overview;
    INSERT INTO arch_etl_db.crt_wra_visit_2_pregnancy_outcome_overview(record_id,
                                                                       wra_ptid,
                                                                       member_id,
                                                                       screening_id,
                                                                       age,
                                                                       ra,
                                                                       visit_number,
                                                                       visit_name,
                                                                       visit_date)
    SELECT v2.record_id,
           v2.wra_ptid,
           v2.member_id,
           v2.screening_id,
           v2.age,
           v2.ra,
           v2.visit_number,
           v2.visit_name,
           v2.visit_date
    FROM crt_wra_visit_2_overview v2
    WHERE v2.visit_outcome = 'Completed'
      AND v2.record_id IN (SELECT a.record_id FROM wrafu_pregnancy_assessments a WHERE a.poa_ant_att IS NOT NULL)
    GROUP BY v2.visit_date, v2.screening_id
    ORDER BY v2.visit_date DESC;

    UPDATE crt_wra_visit_2_pregnancy_outcome_overview v2
        LEFT JOIN wrafu_pregnancy_assessments poa_v2 ON v2.record_id = poa_v2.record_id
    SET v2.attended_anc               = IF(poa_v2.poa_ant_preg = 1, 'Yes',
                                           IF(poa_v2.poa_ant_preg = 0, 'No', poa_v2.poa_ant_preg)),
        v2.tx_anc_visit               = poa_v2.poa_ant_count,
        v2.tx_fetus                   =IF(poa_v2.poa_fetus_count = 5, NULL, poa_v2.poa_fetus_count),
        v2.pregnancy_outcome          = CASE
                                            WHEN poa_v2.poa_preg_outcome = 1 THEN 'Delivery'
                                            WHEN poa_v2.poa_preg_outcome = 2 THEN 'Spontaneous abortion'
                                            WHEN poa_v2.poa_preg_outcome = 3 THEN 'Induced abortion'
                                            WHEN poa_v2.poa_preg_outcome = 4 THEN 'Ectopic pregnancy'
                                            WHEN poa_v2.poa_preg_outcome = 5 THEN 'Unknown'
                                            ELSE ''
            END,
        v2.pregnancy_delivery_outcome = poa_v2.poa_preg_dev_outcome_label,
        v2.pregnancy_end_date         = poa_v2.poa_mae_pregend_date,
        v2.weeks_pregnancy_ended      = poa_v2.poa_preg_dur_weeks,
        v2.months_pregnancy_ended     = poa_v2.poa_preg_dur_months,
        v2.pregnancy_delivery_date    = poa_v2.poa_pregdev_date,
        v2.weeks_pregnancy_delivered  = poa_v2.poa_pregdev_dur_weeks,
        v2.months_pregnancy_delivered = poa_v2.poa_pregdev_dur_months
    WHERE poa_v2.poa_ant_preg IN (0, 1);
    COMMIT;

    -- flag completion
    SELECT 'Pregnancy-Outcome-Data V2 loader completed successfully.' as `status`;

END $$

DELIMITER ;
