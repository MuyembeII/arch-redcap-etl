/**
 * WRA's followed up at the fourth follow-up visit(Visit 6.0).
 *
 * @author Gift Jr <muyembegift@gmail.com> | 12.11.24
 * @since 0.0.1
 * @alias WRA FU 4 List
 */
CREATE OR REPLACE ALGORITHM = MERGE VIEW vw_wra_fifth_fu_visit_overview
AS
SELECT v6.id,
       v6.record_id,
       v6.attempt_number,
       v6.wra_ptid,
       COALESCE(v6.screening_id, get_WRA_HH_Screening_ID(v6.record_id)) as screening_id,
       v6.date_of_enrollment,
       v6.ra,
       6.0     as visit_number,
       v6.visit_date,
       CASE
           WHEN v6.is_wra_available = 1 AND v6.attempt_number <= 3 THEN 'Completed'
           WHEN v6.is_wra_available = 2 AND v6.attempt_number < 3 THEN 'Incomplete'
           WHEN v6.is_wra_available = 2 AND v6.attempt_number = 3 THEN 'Untraceable'
           WHEN v6.is_wra_available = 3 AND v6.attempt_number <= 3 THEN 'Extended-Absence'
           WHEN v6.is_wra_available = 4 AND v6.attempt_number < 3 THEN 'Physical/Mental-Impairment'
           WHEN v6.is_wra_available = 6 AND v6.attempt_number <= 3
               THEN CONCAT_WS(' - ', 'Other', v6.is_wra_available_oth_label)
           WHEN v6.is_wra_available = 7 AND v6.attempt_number <= 3 THEN 'Migrated'
           WHEN v6.is_wra_available = 8 THEN 'Untraceable'
           ELSE v6.is_wra_available_label
           END as visit_status,
       v6.enrolled_in_zapps,
       v6.zapps_ptid
FROM (SELECT v6.root_id                                                             as id,
             v6.record_id,
             ROW_NUMBER() OVER (
                 PARTITION BY v6.record_id ORDER BY v6.redcap_repeat_instance DESC) as visit_id,
             v6.wra_fu_visit_date_f5                                                as visit_date,
             v6.redcap_repeat_instance                                              as attempt_number,
             v6.wra_fu_interviewer_obsloc_f5                                        as ra,
             v6.hh_scrn_num_obsloc_f5                                               as screening_id,
             COALESCE(v1.wra_ptid, v6.wra_fu_wra_ptid_f5)                           as wra_ptid,
             v1.screening_date                                                      as date_of_enrollment,
             v6.wra_fu_pp_avail_f5                                                  as is_wra_available,
             v6.wra_fu_pp_avail_f5_label                                            as is_wra_available_label,
             v6.wra_fu_is_wra_avail_other_f5                                        as is_wra_available_oth_label,
             v6.loc_fu_enrolled_zapps_f5_label                                      as enrolled_in_zapps,
             v6.loc_fu_zapps_ptid_f5                                                as zapps_ptid
      FROM wra_follow_up_visit_5_repeating_instruments v6
               LEFT JOIN vw_wra_baseline_visit_overview v1 ON v6.record_id = v1.record_id) v6
WHERE v6.visit_id = 1
ORDER BY v6.visit_date DESC;

