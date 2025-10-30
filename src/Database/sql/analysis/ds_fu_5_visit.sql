-- Follow Up 5 Overview / Fifth Follow Up Visit
TRUNCATE arch_etl_db.arch_follow_up_5_visit_master;
SET time_zone = '+02:00';
INSERT INTO arch_etl_db.arch_follow_up_5_visit_master( id
                                                     , record_id
                                                     , visit_number
                                                     , visit_name
                                                     , visit_outcome
                                                     , hh_scrn_num_obsloc
                                                     , wra_enr_visit_count
                                                     , attempt_count
                                                     , hhe_hh_member_id
                                                     , scrn_obsstdat
                                                     , wra_enr_interviewer_obsloc
                                                     , wra_enr_hhh_pvc
                                                     , wra_enr_reas_decline
                                                     , wra_enr_pp_avail
                                                     , is_wra_avail_other
                                                     , wra_ptid
                                                     , c19vax_cmyn
                                                     , c19vax_cmtrt
                                                     , covid_scrn_3
                                                     , c19_lbperf
                                                     , covid_test_dt_range
                                                     , c19_lbdat
                                                     , c19_lborres
                                                     , fever_ceoccur
                                                     , cough_ceoccur
                                                     , shortbreath_ceoccur
                                                     , sorethroat_ceoccur
                                                     , fatigue_ceoccur
                                                     , myalgia_ceoccur
                                                     , anorexia_ceoccur
                                                     , nausea_ceoccur
                                                     , diarrhoea_ceoccur
                                                     , ageusia_ceoccur
                                                     , anosmia_ceoccur
                                                     , runnynose_ceoccur
                                                     , sneeze_ceoccur
                                                     , headache_ceoccur
                                                     , rash_ceoccur
                                                     , conjunct_ceoccur
                                                     , c19_contact_dx_ceoccur
                                                     , c19_contact_sx_ceoccur
                                                     , hh_member_id
                                                     , covid_scrn_9
                                                     , c19_zm_scorres
                                                     , covid_scrn_comments_yn
                                                     , covid_scrn_comments
                                                     , fu_loc_same_hh_lv
                                                     , wra_fu_cluster_prev
                                                     , wra_fu_sbn_prev
                                                     , wra_fu_hun_prev
                                                     , wra_fu_hhn_prev
                                                     , wra_fu_prev_screening_id
                                                     , wra_fu_hh_screening_id
                                                     , loc_fu_mig_to_scorres
                                                     , loc_fu_loc_known
                                                     , loc_fu_locality_name
                                                     , loc_fu_newloc_scorres_yn
                                                     , loc_fu_newloc_scorres
                                                     , loc_fu_newloc_landmark
                                                     , loc_fu_loc_landmarks
                                                     , loc_fu_loc_direction
                                                     , loc_fu_new_directions
                                                     , loc_fu_mig_dat_scorres
                                                     , loc_fc_num
                                                     , loc_pn_belongs_oth
                                                     , loc_who_is_caller
                                                     , loc_pn_belongs
                                                     , loc_sc_num
                                                     , loc_pn_belongs_2
                                                     , loc_pn_belongs_oth_2
                                                     , loc_who_is_caller_2
                                                     , loc_enrolled_zapps
                                                     , loc_zapps_ptid
                                                     , loc_zapps_ptid_src
                                                     , famliid_yn
                                                     , famli_id_scorres
                                                     , loc_famli_id_src
                                                     , loc_comments_yn
                                                     , loc_comments
                                                     , scdmar_scorres
                                                     , scd_agemar_scorres
                                                     , school_scorres
                                                     , sd_highest_edu_level
                                                     , school_yrs_scorres
                                                     , scd_occupation_scorres
                                                     , sd_approx_income_pay
                                                     , scd_mobile_fcorres
                                                     , scd_mh_tob_suyn
                                                     , scd_mh_tob_sudosfrq
                                                     , scd_tob_chew_sutrt
                                                     , scd_alc_suyn
                                                     , scd_comments_yn
                                                     , scd_comments
                                                     , hh_nofd_scorres
                                                     , hh_nofd_frq_scorres
                                                     , hh_nofd_sleep_scorres
                                                     , hh_nofd_sleep_frq_scorres
                                                     , hh_nofd_night_scorres
                                                     , hh_nofd_night_frq_scorres
                                                     , hfs_coyn
                                                     , hfs_coval
                                                     , lmp_reg_scorres
                                                     , lmp_kd_scorres
                                                     , lmp_kd_scorres_other
                                                     , lmp_start_scorres
                                                     , lmp_scdat
                                                     , lmp_cat_scorres
                                                     , lmp_start_weeks
                                                     , lmp_start_months
                                                     , lmp_start_years
                                                     , lmp_scorres
                                                     , ps_mens_cal_yn
                                                     , lmp_dt_rec_cal
                                                     , preg_scorres
                                                     , months_preg_scorres
                                                     , np_pregid_mhyn
                                                     , np_date_of_test
                                                     , np_date_of_test_2
                                                     , np_us_test_dat
                                                     , np_bld_test_dat
                                                     , ps_pregnancy_id
                                                     , np_us_edd_dat
                                                     , np_edd_src
                                                     , ps_fu_last_upt
                                                     , ps_fu_zapps_enr
                                                     , ps_fu_pregnancy_id
                                                     , ps_preg_last_visit
                                                     , ps_same_preg_lv
                                                     , ps_fu_danger_signs_1
                                                     , ps_fu_danger_signs_2
                                                     , ps_fu_danger_signs_3
                                                     , ps_fu_danger_signs_4
                                                     , ps_fu_danger_signs_5
                                                     , ps_fu_danger_signs_6
                                                     , ps_fu_danger_signs_7
                                                     , ps_preg_times
                                                     , preg_surv_comm
                                                     , preg_surv_commnts)
