/**
* /--------------+___| Listed WRA's followed up at the second follow-up visit (FU 3) |___+------------\
*  The second follow-up form is designed as repeating instrument, as such the source data contains
*  duplicate record ID's and WRA PTID's rows. Here we pick the the latest visit by partitioning each
*  record by last attempt made there after sorting by latest/newest date.                               |
* This will also improve query time performance since we are querying lesser fields.                    |*
*                                                                                                       ~
* @author : Gift Jr | Dowc | <muyembegift@gmail.com>                                                    |*
* @since  : {0.0.1, 22.08.2024} | {0.0.2, 11.09.2024}                                                   ):
* @alias  : Harmonized WRA Second FU(3.0) Overview                                                      (;
 \_______---______/--------------------------------------------------------------------\______---______/
*/
CREATE OR REPLACE ALGORITHM = MERGE VIEW vw_wra_second_fu_visit_overview
AS
SELECT v3.id,
       v3.record_id,
       v3.attempt_number,
       v3.wra_ptid,
       get_WRA_HH_Screening_ID(v3.record_id) as screening_id,
       v3.date_of_enrollment,
       v3.ra,
       3.0                                   as visit_number,
       v3.visit_date,
       CASE
           WHEN v3.is_wra_available = 1 AND v3.attempt_number < 3 THEN 'Available'
           WHEN v3.is_wra_available = 2 AND v3.attempt_number < 3 THEN 'Deferred'
           WHEN v3.is_wra_available = 2 AND v3.attempt_number = 3 THEN 'Untraceable'
           WHEN v3.is_wra_available = 3 AND v3.attempt_number < 3 THEN 'Extended-Absence'
           WHEN v3.is_wra_available = 4 AND v3.attempt_number < 3 THEN 'Physical/Mental-Impairment'
           WHEN v3.is_wra_available = 7 AND v3.attempt_number < 3 THEN 'Migrated'
           WHEN v3.is_wra_available = 8 THEN 'Untraceable'
           ELSE v3.is_wra_available_label
           END                               as visit_status,
       v3.enrolled_in_zapps,
       v3.zapps_ptid
FROM (SELECT v3.root_id                                                             as id,
             v3.record_id,
             ROW_NUMBER() OVER (
                 PARTITION BY v3.record_id ORDER BY v3.redcap_repeat_instance DESC) as visit_id,
             v3.scrn_obsstdat_f2                                                    as visit_date,
             v3.redcap_repeat_instance                                              as attempt_number,
             v3.wra_enr_interviewer_obsloc_f2                                       as ra,
             COALESCE(v1.wra_ptid, v3.wra_fu_wra_ptid_f2)                           as wra_ptid,
             v1.screening_date                                                      as date_of_enrollment,
             v3.wra_enr_pp_avail_f2                                                 as is_wra_available,
             v3.wra_enr_pp_avail_f2_label                                           as is_wra_available_label,
             v3.loc_fu_enrolled_zapps_f2_label                                      as enrolled_in_zapps,
             v3.loc_fu_zapps_ptid_f2                                                as zapps_ptid
      FROM wra_follow_up_visit_2_repeating_instruments v3 -- VISIT #3.0
               LEFT JOIN vw_wra_baseline_visit_overview v1 ON v3.record_id = v1.record_id) v3
WHERE v3.visit_id = 1
ORDER BY v3.visit_date DESC;

