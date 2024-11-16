/**
 * List of WRA Pregnancy Details for Visit 4.0.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 12.11.24
 * @since 0.0.1
 * @alias WRA Pregnancy Details 5.0
 */
CREATE OR REPLACE ALGORITHM = MERGE VIEW vw_wra_pregnancy_details_v5
AS
SELECT DISTINCT e.record_id,
                v.visit_id,
                v.visit_number,
                v.visit_alias,
                TRIM(e.screening_id)                                                        as screening_id,
                e.member_id,
                ps.ps_fu_visit_date_f4                                                      as visit_date,
                e.screening_date                                                            as date_of_enrollment,
                TRIM(e.wra_ptid)                                                            as wra_ptid,
                REPLACE(CONCAT_WS(' ', TRIM(e.first_name), TRIM(e.middle_name), TRIM(e.last_name)), '  ',
                        ' ')                                                                as wra_name,
                e.age                                                                       as age,
    /* Pregnancy Surveillance Data */
                IF(ps.fu_lmp_reg_scorres_f4 <=> 1, 'Yes',
                   IF(ps.fu_lmp_reg_scorres_f4 <=> 0, 'No', ps.fu_lmp_reg_scorres_f4))      as currently_has_reg_menstruals,
                IF(ps.fu_lmp_kd_scorres_f4 <=> 96,
                   CONCAT_WS(' - ', ps.fu_lmp_kd_scorres_f4_label, ps.lmp_kd_scorres_othr_f4),
                   ps.fu_lmp_kd_scorres_f4_label)                                           as no_current_menstruals_reason,
                ps.fu_lmp_scdat_f4                                                          as lmp_date,
                COALESCE(
                        CONCAT_WS(' ', ps.fu_lmp_start_weeks_f4, IF(ps.fu_lmp_start_weeks_f4 IS NOT NULL, 'weeks', '')),
                        CONCAT_WS(' ', ps.fu_lmp_start_months_f4,
                                  IF(ps.fu_lmp_start_months_f4 IS NOT NULL, 'months', '')),
                        CONCAT_WS(' ', ps.fu_lmp_start_years_f4, IF(ps.fu_lmp_start_years_f4 IS NOT NULL, 'years', '')),
                        ps.fu_lmp_cat_scorres_f4)                                           as est_lmp,
                ps.fu_preg_scorres_f4_label                                                 as currently_pregnant,
                ps.fu_month_preg_scorres_f4                                                 as pregnance_duration_months,
                -- New Pregnancy rows
                ps.fu_np_pregid_mhyn_f4_label                                               as pregnancy_identifier,
                COALESCE(ps.fu_np_date_of_test_f4, ps.fu_np_date_of_test_2_f4, ps.fu_np_us_test_dat_f4,
                         ps.fu_np_bld_test_dat_f4)                                          as pregnancy_test_date,
                ps.fu_np_us_edd_dat_f4                                                      as edd,
                pa.np_fu_zapps_scorres_f4_label                                             as zapps_enrollment_status,
                pa.np_fu_zapps_ptid_f4                                                      as zapps_ptid,
                IF(pa.np_fu_ident_arch_f4 <=> 1, 'Yes',
                   IF(pa.np_fu_ident_arch_f4 <=> 0, 'No', pa.np_fu_ident_arch_f4))          as identified_by_arch,
                -- *-0----\_______________________| Danger Signs Dictionary (K,V) |________________________/------0-* --
                -- *-0-----\`~`~`~ Mapping of dangers signs key-value pairs taking into account the `~`~`~/-------0-* --
                -- *-0------\`~`~` the multiple value selection of signs; using mysql json notation. ~`~`/--------0-* --
                JSON_OBJECT(
                        's1_bleeding', pa.np_fu_ptw_f4___1_label, -- "s1_bleeding": "Bleeding"
                        's2_fits', pa.np_fu_ptw_f4___2_label, -- "s2_fits": "Having fits"
                        's3_swelling', pa.np_fu_ptw_f4___3_label, -- "s3_swelling": "Swelling of feet and hands"
                        's4_temperature', pa.np_fu_ptw_f4___4_label, -- "s4_temperature": "Body hotness or feeling cold"
                        's5_mobility', pa.np_fu_ptw_f4___5_label, -- "s5_mobility": "WRA not moving or moving less"
                        's6_appearance',
                        pa.np_fu_ptw_f4___6_label, -- "s6_appearance": "Looking pale or extreme tiredness"
                        's7_none', pa.np_fu_ptw_f4___7_label -- "s7_none": "None"
                    )                                                                       as pregnancy_danger_signs,
                IF(pa.np_fu_anc_mhyn_f4 <=> 1, 'Yes',
                   IF(pa.np_fu_anc_mhyn_f4 <=> 0, 'No', pa.np_fu_anc_mhyn_f4))              as has_antenatal_visit,
                pa.np_fu_anc_num_mh_f4                                                      as antenatal_visit_count,
                pa.np_fu_anc1_dat_f4                                                        as first_antenatal_visit_date,
                COALESCE(
                        CONCAT_WS(' ', pa.fu_anc1_ga_weeks_f4, IF(pa.fu_anc1_ga_weeks_f4 IS NOT NULL, 'weeks', '')),
                        CONCAT_WS(' ', pa.fu_anc1_ga_months_f4, IF(pa.fu_anc1_ga_months_f4 IS NOT NULL, 'months', '')),
                        pa.np_fu_anc1_ga_f4_label
                    )                                                                       as pregnancy_duration_first_anc_visit,
                IF(pa.np_fu_anc_plan_obsloc_f4 <=> 1, 'Yes',
                   IF(pa.np_fu_anc_plan_obsloc_f4 <=> 0, 'No',
                      pa.np_fu_anc_plan_obsloc_f4))                                         as antenatal_visit_planning,
                IF(pa.fu_birth_plan_fac_obsloc_f4 <=> 88,
                   CONCAT_WS(' - ', pa.fu_birth_plan_fac_obsloc_f4_label, pa.fu_birth_other_loc_f4),
                   IF(pa.fu_birth_plan_fac_obsloc_f4 <=> 1,
                      pa.fu_facility_other_f4_label, pa.fu_birth_plan_fac_obsloc_f4_label)) as birth_plan,
                IF(pa.np_fu_alc_suyn_f4 <=> 1, 'Yes',
                   IF(pa.np_fu_alc_suyn_f4 <=> 0, 'No', pa.np_fu_alc_suyn_f4))              as alc_consuption_during_pregnancy,
                pa.np_fu_alc_cons_f4_label                                                  as alcohol_consumption_freq,
                IF(pa.np_fu_tob_suyn_f4 <=> 1, 'Yes',
                   IF(pa.np_fu_tob_suyn_f4 <=> 0, 'No', pa.np_fu_tob_suyn_f4))              as tobacco_use_during_pregnancy,
                pa.np_fu_tob_curr_sudosfrq_f4_label                                         as tobacco_usage_freq,
                JSON_OBJECT(
                        't1_pipes', pa.fu_tob_oth_stutrt_f4___1_label,
                        't2_cigars_cigarillos', pa.fu_tob_oth_stutrt_f4___2_label,
                        't3_water_pipe', pa.fu_tob_oth_stutrt_f4___3_label,
                        't4_mouth_snuff', pa.fu_tob_oth_stutrt_f4___4_label,
                        't5_nose_snuff', pa.fu_tob_oth_stutrt_f4___5_label,
                        't6_chewing', pa.fu_tob_oth_stutrt_f4___6_label,
                        't7_other', CONCAT_WS(' - ', pa.fu_tob_oth_stutrt_f4___7_label, pa.fu_other_tbc_use_f4)
                    )                                                                       as other_tobacco_usage,
                IF(pa.np_fu_drug_suyn_f4 <=> 1, 'Yes',
                   IF(pa.np_fu_drug_suyn_f4 <=> 0, 'No', pa.np_fu_drug_suyn_f4))            as drug_usage_hx_during_pregnancy,
                pa.np_fu_drug_usage_f4_label                                                as drug_usage_during_pregnancy,
                JSON_OBJECT(
                        'd1_marijuana', pa.np_fu_drug_sutrt_f4___1_label,
                        'd2_bostik', pa.np_fu_drug_sutrt_f4___2_label,
                        'd3_cocaine', pa.np_fu_drug_sutrt_f4___3_label,
                        'd4_codeine', pa.np_fu_drug_sutrt_f4___4_label,
                        'd5_heroin', pa.np_fu_drug_sutrt_f4___5_label,
                        'd6_blue_mash', pa.np_fu_drug_sutrt_f4___6_label,
                        'd7_other', CONCAT_WS(' - ', pa.np_fu_drug_sutrt_f4___7_label, pa.np_fu_drug_sutrt_othr_f4)
                    )                                                                       as drug_name,
                -- ZAPPS referral rows
                IF(pa.fu_ref_likely_scorres_f4 <=> 1, 'Yes',
                   IF(pa.fu_ref_likely_scorres_f4 <=> 0, 'No',
                      pa.fu_ref_likely_scorres_f4))                                         as zapps_referral_acceptance,
                JSON_OBJECT(
                        'z1_anc_care', pa.fu_ref_res_decline_f4___1_label,
                        'z2_advanced_ga', pa.fu_ref_res_decline_f4___2_label,
                        'z3_clinic_distance', pa.fu_ref_res_decline_f4___3_label,
                        'z4_pregnancy_disclosure', pa.fu_ref_res_decline_f4___4_label,
                        'z5_loss_fam_support', pa.fu_ref_res_decline_f4___5_label,
                        'z6_other', CONCAT_WS(' - ', pa.fu_ref_res_decline_f4___6_label, pa.zr_fu_reas_other_f4)
                    )                                                                       as zapps_referral_reason_denied,
                pa.zr_fu_pref_zapps_scorres_f4_label                                        as preferred_zapps_clinic,
                pa.zr_fu_apnt_dat_scorres_f4                                                as zapps_appointment_date
FROM vw_wra_baseline_visit_overview e
         LEFT JOIN wrafu_pregnancy_surveillance_4 ps on e.record_id = ps.record_id
         LEFT JOIN wrafu_pregnancy_assessments_4 pa ON e.record_id = pa.record_id
         JOIN visit v ON pa.redcap_event_name = v.visit_name
WHERE e.age > 0
  AND ps.ps_fu_visit_date_f4 IS NOT NULL
  AND v.visit_number = 5.0
ORDER BY e.screening_id;