SELECT v6.alternate_id                             as id
     , v6.record_id
     , v6.visit_number
     , v6.visit_name
     , v6.visit_outcome
     , v6.screening_id                             as hh_scrn_num_obsloc
     , CAST(f5.redcap_repeat_instance as UNSIGNED) as wra_enr_visit_count
     , CAST(f5.fu_attempt_count_f5 as UNSIGNED)    as attempt_count
     , CAST(f5.hhe_hh_member_id_f5 as UNSIGNED)    as hhe_hh_member_id
     , f5.wra_fu_visit_date_f5                     as scrn_obsstdat
     , f5.wra_fu_interviewer_obsloc_f5             as wra_enr_interviewer_obsloc
     , f5.wra_fu_conf_consent_f5                   as wra_enr_hhh_pvc
     , f5.wra_fu_reas_decline_const_f5             as wra_enr_reas_decline
     , f5.wra_fu_pp_avail_f5                       as wra_enr_pp_avail
     , f5.wra_fu_is_wra_avail_other_f5             as is_wra_avail_other
     , v6.wra_ptid                                 as wra_ptid
     , f5.fu_c19vax_cmyn_f5                        as c19vax_cmyn
     , f5.fu_c19vax_cmtrt_f5                       as c19vax_cmtrt
     , f5.fu_covid_scrn_3_f5                       as covid_scrn_3
     , f5.fu_c19_lbperf_f5                         as c19_lbperf
     , ''                                          as covid_test_dt_range
     , f5.fu_c19_lbdat_f5                          as c19_lbdat
     , f5.fu_c19_lborres_f5                        as c19_lborres
     , f5.fu_fever_ceoccur_f5                      as fever_ceoccur
     , f5.fu_cough_ceoccur_f5                      as cough_ceoccur
     , f5.fu_shortbreath_ceoccur_f5                as shortbreath_ceoccur
     , f5.fu_sorethroat_ceoccur_f5                 as sorethroat_ceoccur
     , f5.fu_fatigue_ceoccur_f5                    as fatigue_ceoccur
     , f5.fu_myalgia_ceoccur_f5                    as myalgia_ceoccur
     , f5.fu_anorexia_ceoccur_f5                   as anorexia_ceoccur
     , f5.fu_nausea_ceoccur_f5                     as nausea_ceoccur
     , f5.fu_diarrhoea_ceoccur_f5                  as diarrhoea_ceoccur
     , f5.fu_ageusia_ceoccur_f5                    as ageusia_ceoccur
     , f5.fu_anosmia_ceoccur_f5                    as anosmia_ceoccur
     , f5.fu_runnynose_ceoccur_f5                  as runnynose_ceoccur
     , f5.fu_sneeze_ceoccur_f5                     as sneeze_ceoccur
     , f5.fu_headache_ceoccur_f5                   as headache_ceoccur
     , f5.fu_rash_ceoccur_f5                       as rash_ceoccur
     , f5.fu_conjunct_ceoccur_f5                   as conjunct_ceoccur
     , f5.fu_c19_contact_dx_ceoccur_f5             as c19_contact_dx_ceoccur
     , f5.fu_c19_contact_sx_ceoccur_f5             as c19_contact_sx_ceoccur
     , f5.fu_hh_member_id_f5                       as hh_member_id
     , f5.fu_covid_scrn_9_f5                       as covid_scrn_9
     , f5.fu_c19_zm_scorres_f5                     as c19_zm_scorres
     , f5.fu_covid_scrn_comments_yn_f5             as covid_scrn_comments_yn
     , f5.fu_covid_scrn_comments_f5                as covid_scrn_comments
     , f5.fu_loc_same_hh_lv_f5                     as fu_loc_same_hh_lv
     , f5.wra_fu_cluster_new_f5                    as wra_fu_cluster_prev
     , f5.wra_fu_sbn_new_f5                        as wra_fu_sbn_prev
     , f5.wra_fu_hun_new_f5                        as wra_fu_hun_prev
     , f5.wra_fu_hhn_new_f5                        as wra_fu_hhn_prev
     , f5.wra_fu_curr_screening_id_f5              as wra_fu_prev_screening_id
     , f5.wra_fu_hh_screening_id_f5                as wra_fu_hh_screening_id
     , f5.loc_fu_mig_to_scorres_f5                 as loc_fu_mig_to_scorres
     , f5.loc_fu_loc_known_f5                      as loc_fu_loc_known
     , f5.loc_fu_locality_name_f5                  as loc_fu_locality_name
     , f5.loc_fu_newloc_scorres_yn_f5              as loc_fu_newloc_scorres_yn
     , f5.loc_fu_newloc_scorres_f5                 as loc_fu_newloc_scorres
     , f5.loc_fu_newloc_landmark_f5                as loc_fu_newloc_landmark
     , f5.loc_fu_loc_landmarks_f5                  as loc_fu_loc_landmarks
     , f5.loc_fu_loc_direction_f5                  as loc_fu_loc_direction
     , f5.loc_fu_new_directions_f5                 as loc_fu_new_directions
     , f5.loc_fu_mig_dat_scorres_f5                as loc_fu_mig_dat_scorres
     , f5.loc_fu_fc_corr_f5                        as loc_fc_num
     , f5.loc_fu_pn_belongs_othr_f5                as loc_pn_belongs_oth
     , f5.loc_fu_who_is_caller_f5                  as loc_who_is_caller
     , f5.loc_fu_pn_belongs_f5                     as loc_pn_belongs
     , f5.loc_fu_fc_corr_2_f5                      as loc_sc_num
     , f5.loc_fu_pn_belongs_2_f5                   as loc_pn_belongs_2
     , f5.loc_fu_pn_belongs_othr_2_f5              as loc_pn_belongs_oth_2
     , f5.loc_fu_who_is_caller_2_f5                as loc_who_is_caller_2
     , f5.loc_fu_enrolled_zapps_f5                 as loc_enrolled_zapps
     , f5.loc_fu_zapps_ptid_f5                     as loc_zapps_ptid
     , f5.loc_fu_zapps_ptid_src_f5                 as loc_zapps_ptid_src
     , f5.fu_famliid_yn_f5                         as famliid_yn
     , f5.fu_famli_id_scorres_f5                   as famli_id_scorres
     , f5.fu_famli_id_scorres_f5                   as loc_famli_id_src
     , f5.wra_fu_comments_yn_f5                    as loc_comments_yn
     , f5.wra_fu_comments_f5                       as loc_comments
     , f5.fu_scdmar_scorres_f5                     as scdmar_scorres
     , f5.scd_fu_agemar_scorres_f5                 as scd_agemar_scorres
     , f5.fu_school_scorres_f5                     as school_scorres
     , f5.fu_sd_highest_edu_level_f5               as sd_highest_edu_level
     , f5.fu_school_yrs_scorres_f5                 as school_yrs_scorres
     , f5.fu_scd_occupation_scorres_f5             as scd_occupation_scorres
     , f5.fu_sd_approx_income_pay_f5               as sd_approx_income_pay
     , f5.fu_scd_mobile_fcorres_f5                 as scd_mobile_fcorres
     , f5.fu_scd_mh_tob_suyn_f5                    as scd_mh_tob_suyn
     , f5.fu_scd_mh_tob_sudosfrq_f5                as scd_mh_tob_sudosfrq
     , f5.fu_scd_tob_chew_sutrt_f5                 as scd_tob_chew_sutrt
     , f5.fu_scd_alc_suyn_f5                       as scd_alc_suyn
     , f5.fu_scd_comments_yn_f5                    as scd_comments_yn
     , f5.fu_scd_comments_f5                       as scd_comments
     , f5.fu_hh_nofd_scorres_f5                    as hh_nofd_scorres
     , f5.fu_hh_nofd_frq_scorres_f5                as hh_nofd_frq_scorres
     , f5.fu_hh_nofd_sleep_scorres_f5              as hh_nofd_sleep_scorres
     , f5.fu_hh_nofd_sleep_frq_f5                  as hh_nofd_sleep_frq_scorres
     , f5.fu_hh_nofd_night_scorres_f5              as hh_nofd_night_scorres
     , f5.fu_hh_nofd_night_scorres_f5              as hh_nofd_night_frq_scorres
     , f5.fu_hfs_coyn_f5                           as hfs_coyn
     , f5.fu_hfs_coval_f5                          as hfs_coval
     , ps.fu_lmp_reg_scorres_f5                    as lmp_reg_scorres
     , ps.fu_lmp_kd_scorres_f5                     as lmp_kd_scorres
     , ps.lmp_kd_scorres_othr_f5                   as lmp_kd_scorres_other
     , ps.fu_lmp_start_scorres_f5                  as lmp_start_scorres
     , ps.fu_lmp_scdat_f5                          as lmp_scdat
     , ps.fu_lmp_cat_scorres_f5                    as lmp_cat_scorres
     , ps.fu_lmp_start_weeks_f5                    as lmp_start_weeks
     , ps.fu_lmp_start_months_f5                   as lmp_start_months
     , ps.fu_lmp_start_years_f5                    as lmp_start_years
     , ps.fu_lmp_scorres_f5                        as lmp_scorres
     , ps.fu_ps_mens_cal_yn_f5                     as ps_mens_cal_yn
     , ps.fu_lmp_dt_rec_cal_f5                     as lmp_dt_rec_cal
     , ps.fu_preg_scorres_f5                       as preg_scorres
     , ps.fu_month_preg_scorres_f5                 as months_preg_scorres
     , ps.fu_np_pregid_mhyn_f5                     as np_pregid_mhyn
     , ps.fu_np_date_of_test_f5                    as np_date_of_test
     , ps.fu_np_date_of_test_2_f5                  as np_date_of_test_2
     , ps.fu_np_us_test_dat_f5                     as np_us_test_dat
     , ps.fu_np_bld_test_dat_f5                    as np_bld_test_dat
     , ps.ps_fu_pregnancy_id_f5                    as ps_pregnancy_id
     , ps.fu_np_us_edd_dat_f5                      as np_us_edd_dat
     , ps.fu_np_edd_src_f5                         as np_edd_src
     , ps.ps_fu_last_upt_f5                        as ps_fu_last_upt
     , ps.ps_fu_zapps_enr_f5                       as ps_fu_zapps_enr
     , ps.ps_fu_pregnancy_id_f5                    as ps_fu_pregnancy_id
     , ps.ps_preg_last_visit_f5                    as ps_preg_last_visit
     , ps.ps_same_preg_lv_f5                       as ps_same_preg_lv
     , ps.ps_fu_danger_signs_f5___1                as ps_fu_danger_signs___1
     , ps.ps_fu_danger_signs_f5___2                as ps_fu_danger_signs___2
     , ps.ps_fu_danger_signs_f5___3                as ps_fu_danger_signs___3
     , ps.ps_fu_danger_signs_f5___4                as ps_fu_danger_signs___4
     , ps.ps_fu_danger_signs_f5___5                as ps_fu_danger_signs___5
     , ps.ps_fu_danger_signs_f5___6                as ps_fu_danger_signs___6
     , ps.ps_fu_danger_signs_f5___7                as ps_fu_danger_signs___7
     , ps.ps_preg_times_f5                         as ps_preg_times
     , ps.fu_preg_surv_comm_yn_f5                  as preg_surv_comm
     , ps.fu_preg_surv_comm_f5                     as preg_surv_commnts
