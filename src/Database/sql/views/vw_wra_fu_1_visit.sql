/**
 * WRA's followed up at the first follow-up visit(Visit 2.0).
 *
 * @author Gift Jr <muyembegift@gmail.com> | 22.08.24
 * @since 0.0.1
 * @alias WRA FU 1 List
 */
CREATE OR REPLACE ALGORITHM = MERGE VIEW vw_wra_first_fu_visit_overview
AS
SELECT v2.id,
       v2.record_id,
       v2.attempt_number,
       v2.wra_ptid,
       get_WRA_HH_Screening_ID(v2.record_id) as screening_id,
       v2.date_of_enrollment,
       v2.ra,
       2.0                                   as visit_number,
       v2.visit_date,
       CASE
           WHEN v2.is_wra_available = 1 AND v2.attempt_number <= 3 THEN 'Available'
           WHEN v2.is_wra_available = 2 AND v2.attempt_number < 3 THEN 'Deferred'
           WHEN v2.is_wra_available = 2 AND v2.attempt_number = 3 THEN 'Untraceable'
           WHEN v2.is_wra_available = 3 AND v2.attempt_number <= 3 THEN 'Extended-Absence'
           WHEN v2.is_wra_available = 4 AND v2.attempt_number < 3 THEN 'Physical/Mental-Impairment'
           WHEN v2.is_wra_available = 6 AND v2.attempt_number <= 3
               THEN CONCAT_WS(' - ', 'Other', v2.is_wra_available_oth_label)
           WHEN v2.is_wra_available = 7 AND v2.attempt_number <= 3 THEN 'Migrated'
           WHEN v2.is_wra_available = 8 THEN 'Untraceable'
           ELSE v2.is_wra_available_label
           END                               as visit_status,
       v2.enrolled_in_zapps,
       v2.zapps_ptid
FROM (SELECT v2.root_id                                                             as id,
             v2.record_id,
             ROW_NUMBER() OVER (
                 PARTITION BY v2.record_id ORDER BY v2.redcap_repeat_instance DESC) as visit_id,
             v2.wra_fu_visit_date                                                   as visit_date,
             v2.redcap_repeat_instance                                              as attempt_number,
             v2.wra_fu_interviewer_obsloc                                           as ra,
             COALESCE(v1.wra_ptid, v2.wra_fu_wra_ptid)                              as wra_ptid,
             v1.screening_date                                                      as date_of_enrollment,
             v2.wra_fu_pp_avail                                                     as is_wra_available,
             v2.wra_fu_pp_avail_label                                               as is_wra_available_label,
             v2.wra_fu_is_wra_avail_other                                           as is_wra_available_oth_label,
             v2.loc_fu_enrolled_zapps_label                                         as enrolled_in_zapps,
             v2.loc_fu_zapps_ptid                                                   as zapps_ptid
      FROM wra_follow_up_visit_repeating_instruments v2
               LEFT JOIN vw_wra_baseline_visit_overview v1 ON v2.record_id = v1.record_id) v2
WHERE v2.visit_id = 1
ORDER BY v2.visit_date DESC;

