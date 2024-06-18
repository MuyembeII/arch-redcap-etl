/**
 * List of WRA Pregnancy Details for Visit 1.0.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 24.06.24
 * @since 0.0.1
 * @alias WRA Pregnancy Details 1.0
 */
CREATE OR REPLACE ALGORITHM = MERGE VIEW vw_wra_pregnancy_details_v1
AS
SELECT DISTINCT enr.record_id,
                v.visit_id,
                v.visit_number,
                v.visit_alias,
                enr.screening_id                                                 as screening_id,
                enr.member_id,
                enr.screening_date                                               as date_of_enrollment,
                enr.wra_ptid,
                REPLACE(CONCAT_WS(' ',
                                  enr.first_name, enr.middle_name, enr.last_name
                            ), '  ', ' ')                                        as wra_name,
                enr.age                                                          as age,
                /* Pregnancy Surveillance Data */
                IF(pos.lmp_reg_scorres <=> 1, 'Yes',
                   IF(pos.lmp_reg_scorres <=> 0, 'No', pos.lmp_reg_scorres))     as currently_has_reg_menstruals,
                IF(pos.lmp_kd_scorres <=> 96,
                   CONCAT_WS(' - ', pos.lmp_kd_scorres_label, pos.lmp_kd_scorres_other),
                   pos.lmp_kd_scorres_label)                                     as no_current_menstruals_reason,
                pos.lmp_scdat                                                    as lmp_date,
                COALESCE(CONCAT_WS(' ', pos.lmp_start_weeks, IF(pos.lmp_start_weeks IS NOT NULL, 'weeks', '')),
                         CONCAT_WS(' ', pos.lmp_start_months, IF(pos.lmp_start_months IS NOT NULL, 'months', '')),
                         CONCAT_WS(' ', pos.lmp_start_years, IF(pos.lmp_start_years IS NOT NULL, 'years', '')),
                         pos.lmp_cat_scorres)                                    as est_lmp,
                pos.preg_scorres_label                                           as currently_pregnant,
                pos.months_preg_scorres                                          as pregnance_duration_months,
                -- New Pregnancy rows
                pos.np_pregid_mhyn_label                                         as pregnancy_identifier,
                COALESCE(pos.np_date_of_test, pos.np_date_of_test_2, pos.np_us_test_dat,
                         pos.np_bld_test_dat)                                    as pregnancy_test_date,
                pos.np_us_edd_dat                                                as edd,
                pa.np_zapps_scorres_label                                        as zapps_enrollment_status,
                pa.np_zapps_ptid                                                 as zapps_ptid,
                IF(pa.np_ident_arch <=> 1, 'Yes',
                   IF(pa.np_ident_arch <=> 0, 'No', pa.np_ident_arch))           as identified_by_arch,
                -- *-0----\_______________________| Danger Signs Dictionary (K,V) |________________________/------0-* --
                -- *-0-----\`~`~`~ Mapping of dangers signs key-value pairs taking into account the `~`~`~/-------0-* --
                -- *-0------\`~`~` the multiple value selection of signs; using mysql json notation. ~`~`/--------0-* --
                JSON_OBJECT(
                        's1_bleeding', pa.np_ptw___1_label, -- "s1_bleeding": "Bleeding"
                        's2_fits', pa.np_ptw___2_label, -- "s2_fits": "Having fits"
                        's3_swelling', pa.np_ptw___3_label, -- "s3_swelling": "Swelling of feet and hands"
                        's4_temperature', pa.np_ptw___4_label, -- "s4_temperature": "Body hotness or feeling cold"
                        's5_mobility', pa.np_ptw___5_label, -- "s5_mobility": "WRA not moving or moving less"
                        's6_appearance', pa.np_ptw___6_label, -- "s6_appearance": "Looking pale or extreme tiredness"
                        's7_none', pa.np_ptw___7_label -- "s7_none": "None"
                    )                                                            as pregnancy_danger_signs,
                IF(pa.np_anc_mhyn <=> 1, 'Yes',
                   IF(pa.np_anc_mhyn <=> 0, 'No', pa.np_anc_mhyn))               as has_antenatal_visit,
                pa.np_anc_num_mh                                                 as antenatal_visit_count,
                pa.np_anc1_dat                                                   as first_antenatal_visit_date,
                COALESCE(
                        CONCAT_WS(' ', pa.anc1_ga_weeks, IF(pa.anc1_ga_weeks IS NOT NULL, 'weeks', '')),
                        CONCAT_WS(' ', pa.anc1_ga_months, IF(pa.anc1_ga_months IS NOT NULL, 'months', '')),
                        pa.np_anc1_ga_label
                    )                                                            as pregnancy_duration_first_anc_visit,
                IF(pa.np_anc_plan_obsloc <=> 1, 'Yes',
                   IF(pa.np_anc_plan_obsloc <=> 0, 'No', pa.np_anc_plan_obsloc)) as antenatal_visit_planning,
                IF(pa.birth_plan_fac_obsloc <=> 88,
                   CONCAT_WS(' - ', pa.birth_plan_fac_obsloc_label, pa.birth_other_loc),
                   IF(pa.birth_plan_fac_obsloc <=> 1,
                      pa.facility_other_label, pa.birth_plan_fac_obsloc_label))  as birth_plan,
                IF(pa.np_alc_suyn <=> 1, 'Yes',
                   IF(pa.np_alc_suyn <=> 0, 'No', pa.np_alc_suyn))               as alc_consuption_during_pregnancy,
                pa.np_alc_cons_label                                             as alcohol_consumption_freq,
                IF(pa.np_tob_suyn <=> 1, 'Yes',
                   IF(pa.np_tob_suyn <=> 0, 'No', pa.np_tob_suyn))               as tobacco_use_during_pregnancy,
                pa.np_tob_cur_sudosfrq_label                                     as tobacco_usage_freq,
                JSON_OBJECT(
                        't1_pipes', pa.tob_oth_sutrt___1_label,
                        't2_cigars_cigarillos', pa.tob_oth_sutrt___2_label,
                        't3_water_pipe', pa.tob_oth_sutrt___3_label,
                        't4_mouth_snuff', pa.tob_oth_sutrt___4_label,
                        't5_nose_snuff', pa.tob_oth_sutrt___5_label,
                        't6_chewing', pa.tob_oth_sutrt___6_label,
                        't7_other', CONCAT_WS(' - ', pa.tob_oth_sutrt___7_label, pa.other_tbc_use)
                    )                                                            as other_tobacco_usage,
                IF(pa.np_drug_suyn <=> 1, 'Yes',
                   IF(pa.np_drug_suyn <=> 0, 'No', pa.np_drug_suyn))             as drug_usage_hx_during_pregnancy,
                pa.np_drug_usage_label                                           as drug_usage_during_pregnancy,
                JSON_OBJECT(
                        'd1_marijuana', pa.np_drug_sutrt___1_label,
                        'd2_bostik', pa.np_drug_sutrt___2_label,
                        'd3_cocaine', pa.np_drug_sutrt___3_label,
                        'd4_codeine', pa.np_drug_sutrt___4_label,
                        'd5_heroin', pa.np_drug_sutrt___5_label,
                        'd6_blue_mash', pa.np_drug_sutrt___6_label,
                        'd7_other', CONCAT_WS(' - ', pa.np_drug_sutrt___7_label, pa.np_drug_sutrt_othr)
                    )                                                            as drug_name,
                -- ZAPPS referral rows
                IF(pa.ref_likely_scorres <=> 1, 'Yes',
                   IF(pa.ref_likely_scorres <=> 0, 'No', pa.ref_likely_scorres)) as zapps_referral_acceptance,
                JSON_OBJECT(
                        'z1_anc_care', pa.ref_res_decline___1_label,
                        'z2_advanced_ga', pa.ref_res_decline___2_label,
                        'z3_clinic_distance', pa.ref_res_decline___3_label,
                        'z4_pregnancy_disclosure', pa.ref_res_decline___4_label,
                        'z5_loss_fam_support', pa.ref_res_decline___5_label,
                        'z6_other', CONCAT_WS(' - ', pa.ref_res_decline___6_label, pa.zr_2_other)
                    )                                                            as zapps_referral_reason_denied,
                pa.pref_zapps_scorres_label                                      as preferred_zapps_clinic,
                pa.apnt_dat_scorres                                              as zapps_appointment_date
FROM vw_wra_baseline_visit_overview enr
         LEFT JOIN wra_pregnancy_overview_and_surveillance pos ON enr.record_id = pos.record_id
         LEFT JOIN wra_pregnancy_assessments pa ON enr.record_id = pa.record_id
         JOIN visit v ON pos.redcap_event_name = v.visit_name
WHERE enr.age > 0
  AND pos.ph_prev_rporres IS NOT NULL
  AND pos.redcap_event_name = v.visit_name
  AND v.visit_number = 1.0
ORDER BY enr.screening_id;