FROM crt_wra_visit_6_overview v6
         LEFT JOIN wra_follow_up_visit_5_repeating_instruments f5
                   ON v6.alternate_id = f5.wra_follow_up_visit_5_repeating_instruments_id
         LEFT JOIN wrafu_pregnancy_surveillance_6 ps ON v6.record_id = ps.record_id;


UPDATE arch_follow_up_5_visit_master am
    LEFT JOIN arch_etl_db.wra_physical_exam_and_collection poc ON am.record_id = poc.record_id
SET am.poc_hx_hypertension     = poc.poc_hx_hypertension
  , am.bp_vsstat               = poc.bp_vsstat
  , am.bp_sys_vsorres          = poc.bp_sys_vsorres
  , am.bp_dia_vsorres          = poc.bp_dia_vsorres
  , am.poc_is_cr_required      = CAST(poc.poc_is_cr_required as UNSIGNED)
  , am.pulse_vsorres           = poc.pulse_vsorres
  , am.last_sex_scorres        = poc.last_sex_scorres
  , am.poc_wsh_lub             = poc.poc_wsh_lub
  , am.poc_lt_antibiotics      = poc.poc_lt_antibiotics
  , am.swab_spcperf            = poc.swab_spcperf
  , am.swab_spcreasnd          = poc.swab_spcreasnd
  , am.swab_othr_spcreasnd     = poc.swab_othr_spcreasnd
  , am.poc_urine_preg_test_done= poc.poc_urine_preg_test_done
  , am.upt_lborres             = poc.upt_lborres
  , am.zpoc_preg_date          = poc.zpoc_preg_date
  , am.zpoc_preg_date_2        = poc.zpoc_preg_date_2
  , am.poc_preg_id             = poc.poc_preg_id
  , am.poc_preg_id_2           = poc.poc_preg_id_2
  , am.upt_spcperf             = poc.upt_spcperf
  , am.poc_reason_upt_nd_oth   = poc.poc_reason_upt_nd_oth
  , am.poc_comments_yn         = poc.poc_comments_yn
  , am.poc_comments            = poc.poc_comments
  , am.weight_peres            = poc.weight_peres
  , am.height_peres            = poc.height_peres
  , am.bmi                     = poc.bmi
  , am.anth_bmi_result         = poc.anth_bmi_result
  , am.pe_coyn                 = poc.pe_coyn
  , am.wra_anthro_comments     = poc.wra_anthro_comments
