/**
 * List of enrolled WRA's.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 10.06.24
 * @since 0.0.1
 * @alias WRA Enrollment List
 */
CREATE OR REPLACE ALGORITHM = MERGE VIEW vw_wra_baseline_visit_overview
AS
SELECT id,
       record_id,
       wra_enrollment_id,
       wra_ptid,
       member_id,
       visit_count,
       instance_id,
       screening_id,
       screening_date,
       ra,
       first_name,
       middle_name,
       last_name,
       other_name,
       age,
       enrolled_by
FROM (SELECT wra_enr.root_id                                    as id,
             wra_enr.record_id,
             ROW_NUMBER() OVER (
                 PARTITION BY wra_enr.record_id
                 ORDER BY wra_enr.redcap_repeat_instance DESC ) as visit_id,

             wra_enr.wra_enrollment_id,
             TRIM(wra_enr.wra_ptid)                             as wra_ptid,
             wra_enr.hhe_hh_member_id                           as member_id,
             wra_enr.wra_enr_visit_count                        as visit_count,
             wra_enr.redcap_repeat_instance                     as instance_id,
             TRIM(wra_enr.hh_scrn_num_obsloc)                   as screening_id,
             wra_enr.scrn_obsstdat                              as screening_date,
             TRIM(wra_enr.wra_ra_name)                          as ra,
             TRIM(wra_enr.fname_scorres)                        as first_name,
             TRIM(wra_enr.mname_scorres)                        as middle_name,
             TRIM(wra_enr.lname_scorres)                        as last_name,
             REPLACE(TRIM(wra_enr.oname_scorres), '  ', '')     as other_name,
             wra_enr.wra_age                                    as age,
             wra_enr.wra_enr_interviewer_obsloc                 as enrolled_by
      FROM wra_forms_repeating_instruments wra_enr
      WHERE wra_enr.wra_age > 0) e
WHERE e.visit_id = 1
ORDER BY e.screening_date DESC;

