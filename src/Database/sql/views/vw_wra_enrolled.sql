/**
 * List of enrolled WRA's.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 10.06.24
 * @since 0.0.1
 * @alias WRA Enrollment List
 */
CREATE OR REPLACE ALGORITHM = MERGE VIEW vw_wra_enrolled
AS
SELECT record_id, wra_enrollment_id, wra_ptid, member_id, visit_count, instance_id, screening_id, screening_date, ra, first_name, middle_name, last_name, age, enrolled_by
FROM
    (SELECT ROW_NUMBER() OVER (
        PARTITION BY wra_enr.record_id, wra_enr.hh_scrn_num_obsloc
        ORDER BY wra_enr.redcap_repeat_instance DESC ) as visit_id,
            wra_enr.record_id,
            wra_enr.wra_enrollment_id,
            wra_enr.wra_ptid,
            wra_enr.hhe_hh_member_id                    as member_id,
            wra_enr.wra_enr_visit_count                 as visit_count,
            wra_enr.redcap_repeat_instance              as instance_id,
            wra_enr.hh_scrn_num_obsloc                  as screening_id,
            wra_enr.scrn_obsstdat                       as screening_date,
            wra_enr.wra_ra_name                         as ra,
            wra_enr.fname_scorres                       as first_name,
            wra_enr.mname_scorres                       as middle_name,
            wra_enr.lname_scorres                       as last_name,
            wra_enr.wra_age                             as age,
            wra_enr.wra_enr_interviewer_obsloc          as enrolled_by
     FROM wra_forms_repeating_instruments wra_enr
     WHERE wra_enr.wra_age > 0) e
WHERE e.visit_id = 1
ORDER BY e.screening_date;