WHERE poc.redcap_event_name = 'wra_followup_visit_arm_1e';

UPDATE arch_follow_up_5_visit_master am
    LEFT JOIN arch_etl_db.wrafu_pregnancy_assessments_5 pa ON am.record_id = pa.record_id
SET am.poa_ant_preg            = pa.poa_ant_preg_f5
  , am.poa_ant_att             = pa.poa_ant_att_f5
  , am.poa_ant_count           = pa.poa_ant_count_f5
  , am.poa_fetus_count         = pa.poa_fetus_count_f5
  , am.poa_preg_outcome        = pa.poa_preg_outcome_f5
  , am.poa_preg_dev_outcome    = pa.poa_preg_dev_outcome_f5
  , am.poa_mae_pregend_date    = pa.poa_mae_pregend_date_f5
  , am.poa_preg_dur            = pa.poa_preg_dur_f5
  , am.poa_preg_dur_weeks      = pa.poa_preg_dur_weeks_f5
  , am.poa_preg_dur_months     = pa.poa_preg_dur_months_f5
  , am.poa_pregdev_date        = pa.poa_pregdev_date_f5
  , am.poa_pregdev_dur         = pa.poa_pregdev_dur_f5
  , am.poa_pregdev_dur_weeks   = pa.poa_pregdev_dur_weeks_f5
  , am.poa_pregdev_dur_months  = pa.poa_pregdev_dur_months_f5
  , am.poa_comments_yn         = pa.poa_comments_yn_f5
  , am.poa_comments            = pa.poa_comments_f5
  , am.np_zapps_scorres        = pa.np_fu_zapps_scorres_f5
  , am.np_zapps_ptid           = pa.np_fu_zapps_ptid_f5
  , am.np_zapps_id_src         = pa.np_fu_zapps_id_src_f5
  , am.np_ident_arch           = pa.np_fu_ident_arch_f5
  , am.np_ptw_1                = pa.np_fu_ptw_f5___1
  , am.np_ptw_2                = pa.np_fu_ptw_f5___2
  , am.np_ptw_3                = pa.np_fu_ptw_f5___3
  , am.np_ptw_4                = pa.np_fu_ptw_f5___4
  , am.np_ptw_5                = pa.np_fu_ptw_f5___5
  , am.np_ptw_6                = pa.np_fu_ptw_f5___6
  , am.np_ptw_7                = pa.np_fu_ptw_f5___7
  , am.np_anc_mhyn             = pa.np_fu_anc_mhyn_f5
  , am.np_anc_num_mh           = pa.np_fu_anc_num_mh_f5
  , am.np_anc1_dat             = pa.np_fu_anc1_dat_f5
  , am.np_anc1_ga              = pa.np_fu_anc1_ga_f5
  , am.anc1_ga_weeks           = pa.fu_anc1_ga_weeks_f5
  , am.anc1_ga_months          = pa.fu_anc1_ga_months_f5
  , am.np_anc_plan_obsloc      = pa.np_fu_anc_plan_obsloc_f5
  , am.birth_plan_fac_obsloc   = pa.fu_birth_plan_fac_obsloc_f5
  , am.facility_other          = pa.fu_facility_other_f5
  , am.birth_other_loc         = pa.fu_birth_other_loc_f5
  , am.np_del_decide_scorres   = pa.np_fu_del_decide_scorres_f5
  , am.del_decide_spfy_scorres = pa.fu_del_decide_spfy_scorres_f5
  , am.cph_comments_yn         = pa.np_fu_comments_yn_f5
  , am.cph_comments            = pa.np_fu_comments_f5
  , am.np_alc_suyn             = pa.np_fu_alc_suyn_f5
  , am.np_alc_cons             = pa.np_fu_alc_cons_f5
  , am.np_tob_suyn             = pa.np_fu_tob_suyn_f5
  , am.np_tob_cur_sudosfrq     = pa.np_fu_tob_curr_sudosfrq_f5
  , am.tob_oth_sutrt_1         = pa.fu_tob_oth_stutrt_f5___1
  , am.tob_oth_sutrt_2         = pa.fu_tob_oth_stutrt_f5___2
  , am.tob_oth_sutrt_3         = pa.fu_tob_oth_stutrt_f5___3
  , am.tob_oth_sutrt_4         = pa.fu_tob_oth_stutrt_f5___4
  , am.tob_oth_sutrt_5         = pa.fu_tob_oth_stutrt_f5___5
  , am.tob_oth_sutrt_6         = pa.fu_tob_oth_stutrt_f5___6
  , am.tob_oth_sutrt_7         = pa.fu_tob_oth_stutrt_f5___7
  , am.other_tbc_use           = pa.fu_other_tbc_use_f5
  , am.np_drug_suyn            = pa.np_fu_drug_suyn_f5
  , am.np_drug_usage           = pa.np_fu_drug_usage_f5
  , am.np_drug_sutrt_1         = pa.np_fu_drug_sutrt_f5___1
  , am.np_drug_sutrt_2         = pa.np_fu_drug_sutrt_f5___2
  , am.np_drug_sutrt_3         = pa.np_fu_drug_sutrt_f5___3
  , am.np_drug_sutrt_4         = pa.np_fu_drug_sutrt_f5___4
  , am.np_drug_sutrt_5         = pa.np_fu_drug_sutrt_f5___5
  , am.np_drug_sutrt_6         = pa.np_fu_drug_sutrt_f5___6
  , am.np_drug_sutrt_7         = pa.np_fu_drug_sutrt_f5___7
  , am.np_drug_sutrt_othr      = pa.np_fu_drug_sutrt_othr_f5
  , am.hbp_comments_yn         = pa.hbp_fu_comments_yn_f5
  , am.hbp_comments            = pa.hbp_fu_comments_f5
  , am.name_veri               = pa.fu_name_veri_f5
  , am.brthdat_veri            = pa.fu_brthdat_veri_f5
  , am.ref_likely_scorres      = pa.fu_ref_likely_scorres_f5
  , am.ref_res_decline_1       = pa.fu_ref_res_decline_f5___1
  , am.ref_res_decline_2       = pa.fu_ref_res_decline_f5___2
  , am.ref_res_decline_3       = pa.fu_ref_res_decline_f5___3
  , am.ref_res_decline_4       = pa.fu_ref_res_decline_f5___4
  , am.ref_res_decline_5       = pa.fu_ref_res_decline_f5___5
  , am.ref_res_decline_6       = pa.fu_ref_res_decline_f5___6
  , am.zr_2_other              = pa.zr_fu_reas_other_f5
  , am.pref_zapps_scorres      = pa.zr_fu_pref_zapps_scorres_f5
  , am.apnt_dat_scorres        = pa.zr_fu_apnt_dat_scorres_f5
  , am.zr_confirm_contact      = pa.zr_fu_confirm_contact_f5
  , am.preg_test               = pa.fu_preg_test_f5
  , am.zr_wra_ptid             = pa.zr_fu_wra_ptid_f5
  , am.zr_comm_yn              = pa.zr_fu_comments_yn_f5
  , am.zr_comm                 = pa.zr_fu_comments_f5
