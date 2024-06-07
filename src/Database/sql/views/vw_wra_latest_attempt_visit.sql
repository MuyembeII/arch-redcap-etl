/**
 * Named query resolution for WRA latest/current attempt visit.
 * WBE threshold for visit attempts is 3 in a period of 14 days.
 * The purpose of this virtual table is to reduce data distraction
 * due to the immense number of fields in WBE. Only primary indicator
 * variables will be included to the overview to improve look-up
 * performance.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 30.10.23
 * @since 0.0.1
 * @alias WBE Current Attempt Overview
 */
CREATE OR REPLACE ALGORITHM = MERGE VIEW wra_current_attempt_visit
AS
SELECT ROW_NUMBER() OVER (
    PARTITION BY wra_enr.redcap_repeat_instrument
    ORDER BY wra_enr.redcap_repeat_instance DESC )         as visit_id,
       wra_enr.record_id,
       wra_enr.wra_enrollment_id,
       wra_enr.wra_ptid,
       wra_enr.hhe_hh_member_id                            as member_id,
       wra_enr.wra_enr_visit_count                         as visit_count,
       wra_enr.redcap_repeat_instance                      as instance_id,
       wra_enr.hh_scrn_num_obsloc                          as screening_id,
       wra_enr.scrn_obsstdat                               as screening_date,
       wra_enr.wra_ra_name                                 as ra,
       wra_enr.fname_scorres                               as first_name,
       wra_enr.mname_scorres                               as middle_name,
       wra_enr.lname_scorres                               as last_name,
       wra_enr.wra_age                                     as age,
       get_WRA_EnrollmentStatus(wra_enr.wra_enrollment_id) as enrollment_status,
       wra_enr.wra_enr_interviewer_obsloc                  as enrolled_by
FROM wra_enrollment wra_enr;

