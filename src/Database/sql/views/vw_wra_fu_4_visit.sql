/**
 * WRA's followed up at the fourth follow-up visit(Visit 4.0).
 *
 * @author Gift Jr <muyembegift@gmail.com> | 12.11.24
 * @since 0.0.1
 * @alias WRA FU 4 List
 */
CREATE OR REPLACE ALGORITHM = MERGE VIEW vw_wra_fourth_fu_visit_overview
AS
SELECT v5.id,
       v5.record_id,
       v5.attempt_number,
       v5.wra_ptid,
       get_WRA_HH_Screening_ID(v5.record_id) as screening_id,
       v5.date_of_enrollment,
       v5.ra,
       5.0                                   as visit_number,
       v5.visit_date,
       CASE
           WHEN v5.is_wra_available = 1 AND v5.attempt_number <= 3 THEN 'Available'
           WHEN v5.is_wra_available = 2 AND v5.attempt_number < 3 THEN 'Deferred'
           WHEN v5.is_wra_available = 2 AND v5.attempt_number = 3 THEN 'Untraceable'
           WHEN v5.is_wra_available = 3 AND v5.attempt_number <= 3 THEN 'Extended-Absence'
           WHEN v5.is_wra_available = 4 AND v5.attempt_number < 3 THEN 'Physical/Mental-Impairment'
           WHEN v5.is_wra_available = 6 AND v5.attempt_number <= 3 THEN CONCAT_WS(' - ', 'Other', v5.is_wra_available_oth_label)
           WHEN v5.is_wra_available = 7 AND v5.attempt_number <= 3 THEN 'Migrated'
           WHEN v5.is_wra_available = 8 THEN 'Untraceable'
           ELSE v5.is_wra_available_label
           END                               as visit_status,
       v5.enrolled_in_zapps,
       v5.zapps_ptid
FROM (SELECT v5.root_id                                                             as id,
             v5.record_id,
             ROW_NUMBER() OVER (
                 PARTITION BY v5.record_id ORDER BY v5.redcap_repeat_instance DESC) as visit_id,
             v5.wra_fu_visit_date_f4                                                as visit_date,
             v5.redcap_repeat_instance                                              as attempt_number,
             v5.wra_fu_interviewer_obsloc_f4                                        as ra,
             COALESCE(v1.wra_ptid, v5.wra_fu_wra_ptid_f4)                           as wra_ptid,
             v1.screening_date                                                      as date_of_enrollment,
             v5.wra_fu_pp_avail_f4                                                  as is_wra_available,
             v5.wra_fu_pp_avail_f4_label                                            as is_wra_available_label,
             v5.wra_fu_is_wra_avail_other_f4                                        as is_wra_available_oth_label,
             v5.loc_fu_enrolled_zapps_f4_label                                      as enrolled_in_zapps,
             v5.loc_fu_zapps_ptid_f4                                                as zapps_ptid
      FROM wra_follow_up_visit_4_repeating_instruments v5
               LEFT JOIN vw_wra_baseline_visit_overview v1 ON v5.record_id = v1.record_id) v5
WHERE v5.visit_id = 1
ORDER BY v5.visit_date DESC;