WHERE (pa.poa_ant_preg_f5 IS NOT NULL OR pa.np_fu_zapps_scorres_f5 IS NOT NULL
    OR pa.fu_name_veri_f5 IS NOT NULL)
  AND am.visit_number = 6.0;

UPDATE arch_follow_up_5_visit_master am
    LEFT JOIN arch_etl_db.infant_outcome_assessment_5_repeating_instruments io ON am.record_id = io.record_id
SET am.ioa_infant_name     = io.ioa_infant_name_f5,
    am.ioa_infant_ptid     = CONCAT_WS('-', am.wra_ptid, useAutoTrimmer(io.ioa_infant_name_f5)),
    am.ioa_infant_sex      = io.ioa_infant_sex_f5,
    am.ioa_infant_alive    = io.ioa_infant_alive_f5,
    am.ioa_infant_age_days = io.ioa_infant_age_days_f5,
    am.ioa_infant_age_days = io.ioa_infant_age_months_f5,
    am.ioa_infant_age_days = io.ioa_infant_age_death_days_f5,
    am.ioa_infant_age_days = io.ioa_infant_age_death_months_f5
WHERE io.redcap_repeat_instance = 1
  AND io.redcap_event_name = 'wra_followup_visit_arm_1e'
  AND am.visit_number = 6.0;

