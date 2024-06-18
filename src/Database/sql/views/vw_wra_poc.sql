/**
 * List of WRA POC.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 10.06.24
 * @since 0.0.1
 * @alias WRA POC List
 */
CREATE OR REPLACE ALGORITHM = MERGE VIEW vw_wra_poc
AS
SELECT poc.wra_physical_exam_and_collection_id                                                      as id,
       enr.record_id,
       v.visit_id,
       v.visit_number,
       v.visit_alias                                                                                as visit_name,
       COALESCE(poc.poc_visit_date, enr.screening_date)                                             as visit_date,
       enr.wra_ptid,
       IF(poc.poc_hx_hypertension <=> 1, 'Yes',
          IF(poc.poc_hx_hypertension <=> 0, 'No', poc.poc_hx_hypertension))                         as hx_of_hypertension,
       IF(poc.bp_vsstat <=> 1, 'Yes',
          IF(poc.bp_vsstat <=> 0, 'No', poc.bp_vsstat))                                             as bp_measured,
       poc.bp_sys_vsorres                                                                           as systolic_blood_pressure,
       poc.bp_dia_vsorres                                                                           as diastolic_blood_pressure,
       poc.pulse_vsorres                                                                            as pulse_rate,
       poc.last_sex_scorres_label                                                                   as time_of_last_intercourse,
       poc.poc_wsh_lub_label                                                                        as time_of_last_vaginal_wash,
       poc.poc_lt_antibiotics_label                                                                 as time_of_last_anti_biotics_usage,
       CASE poc.swab_spcperf
           WHEN 1 THEN 4
           WHEN 2 THEN 3
           WHEN 3 THEN 2
           WHEN 4 THEN 1
           ELSE 0
           END                                                                                      as num_of_vaginal_swab_collected,
       IF(poc.swab_spcreasnd <=> 5,
          CONCAT_WS(' - ', 'Other', poc.swab_othr_spcreasnd),
          poc.swab_spcreasnd_label)                                                                 as vaginal_swab_not_collected_reason,
       IF(poc.poc_urine_preg_test_done <=> 1, 'Yes',
          IF(poc.poc_urine_preg_test_done <=> 0, 'No',
             poc.poc_urine_preg_test_done))                                                         as upt_done,
       poc.upt_lborres_label                                                                        as upt_result,
       IF(poc.upt_lborres = 1, CONCAT_WS(
               '-', enr.wra_ptid, SUBSTR(COALESCE(poc.poc_visit_date, enr.screening_date), 1, 7)
           ), '')                                                                                   as pregnancy_id,
       poc.weight_peres                                                                             as weight,
       poc.height_peres                                                                             as height,
       ROUND(poc.weight_peres / POWER(poc.height_peres / 100, 2), 2)                                as bmi,
    /** BMI Classification Percentile And Cut Off Points
    ** @source https://www.ncbi.nlm.nih.gov/books/NBK541070/
    **/
       CASE
           WHEN ROUND(poc.weight_peres / POWER(poc.height_peres / 100, 2), 2) < 16.5 THEN 'Severely underweight'
           WHEN ROUND(poc.weight_peres / POWER(poc.height_peres / 100, 2), 2) BETWEEN 16.5 AND 18.5 THEN 'Underweight'
           WHEN ROUND(poc.weight_peres / POWER(poc.height_peres / 100, 2), 2) BETWEEN 18.5 AND 24.9 THEN 'Normal Weight'
           WHEN ROUND(poc.weight_peres / POWER(poc.height_peres / 100, 2), 2) BETWEEN 25 AND 29.9 THEN 'Overweight'
           WHEN ROUND(poc.weight_peres / POWER(poc.height_peres / 100, 2), 2) BETWEEN 30 AND 34.9 THEN 'Obesity class I'
           WHEN ROUND(poc.weight_peres / POWER(poc.height_peres / 100, 2), 2) BETWEEN 35 AND 39.9
               THEN 'Obesity class II'
           WHEN ROUND(poc.weight_peres / POWER(poc.height_peres / 100, 2), 2) > 40 THEN 'Obesity class III - Severe'
           END                                                                                      as bmi_category
FROM vw_wra_baseline_visit_overview enr
         LEFT JOIN wra_physical_exam_and_collection poc ON enr.record_id = poc.record_id
         LEFT JOIN visit v ON poc.redcap_event_name = v.visit_name
WHERE poc.bp_vsstat IS NOT NULL
ORDER BY poc.record_id, v.visit_number;

