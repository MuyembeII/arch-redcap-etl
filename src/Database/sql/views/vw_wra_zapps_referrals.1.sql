/**
 * List of WRA POC.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 04.09.24
 * @since 0.0.1
 * @alias WRA POC List
 */
CREATE OR REPLACE ALGORITHM = MERGE VIEW vw_wra_zapps_referrals
AS
SELECT *
FROM (SELECT DISTINCT e.record_id,
                      e.screening_id,
                      v1.scrn_obsstdat                                                             as visit_date,
                      1.0                                                                          as visit_number,
                      v1.wra_enr_interviewer_obsloc                                                as refferring_staff,
                      e.wra_ptid,
                      REPLACE(CONCAT_WS(' ', e.first_name, e.middle_name, e.last_name), '  ', ' ') as wra_name,
                      e.age,
                      COALESCE(
                              wc.wra_first_contact_v4,
                              wc.wra_first_contact_v3,
                              wc.wra_first_contact_v2,
                              wc.wra_first_contact_v1
                      )                                                                            as first_contact_number,
                      l.first_contact_number_owner,
                      l.first_contact_number_caller_id,
                      COALESCE(
                              wc.wra_second_contact_v4,
                              wc.wra_second_contact_v3,
                              wc.wra_second_contact_v2,
                              wc.wra_second_contact_v1
                      )                                                                            as second_contact_number,
                      l.second_contact_number_owner,
                      l.second_contact_number_caller_id,
                      v1.wra_enr_pp_avail_label                                                    as is_wra_available,
                      vwp.upt_result,
                      vwp.pregnancy_id,
                      pv1.lmp_date,
                      v1.scrn_obsstdat                                                             as date_of_1st_positive_upt,
                      pv1.zapps_referral_acceptance,
                      pv1.zapps_appointment_date,
                      CONCAT_WS('-', pv1.wra_ptid, pv1.zapps_appointment_date)                     as arch_zapps_id,
                      pv1.preferred_zapps_clinic
      FROM vw_wra_baseline_visit_overview e
               LEFT JOIN vw_wra_locator_details l ON e.record_id = l.record_id
               LEFT JOIN crt_wra_contacts wc ON e.record_id = wc.record_id
               LEFT JOIN wra_forms_repeating_instruments v1 ON v1.record_id = e.record_id
               LEFT JOIN vw_wra_poc vwp on v1.record_id = vwp.record_id
               LEFT JOIN vw_wra_pregnancy_details_v1 pv1 on vwp.record_id = pv1.record_id
      WHERE v1.wra_enr_pp_avail = 1
        AND vwp.visit_number = 1.0
        AND vwp.upt_result = 'Positive'
        AND pv1.zapps_referral_acceptance = 'Yes'
      UNION
      SELECT DISTINCT e.record_id,
                      e.screening_id,
                      v2.wra_fu_visit_date                                                         as visit_date,
                      2.0                                                                          as visit_number,
                      v2.wra_fu_interviewer_obsloc                                                 as refferring_staff,
                      e.wra_ptid,
                      REPLACE(CONCAT_WS(' ', e.first_name, e.middle_name, e.last_name), '  ', ' ') as wra_name,
                      e.age,
                      COALESCE(
                              wc.wra_first_contact_v4,
                              wc.wra_first_contact_v3,
                              wc.wra_first_contact_v2,
                              wc.wra_first_contact_v1
                      )                                                                            as first_contact_number,
                      l.first_contact_number_owner,
                      l.first_contact_number_caller_id,
                      COALESCE(
                              wc.wra_second_contact_v4,
                              wc.wra_second_contact_v3,
                              wc.wra_second_contact_v2,
                              wc.wra_second_contact_v1
                      )                                                                            as second_contact_number,
                      l.second_contact_number_owner,
                      l.second_contact_number_caller_id,
                      v2.wra_fu_pp_avail_label                                                     as is_wra_available,
                      vwp.upt_result,
                      vwp.pregnancy_id,
                      pv2.lmp_date,
                      v2.wra_fu_visit_date                                                         as date_of_1st_positive_upt,
                      pv2.zapps_referral_acceptance,
                      pv2.zapps_appointment_date,
                      CONCAT_WS('-', pv2.wra_ptid, pv2.zapps_appointment_date)                     as arch_zapps_id,
                      pv2.preferred_zapps_clinic
      FROM wra_follow_up_visit_repeating_instruments v2
               LEFT JOIN vw_wra_locator_details l ON v2.record_id = l.record_id
               LEFT JOIN crt_wra_contacts wc ON v2.record_id = wc.record_id
               LEFT JOIN vw_wra_baseline_visit_overview e ON v2.record_id = e.record_id
               LEFT JOIN vw_wra_poc vwp on v2.record_id = vwp.record_id
               LEFT JOIN vw_wra_pregnancy_details_v2 pv2 on vwp.record_id = pv2.record_id
      WHERE v2.wra_fu_pp_avail = 1
        AND vwp.visit_number = 2.0
        AND vwp.upt_result = 'Positive'
        AND pv2.zapps_referral_acceptance = 'Yes'
      UNION
      SELECT DISTINCT v3.record_id,
                      e.screening_id,
                      v3.scrn_obsstdat_f2                                                          as visit_date,
                      3.0                                                                          as visit_number,
                      v3.wra_enr_interviewer_obsloc_f2                                             as refferring_staff,
                      e.wra_ptid,
                      REPLACE(CONCAT_WS(' ', e.first_name, e.middle_name, e.last_name), '  ', ' ') as wra_name,
                      e.age,
                      COALESCE(
                              wc.wra_first_contact_v4,
                              wc.wra_first_contact_v3,
                              wc.wra_first_contact_v2,
                              wc.wra_first_contact_v1
                      )                                                                            as first_contact_number,
                      l.first_contact_number_owner,
                      l.first_contact_number_caller_id,
                      COALESCE(
                              wc.wra_second_contact_v4,
                              wc.wra_second_contact_v3,
                              wc.wra_second_contact_v2,
                              wc.wra_second_contact_v1
                      )                                                                            as second_contact_number,
                      l.second_contact_number_owner,
                      l.second_contact_number_caller_id,
                      v3.wra_enr_pp_avail_f2_label                                                 as is_wra_available,
                      vwp.upt_result,
                      vwp.pregnancy_id,
                      pv3.lmp_date,
                      v3.scrn_obsstdat_f2                                                          as date_of_1st_positive_upt,
                      pv3.zapps_referral_acceptance,
                      pv3.zapps_appointment_date,
                      CONCAT_WS('-', pv3.wra_ptid, pv3.zapps_appointment_date)                     as arch_zapps_id,
                      pv3.preferred_zapps_clinic
      FROM wra_follow_up_visit_2_repeating_instruments v3
               LEFT JOIN vw_wra_locator_details l ON v3.record_id = l.record_id
               LEFT JOIN crt_wra_contacts wc ON v3.record_id = wc.record_id
               LEFT JOIN vw_wra_baseline_visit_overview e ON v3.record_id = e.record_id
               LEFT JOIN vw_wra_poc vwp on v3.record_id = vwp.record_id
               LEFT JOIN vw_wra_pregnancy_details_v3 pv3 on vwp.record_id = pv3.record_id
      WHERE v3.wra_enr_pp_avail_f2 = 1
        AND vwp.visit_number = 3.0
        AND vwp.upt_result = 'Positive'
        AND pv3.zapps_referral_acceptance = 'Yes'
      UNION
      SELECT DISTINCT v4.record_id,
                      e.screening_id,
                      v4.wra_fu_visit_date_f3                                                      as visit_date,
                      4.0                                                                          as visit_number,
                      v4.wra_fu_interviewer_obsloc_f3                                              as refferring_staff,
                      e.wra_ptid,
                      REPLACE(CONCAT_WS(' ', e.first_name, e.middle_name, e.last_name), '  ', ' ') as wra_name,
                      e.age,
                      COALESCE(
                              wc.wra_first_contact_v4,
                              wc.wra_first_contact_v3,
                              wc.wra_first_contact_v2,
                              wc.wra_first_contact_v1
                      )                                                                            as first_contact_number,
                      l.first_contact_number_owner,
                      l.first_contact_number_caller_id,
                      COALESCE(
                              wc.wra_second_contact_v4,
                              wc.wra_second_contact_v3,
                              wc.wra_second_contact_v2,
                              wc.wra_second_contact_v1
                      )                                                                            as second_contact_number,
                      l.second_contact_number_owner,
                      l.second_contact_number_caller_id,
                      v4.wra_fu_pp_avail_f3_label                                                  as is_wra_available,
                      vwp.upt_result,
                      vwp.pregnancy_id,
                      pv4.lmp_date,
                      v4.wra_fu_visit_date_f3                                                      as date_of_1st_positive_upt,
                      pv4.zapps_referral_acceptance,
                      pv4.zapps_appointment_date,
                      CONCAT_WS('-', pv4.wra_ptid, pv4.zapps_appointment_date)                     as arch_zapps_id,
                      pv4.preferred_zapps_clinic
      FROM wra_follow_up_visit_3_repeating_instruments v4
               LEFT JOIN vw_wra_locator_details l ON v4.record_id = l.record_id
               LEFT JOIN crt_wra_contacts wc ON v4.record_id = wc.record_id
               LEFT JOIN vw_wra_baseline_visit_overview e ON v4.record_id = e.record_id
               LEFT JOIN vw_wra_poc vwp on v4.record_id = vwp.record_id
               LEFT JOIN vw_wra_pregnancy_details_v4 pv4 on vwp.record_id = pv4.record_id
      WHERE v4.wra_fu_pp_avail_f3 = 1
        AND vwp.visit_number = 4.0
        AND vwp.upt_result = 'Positive'
        AND pv4.zapps_referral_acceptance = 'Yes'
      UNION
      SELECT DISTINCT v5.record_id,
                      e.screening_id,
                      v5.wra_fu_visit_date_f4                                                      as visit_date,
                      5.0                                                                          as visit_number,
                      v5.wra_fu_interviewer_obsloc_f4                                              as refferring_staff,
                      e.wra_ptid,
                      REPLACE(CONCAT_WS(' ', e.first_name, e.middle_name, e.last_name), '  ', ' ') as wra_name,
                      e.age,
                      COALESCE(
                              wc.wra_first_contact_v5,
                              wc.wra_first_contact_v4,
                              wc.wra_first_contact_v3,
                              wc.wra_first_contact_v2,
                              wc.wra_first_contact_v1
                      )                                                                            as first_contact_number,
                      l.first_contact_number_owner,
                      l.first_contact_number_caller_id,
                      COALESCE(
                              wc.wra_second_contact_v5,
                              wc.wra_second_contact_v4,
                              wc.wra_second_contact_v3,
                              wc.wra_second_contact_v2,
                              wc.wra_second_contact_v1
                      )                                                                            as second_contact_number,
                      l.second_contact_number_owner,
                      l.second_contact_number_caller_id,
                      v5.wra_fu_pp_avail_f4_label                                                  as is_wra_available,
                      vwp.upt_result,
                      vwp.pregnancy_id,
                      pv5.lmp_date,
                      v5.wra_fu_visit_date_f4                                                      as date_of_1st_positive_upt,
                      pv5.zapps_referral_acceptance,
                      pv5.zapps_appointment_date,
                      CONCAT_WS('-', pv5.wra_ptid, pv5.zapps_appointment_date)                     as arch_zapps_id,
                      pv5.preferred_zapps_clinic
      FROM wra_follow_up_visit_4_repeating_instruments v5
               LEFT JOIN vw_wra_locator_details l ON v5.record_id = l.record_id
               LEFT JOIN crt_wra_contacts wc ON v5.record_id = wc.record_id
               LEFT JOIN vw_wra_baseline_visit_overview e ON v5.record_id = e.record_id
               LEFT JOIN vw_wra_poc vwp on v5.record_id = vwp.record_id
               LEFT JOIN vw_wra_pregnancy_details_v5 pv5 on vwp.record_id = pv5.record_id
      WHERE v5.wra_fu_pp_avail_f4 = 1
        AND vwp.visit_number = 5.0
        AND vwp.upt_result = 'Positive'
        AND pv5.zapps_referral_acceptance = 'Yes') z
ORDER BY z.visit_date DESC;

