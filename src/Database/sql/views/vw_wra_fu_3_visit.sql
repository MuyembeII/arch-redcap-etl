/**
 * WRA's followed up at the third follow-up visit(Visit 3.0).
 *
 * @author Gift Jr <muyembegift@gmail.com> | 22.08.24
 * @since 0.0.1
 * @alias WRA FU 3 List
 */
CREATE OR REPLACE ALGORITHM = MERGE VIEW vw_wra_third_fu_visit_overview
AS
SELECT v4.id,
       v4.record_id,
       v4.attempt_number,
       v4.wra_ptid,
       get_WRA_HH_Screening_ID(v4.record_id) as screening_id,
       v4.date_of_enrollment,
       v4.ra,
       4.0                                   as visit_number,
       v4.visit_date,
       CASE
           WHEN v4.is_wra_available = 1 AND v4.attempt_number < 3 THEN 'Available'
           WHEN v4.is_wra_available = 2 AND v4.attempt_number < 3 THEN 'Deferred'
           WHEN v4.is_wra_available = 2 AND v4.attempt_number = 3 THEN 'Untraceable'
           WHEN v4.is_wra_available = 3 AND v4.attempt_number < 3 THEN 'Extended-Absence'
           WHEN v4.is_wra_available = 4 AND v4.attempt_number < 3 THEN 'Physical/Mental-Impairment'
           WHEN v4.is_wra_available = 7 AND v4.attempt_number < 3 THEN 'Migrated'
           WHEN v4.is_wra_available = 8 THEN 'Untraceable'
           ELSE v4.is_wra_available_label
           END                               as visit_status,
       v4.enrolled_in_zapps,
       v4.zapps_ptid
FROM (SELECT v4.root_id                                                             as id,
             v4.record_id,
             ROW_NUMBER() OVER (
                 PARTITION BY v4.record_id ORDER BY v4.redcap_repeat_instance DESC) as visit_id,
             v4.wra_fu_visit_date_f3                                                as visit_date,
             v4.redcap_repeat_instance                                              as attempt_number,
             v4.wra_fu_interviewer_obsloc_f3                                        as ra,
             COALESCE(v1.wra_ptid, v4.wra_fu_wra_ptid_f3)                           as wra_ptid,
             v1.screening_date                                                      as date_of_enrollment,
             v4.wra_fu_pp_avail_f3                                                  as is_wra_available,
             v4.wra_fu_pp_avail_f3_label                                            as is_wra_available_label,
             v4.loc_fu_enrolled_zapps_f3_label                                      as enrolled_in_zapps,
             v4.loc_fu_zapps_ptid_f3                                                as zapps_ptid
      FROM wra_follow_up_visit_3_repeating_instruments v4
               LEFT JOIN vw_wra_baseline_visit_overview v1 ON v4.record_id = v1.record_id) v4
WHERE v4.visit_id = 1
ORDER BY v4.visit_date DESC;

