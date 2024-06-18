/**
 * List of WRA Pregnancy Details for Visit 2.0.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 24.06.24
 * @since 0.0.1
 * @alias WRA Pregnancy Details 2.0
 */
CREATE OR REPLACE ALGORITHM = MERGE VIEW vw_wra_pregnancy_details_v2
AS
SELECT DISTINCT e.record_id,
                TRIM(e.screening_id)                                                   as screening_id,
                e.member_id,
                e.screening_date                                                       as date_of_enrollment,
                ps.ps_fu_visit_date                                                    as visit_date,
                TRIM(e.wra_ptid)                                                       as wra_ptid,
                REPLACE(CONCAT_WS(' ', TRIM(e.first_name), TRIM(e.middle_name), TRIM(e.last_name)), '  ',
                        ' ')                                                           as wra_name,
                e.age                                                                  as age,
    /* Pregnancy Surveillance Data */
                IF(ps.fu_lmp_reg_scorres <=> 1, 'Yes',
                   IF(ps.fu_lmp_reg_scorres <=> 0, 'No', ps.fu_lmp_reg_scorres))       as currently_has_reg_menstruals,
                IF(ps.fu_lmp_kd_scorres <=> 96,
                   CONCAT_WS(' - ', ps.fu_lmp_kd_scorres_label, ps.lmp_kd_scorres_othr),
                   ps.fu_lmp_kd_scorres_label)                                         as no_current_menstruals_reason,
                ps.fu_lmp_scdat                                                        as lmp_date,
                COALESCE(CONCAT_WS(' ', ps.fu_lmp_start_weeks, IF(ps.fu_lmp_start_weeks IS NOT NULL, 'weeks', '')),
                         CONCAT_WS(' ', ps.fu_lmp_start_months, IF(ps.fu_lmp_start_months IS NOT NULL, 'months', '')),
                         CONCAT_WS(' ', ps.fu_lmp_start_years, IF(ps.fu_lmp_start_years IS NOT NULL, 'years', '')),
                         ps.fu_lmp_cat_scorres)                                        as est_lmp,
                ps.fu_preg_scorres_label                                               as currently_pregnant,
                ps.fu_month_preg_scorres                                               as pregnance_duration_months,
                -- New Pregnancy rows
                ps.fu_np_pregid_mhyn_label                                             as pregnancy_identifier,
                COALESCE(ps.fu_np_date_of_test, ps.fu_np_date_of_test_2, ps.fu_np_us_test_dat,
                         ps.fu_np_bld_test_dat)                                        as pregnancy_test_date,
                ps.fu_np_us_edd_dat                                                    as edd,
                pa.np_fu_zapps_scorres_label                                           as zapps_enrollment_status,
                pa.np_fu_zapps_ptid                                                    as zapps_ptid,
                IF(pa.np_fu_ident_arch <=> 1, 'Yes',
                   IF(pa.np_fu_ident_arch <=> 0, 'No', pa.np_fu_ident_arch))           as identified_by_arch,
                -- *-0----\_______________________| Danger Signs Dictionary (K,V) |________________________/------0-* --
                -- *-0-----\`~`~`~ Mapping of dangers signs key-value pairs taking into account the `~`~`~/-------0-* --
                -- *-0------\`~`~` the multiple value selection of signs; using mysql json notation. ~`~`/--------0-* --
                JSON_OBJECT(
                        's1_bleeding', pa.np_fu_ptw___1_label, -- "s1_bleeding": "Bleeding"
                        's2_fits', pa.np_fu_ptw___2_label, -- "s2_fits": "Having fits"
                        's3_swelling', pa.np_fu_ptw___3_label, -- "s3_swelling": "Swelling of feet and hands"
                        's4_temperature', pa.np_fu_ptw___4_label, -- "s4_temperature": "Body hotness or feeling cold"
                        's5_mobility', pa.np_fu_ptw___5_label, -- "s5_mobility": "WRA not moving or moving less"
                        's6_appearance', pa.np_fu_ptw___6_label, -- "s6_appearance": "Looking pale or extreme tiredness"
                        's7_none', pa.np_fu_ptw___7_label -- "s7_none": "None"
                    )                                                                  as pregnancy_danger_signs,
                IF(pa.np_fu_anc_mhyn <=> 1, 'Yes',
                   IF(pa.np_fu_anc_mhyn <=> 0, 'No', pa.np_fu_anc_mhyn))               as has_antenatal_visit,
                pa.np_fu_anc_num_mh                                                    as antenatal_visit_count,
                pa.np_fu_anc1_dat                                                      as first_antenatal_visit_date,
                COALESCE(
                        CONCAT_WS(' ', pa.fu_anc1_ga_weeks, IF(pa.fu_anc1_ga_weeks IS NOT NULL, 'weeks', '')),
                        CONCAT_WS(' ', pa.fu_anc1_ga_months, IF(pa.fu_anc1_ga_months IS NOT NULL, 'months', '')),
                        pa.np_fu_anc1_ga_label
                    )                                                                  as pregnancy_duration_first_anc_visit,
                IF(pa.np_fu_anc_plan_obsloc <=> 1, 'Yes',
                   IF(pa.np_fu_anc_plan_obsloc <=> 0, 'No', pa.np_fu_anc_plan_obsloc)) as antenatal_visit_planning,
                IF(pa.fu_birth_plan_fac_obsloc <=> 88,
                   CONCAT_WS(' - ', pa.fu_birth_plan_fac_obsloc_label, pa.fu_birth_other_loc),
                   IF(pa.fu_birth_plan_fac_obsloc <=> 1,
                      pa.fu_facility_other_label, pa.fu_birth_plan_fac_obsloc_label))  as birth_plan,
                IF(pa.np_fu_alc_suyn <=> 1, 'Yes',
                   IF(pa.np_fu_alc_suyn <=> 0, 'No', pa.np_fu_alc_suyn))               as alc_consuption_during_pregnancy,
                pa.np_fu_alc_cons_label                                                as alcohol_consumption_freq,
                IF(pa.np_fu_tob_suyn <=> 1, 'Yes',
                   IF(pa.np_fu_tob_suyn <=> 0, 'No', pa.np_fu_tob_suyn))               as tobacco_use_during_pregnancy,
                pa.np_fu_tob_curr_sudosfrq_label                                       as tobacco_usage_freq,
                JSON_OBJECT(
                        't1_pipes', pa.fu_tob_oth_stutrt___1_label,
                        't2_cigars_cigarillos', pa.fu_tob_oth_stutrt___2_label,
                        't3_water_pipe', pa.fu_tob_oth_stutrt___3_label,
                        't4_mouth_snuff', pa.fu_tob_oth_stutrt___4_label,
                        't5_nose_snuff', pa.fu_tob_oth_stutrt___5_label,
                        't6_chewing', pa.fu_tob_oth_stutrt___6_label,
                        't7_other', CONCAT_WS(' - ', pa.fu_tob_oth_stutrt___7_label, pa.np_fu_drug_sutrt_othr)
                    )                                                                  as other_tobacco_usage,
                IF(pa.np_fu_drug_suyn <=> 1, 'Yes',
                   IF(pa.np_fu_drug_suyn <=> 0, 'No', pa.np_fu_drug_suyn))             as drug_usage_hx_during_pregnancy,
                pa.np_fu_drug_usage_label                                              as drug_usage_during_pregnancy,
                JSON_OBJECT(
                        'd1_marijuana', pa.np_fu_drug_sutrt___1_label,
                        'd2_bostik', pa.np_fu_drug_sutrt___2_label,
                        'd3_cocaine', pa.np_fu_drug_sutrt___3_label,
                        'd4_codeine', pa.np_fu_drug_sutrt___4_label,
                        'd5_heroin', pa.np_fu_drug_sutrt___5_label,
                        'd6_blue_mash', pa.np_fu_drug_sutrt___6_label,
                        'd7_other', CONCAT_WS(' - ', pa.np_fu_drug_sutrt___7_label, pa.np_fu_drug_sutrt_othr)
                    )                                                                  as drug_name,
                -- ZAPPS referral rows
                IF(pa.fu_ref_likely_scorres <=> 1, 'Yes',
                   IF(pa.fu_ref_likely_scorres <=> 0, 'No', pa.fu_ref_likely_scorres)) as zapps_referral_acceptance,
                JSON_OBJECT(
                        'z1_anc_care', pa.fu_ref_res_decline___1_label,
                        'z2_advanced_ga', pa.fu_ref_res_decline___2_label,
                        'z3_clinic_distance', pa.fu_ref_res_decline___3_label,
                        'z4_pregnancy_disclosure', pa.fu_ref_res_decline___4_label,
                        'z5_loss_fam_support', pa.fu_ref_res_decline___5_label,
                        'z6_other', CONCAT_WS(' - ', pa.fu_ref_res_decline___6_label, pa.zr_fu_reas_other)
                    )                                                                  as zapps_referral_reason_denied,
                pa.zr_fu_pref_zapps_scorres_label                                      as preferred_zapps_clinic,
                pa.zr_fu_apnt_dat_scorres                                              as zapps_appointment_date
FROM vw_wra_baseline_visit_overview e
         LEFT JOIN wrafu_pregnancy_surveillance ps on e.record_id = ps.record_id
         LEFT JOIN wrafu_pregnancy_assessments pa ON e.record_id = pa.record_id
         JOIN visit v ON pa.redcap_event_name = v.visit_name
WHERE e.age > 0
  AND ps.ps_fu_visit_date IS NOT NULL
  AND v.visit_number = 2.0
ORDER BY e.screening_id;

