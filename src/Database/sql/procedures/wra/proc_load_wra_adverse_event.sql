/**
 * Load WRA Adverse Event Occurrences (SAE).
 *
 * @author Gift Jr <muyembegift@gmail.com> | 27.02.25
 * @since 0.0.1
 * @alias WRA Adverse Events
 */
DROP PROCEDURE IF EXISTS `Load_WRA_Adverse_Events`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_Adverse_Events()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load WRA SAE;', @errno, '(',
                              @sqlstate, '):',
                              @text);
            SELECT @full_error as Error_Details;
            RESIGNAL;
        END;
    SET @v_tx_pre_sae := 0; -- Initial count
    SET @v_tx_pro_sae := 0; -- After count

    START TRANSACTION;
    SET @v_tx_pre_sae = (SELECT COUNT(sae.record_id) FROM adverse_event sae);
    TRUNCATE arch_etl_db.crt_wra_adverse_events;
    INSERT INTO arch_etl_db.crt_wra_adverse_events(record_id,
                                                   alternate_id,
                                                   wra_ptid,
                                                   member_id,
                                                   screening_id,
                                                   age,
                                                   dob,
                                                   visit_number,
                                                   visit_name,
                                                   visit_date,
                                                   primary_adverse_event,
                                                   date_of_onset_of_ae,
                                                   is_serious_adverse_event,
                                                   serious_adverse_event_type,
                                                   date_of_site_awareness_of_sae,
                                                   study_related_adverse_event,
                                                   nature_severity_freq_expected_sae,
                                                   outcome_of_sae,
                                                   date_of_death,
                                                   time_of_death,
                                                   date_of_hospital_discharge,
                                                   comments)
    SELECT ae.*
    FROM (SELECT ae.record_id,
                 ae.adverse_event_id                         as alternate_id,
                 v1.wra_ptid,
                 v1.member_id                                as member_id,
                 v1.screening_id                             as screening_id,
                 get_WRA_Age(ae.ae_visit_date, ae.record_id) as age,
                 v1.dob,
                 v.visit_number,
                 v.visit_alias                               as visit_name,
                 ae.ae_visit_date                            as visit_date,
                 ae.primary_aeoccur                          as primary_adverse_event,
                 ae.ae_aestdat                               as date_of_onset_of_ae,
                 get_YN_Label(ae.ae_serious_aeoccur)         as is_serious_adverse_event,
                 ae.ae_aecat_label                           as serious_adverse_event_type,
                 ae.ae_aware_aeongo                          as date_of_site_awareness_of_sae,
                 get_YN_Label(ae.ae_related_aeoccur)         as study_related_adverse_event,
                 ae.ae_expected_aeoccur_label                as nature_severity_freq_expected_sae,
                 ae.outcome_aeoccur_label                    as outcome_of_sae,
                 ae.dthdat                                   as date_of_death,
                 TIME(ae.time_dthdat)                        as time_of_death,
                 ae.disch_dat_aeoccur                        as date_of_hospital_discharge,
                 ae.sea_coval                                as comments
          FROM adverse_event ae
                   LEFT JOIN crt_wra_visit_1_overview v1 ON v1.record_id = ae.record_id
                   LEFT JOIN visit v ON ae.redcap_event_name = v.visit_name
          WHERE ae.ae_visit_date IS NOT NULL
          GROUP BY v1.screening_id, v1.member_id) ae;
    SET @v_tx_pro_sae = (SELECT COUNT(sae.record_id) FROM crt_wra_adverse_events sae);
    COMMIT;
    -- Process Metrics
    SET @v_load_metrics = CONCAT_WS(' of ', @v_tx_pro_sae, @v_tx_pre_sae);
    SET @v_load_info = CONCAT('WRA-Adverse-Event-Data: LOADING COMPLETE. ', @v_load_metrics);
    SELECT @v_load_info as `|_________________| Operation_Summary |_________________|`;

END $$

DELIMITER ;