UPDATE arch_follow_up_5_visit_master am
    LEFT JOIN arch_etl_db.infant_outcome_assessment_5_repeating_instruments io ON am.record_id = io.record_id
SET am.ioa_infant_name_2     = io.ioa_infant_name_f5,
    am.ioa_infant_ptid_2     = CONCAT_WS('-', am.wra_ptid, useAutoTrimmer(io.ioa_infant_name_f5)),
    am.ioa_infant_sex_2      = io.ioa_infant_sex_f5,
    am.ioa_infant_alive_2    = io.ioa_infant_alive_f5,
    am.ioa_infant_age_days_2 = io.ioa_infant_age_days_f5,
    am.ioa_infant_age_days_2 = io.ioa_infant_age_months_f5,
    am.ioa_infant_age_days_2 = io.ioa_infant_age_death_days_f5,
    am.ioa_infant_age_days_2 = io.ioa_infant_age_death_months_f5
WHERE io.redcap_repeat_instance = 2
  AND io.redcap_event_name = 'wra_followup_visit_arm_1e'
  AND am.visit_number = 6.0;


UPDATE arch_follow_up_5_visit_master am
    LEFT JOIN arch_etl_db.clinical_referral_repeating_instruments cr ON am.record_id = cr.record_id
SET am.cr_refer_to            = cr.cr_refer_to
  , am.cr_refer_to_other      = cr.cr_refer_to_other
  , am.referral_reasons_1     = cr.referral_reasons___1
  , am.referral_reasons_2     = cr.referral_reasons___2
  , am.referral_reasons_3     = cr.referral_reasons___3
  , am.referral_reasons_4     = cr.referral_reasons___4
  , am.referral_reasons_5     = cr.referral_reasons___5
  , am.referral_reasons_6     = cr.referral_reasons___6
  , am.referral_reasons_7     = cr.referral_reasons___7
  , am.referral_reasons_other = cr.referral_reasons_other
  , am.cr_ra_comments_yn      = cr.cr_ra_comments_yn
  , am.cr_ra_comments         = cr.cr_ra_comments
