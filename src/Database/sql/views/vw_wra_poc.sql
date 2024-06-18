/**
 * List of WRA POC.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 10.06.24
 * @since 0.0.1
 * @alias WRA POC List
 */
CREATE OR REPLACE ALGORITHM = MERGE VIEW vw_wra_poc
AS
SELECT enr.record_id,
       enr.wra_ptid,
       poc.poc_visit_date,
       poc.poc_hx_hypertension,
       poc.bp_vsstat,
       poc.bp_sys_vsorres,
       poc.bp_dia_vsorres,
       poc.pulse_vsorres,
       poc.swab_spcperf,
       poc.swab_othr_spcreasnd,
       poc.poc_urine_preg_test_done,
       poc.upt_lborres,
       poc.weight_peres,
       poc.height_peres,
       poc.bmi
FROM vw_wra_enrolled enr
         LEFT JOIN wra_physical_exam_and_collection poc ON enr.record_id = poc.record_id
WHERE poc.bp_vsstat IS NOT NULL;

