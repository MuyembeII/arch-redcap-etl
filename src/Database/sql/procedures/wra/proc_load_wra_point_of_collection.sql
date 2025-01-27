/**
 * Load WRA Point of Collection.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 25.01.25
 * @since 0.0.1
 * @alias Load WRA POC
 */
DROP PROCEDURE IF EXISTS `Load_WRA_Point_of_Collection`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_Point_of_Collection()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load WRA Point of Collection;', @errno, '(', @sqlstate, '):',
                              @text);
            SELECT @full_error;
            RESIGNAL;
        END;

    START TRANSACTION;
    INSERT INTO arch_etl_db.crt_wra_point_of_collection_overview(poc_id, record_id, wra_ptid, member_id, screening_id,
                                                                 visit_number, visit_name, visit_date,
                                                                 hx_of_hypertension, bp_systolic, bp_diastolic,
                                                                 pulse_rate,
                                                                 vaginal_swabs_collected, upt_result, pregnancy_id,
                                                                 weight,
                                                                 height, bmi, bmi_result)
    SELECT poc.wra_physical_exam_and_collection_id                            as poc_id,
           poc.record_id,
           wra.wra_ptid,
           wra.member_id,
           wra.screening_id,
           v.visit_number,
           v.visit_alias                                                      as visit_name,
           poc.poc_visit_date                                                 as visit_date,
           IF(poc.poc_hx_hypertension = 1, 'Yes',
              IF(poc.poc_hx_hypertension = 0, 'No', poc.poc_hx_hypertension)) as hx_of_hypertension,
           poc.bp_sys_vsorres                                                 as bp_systolic,
           poc.bp_dia_vsorres                                                 as bp_diastolic,
           poc.pulse_vsorres                                                  as pulse_rate,
           CASE poc.swab_spcperf
               WHEN 1 THEN 4
               WHEN 2 THEN 3
               WHEN 3 THEN 2
               WHEN 4 THEN 1
               ELSE 0
               END                                                               vaginal_swabs_collected,
           poc.upt_lborres_label                                              as upt_result,
           poc.poc_preg_id_2                                                  as pregnancy_id,
           poc.weight_peres                                                   as weight,
           poc.height_peres                                                   as height,
           poc.bmi,
           poc.anth_bmi_result                                                as bmi_result
    FROM wra_physical_exam_and_collection poc
             INNER JOIN wra_overview wra ON poc.record_id = wra.record_id
             INNER JOIN visit v ON poc.redcap_event_name = v.visit_name
    WHERE poc.bp_vsstat IS NOT NULL;
    COMMIT;

    -- flag completion
    SELECT 'POC-Data loader completed successfully.' as `status`;

END $$

DELIMITER ;