WHERE cr.redcap_repeat_instance = 1
  AND cr.redcap_event_name = 'wra_followup_visit_arm_1d'
  AND am.visit_number = 5.0;

UPDATE arch_follow_up_5_visit_master am
    LEFT JOIN arch_etl_db.clinical_referral_repeating_instruments cr ON am.record_id = cr.record_id
SET am.cr_refer_to_1            = cr.cr_refer_to
  , am.cr_refer_to_other_1      = cr.cr_refer_to_other
  , am.referral_reasons_1_1     = cr.referral_reasons___1
  , am.referral_reasons_2_1     = cr.referral_reasons___2
  , am.referral_reasons_3_1     = cr.referral_reasons___3
  , am.referral_reasons_4_1     = cr.referral_reasons___4
  , am.referral_reasons_5_1     = cr.referral_reasons___5
  , am.referral_reasons_6_1     = cr.referral_reasons___6
  , am.referral_reasons_7_1     = cr.referral_reasons___7
  , am.referral_reasons_other_1 = cr.referral_reasons_other
  , am.cr_ra_comments_yn_1      = cr.cr_ra_comments_yn
  , am.cr_ra_comments_1         = cr.cr_ra_comments
WHERE cr.redcap_repeat_instance = 2
  AND cr.redcap_event_name = 'wra_followup_visit_arm_1e'
  AND am.visit_number = 6.0;

UPDATE arch_follow_up_5_visit_master am
    LEFT JOIN arch_etl_db.clinical_referral_repeating_instruments cr ON am.record_id = cr.record_id
SET am.cr_refer_to_2            = cr.cr_refer_to
  , am.cr_refer_to_other_2      = cr.cr_refer_to_other
  , am.referral_reasons_1_2     = cr.referral_reasons___1
  , am.referral_reasons_2_2     = cr.referral_reasons___2
  , am.referral_reasons_3_2     = cr.referral_reasons___3
  , am.referral_reasons_4_2     = cr.referral_reasons___4
  , am.referral_reasons_5_2     = cr.referral_reasons___5
  , am.referral_reasons_6_2     = cr.referral_reasons___6
  , am.referral_reasons_7_2     = cr.referral_reasons___7
  , am.referral_reasons_other_2 = cr.referral_reasons_other
  , am.cr_ra_comments_yn_2      = cr.cr_ra_comments_yn
  , am.cr_ra_comments_2         = cr.cr_ra_comments
WHERE cr.redcap_repeat_instance = 3
  AND cr.redcap_event_name = 'wra_followup_visit_arm_1e'
  AND am.visit_number = 6.0;

UPDATE arch_follow_up_5_visit_master am
    LEFT JOIN arch_etl_db.outmigration om ON am.record_id = om.record_id
SET am.om_name_scorres = om.om_name_scorres
  , am.return_scorres  = om.return_scorres
  , am.om_comments_yn  = om.om_comments_yn
  , am.om_comments     = om.om_comments
WHERE om.redcap_event_name = 'wra_followup_visit_arm_1e'
  AND am.visit_number = 6.0;

UPDATE arch_follow_up_5_visit_master am
    LEFT JOIN arch_etl_db.wra_study_closure sc ON am.record_id = sc.record_id
SET am.sc_1        = sc.sc_1
  , am.sc_2        = sc.sc_2
  , am.sc_3        = sc.sc_3
  , am.sc_5        = sc.sc_5
  , am.sc_6        = sc.sc_6
  , am.sc_7        = sc.sc_7
  , am.sc_7_other  = sc.sc_7_other
  , am.sc_8        = sc.sc_8
  , am.sc_9        = sc.sc_9
  , am.sc_10       = sc.sc_10
  , am.sc_10_other = sc.sc_10_other
  , am.sc_11       = sc.sc_11
  , am.sc_comm_yn  = sc.sc_comm_yn
  , am.sc_comm     = sc.sc_comm
WHERE sc.redcap_event_name = 'wra_followup_visit_arm_1e'
  AND am.visit_number = 6.0;