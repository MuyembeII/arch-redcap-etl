-- Follow Up 1 Overview
TRUNCATE arch_etl_db.arch_follow_up_1_visit_master_v1;
SET time_zone = '+02:00';
INSERT INTO arch_etl_db.arch_follow_up_1_visit_master_v1( id
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
                                                        , ps_preg_dur
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
SELECT v2.alternate_id                                                                          as id
     , v2.record_id
     , v2.visit_number
     , v2.visit_name
     , v2.visit_outcome
     , v2.screening_id                                                                          as hh_scrn_num_obsloc
     , CAST(f1.fu_attempt_count as UNSIGNED)                                                    as wra_enr_visit_count
     , CAST(f1.fu_attempt_count as UNSIGNED)                                                    as attempt_count
     , COALESCE(CAST(f1.fu_hh_member_id as UNSIGNED), CAST(f1.fu_hhe_hh_member_id as UNSIGNED)) as hhe_hh_member_id
     , f1.wra_fu_visit_date                                                                     as scrn_obsstdat
     , f1.wra_fu_interviewer_obsloc                                                             as wra_enr_interviewer_obsloc
     , get_YN_Label(f1.wra_fu_conf_consent)                                                     as wra_enr_hhh_pvc
     , f1.wra_fu_reas_decline_const                                                             as wra_enr_reas_decline
     , f1.wra_fu_pp_avail_label                                                                 as wra_enr_pp_avail
     , f1.wra_fu_is_wra_avail_other                                                             as is_wra_avail_other
     , v2.wra_ptid                                                                              as wra_ptid
     , f1.fu_c19vax_cmyn_label                                                                  as c19vax_cmyn
     , f1.fu_c19vax_cmtrt_label                                                                 as c19vax_cmtrt
     , f1.fu_covid_scrn_3_label                                                                 as covid_scrn_3
     , get_YN_Label(f1.fu_c19_lbperf)                                                           as c19_lbperf
     , ''                                                                                       as covid_test_dt_range
     , f1.fu_c19_lbdat                                                                          as c19_lbdat
     , f1.fu_c19_lborres_label                                                                  as c19_lborres
     , f1.fu_fever_ceoccur_label                                                                as fever_ceoccur
     , f1.fu_cough_ceoccur_label                                                                as cough_ceoccur
     , f1.fu_shortbreath_ceoccur_label                                                          as shortbreath_ceoccur
     , f1.fu_sorethroat_ceoccur_label                                                           as sorethroat_ceoccur
     , f1.fu_fatigue_ceoccur_label                                                              as fatigue_ceoccur
     , f1.fu_myalgia_ceoccur_label                                                              as myalgia_ceoccur
     , f1.fu_anorexia_ceoccur_label                                                             as anorexia_ceoccur
     , f1.fu_nausea_ceoccur_label                                                               as nausea_ceoccur
     , f1.fu_diarrhoea_ceoccur_label                                                            as diarrhoea_ceoccur
     , f1.fu_ageusia_ceoccur_label                                                              as ageusia_ceoccur
     , f1.fu_anosmia_ceoccur_label                                                              as anosmia_ceoccur
     , f1.fu_runnynose_ceoccur_label                                                            as runnynose_ceoccur
     , f1.fu_sneeze_ceoccur_label                                                               as sneeze_ceoccur
     , f1.fu_headache_ceoccur_label                                                             as headache_ceoccur
     , f1.fu_rash_ceoccur_label                                                                 as rash_ceoccur
     , f1.fu_conjunct_ceoccur_label                                                             as conjunct_ceoccur
     , f1.fu_c19_contact_dx_ceoccur_label                                                       as c19_contact_dx_ceoccur
     , f1.fu_c19_contact_sx_ceoccur_label                                                       as c19_contact_sx_ceoccur
     , f1.fu_hh_member_id                                                                       as hh_member_id
     , get_YN_Label(f1.fu_covid_scrn_9)                                                         as covid_scrn_9
     , get_YN_Label(f1.fu_c19_zm_scorres)                                                       as c19_zm_scorres
     , get_YN_Label(f1.fu_covid_scrn_comments_yn)                                               as covid_scrn_comments_yn
     , f1.fu_covid_scrn_comments                                                                as covid_scrn_comments
     , get_YN_Label(f1.fu_loc_same_hh_lv)                                                       as fu_loc_same_hh_lv
     , f1.wra_fu_cluster_prev                                                                   as wra_fu_cluster_prev
     , f1.wra_fu_sbn_prev                                                                       as wra_fu_sbn_prev
     , f1.wra_fu_hun_prev                                                                       as wra_fu_hun_prev
     , f1.wra_fu_hhn_prev                                                                       as wra_fu_hhn_prev
     , f1.wra_fu_prev_screening_id                                                              as wra_fu_prev_screening_id
     , f1.wra_fu_hh_screening_id                                                                as wra_fu_hh_screening_id
     , f1.loc_fu_mig_to_scorres_label                                                           as loc_fu_mig_to_scorres
     , get_YN_Label(f1.loc_fu_loc_known)                                                        as loc_fu_loc_known
     , f1.loc_fu_locality_name                                                                  as loc_fu_locality_name
     , get_YN_Label(f1.loc_fu_newloc_scorres_yn)                                                as loc_fu_newloc_scorres_yn
     , f1.loc_fu_newloc_scorres                                                                 as loc_fu_newloc_scorres
     , f1.loc_fu_newloc_landmark                                                                as loc_fu_newloc_landmark
     , f1.loc_fu_loc_landmarks                                                                  as loc_fu_loc_landmarks
     , get_YN_Label(f1.loc_fu_loc_direction)                                                    as loc_fu_loc_direction
     , f1.loc_fu_new_directions                                                                 as loc_fu_new_directions
     , f1.loc_fu_mig_dat_scorres                                                                as loc_fu_mig_dat_scorres
     , get_YN_Label(f1.loc_fu_fc_corr)                                                          as loc_fc_num
     , f1.loc_fu_pn_belongs_othr                                                                as loc_pn_belongs_oth
     , f1.loc_fu_who_is_caller                                                                  as loc_who_is_caller
     , f1.loc_fu_pn_belongs_label                                                               as loc_pn_belongs
     , f1.loc_fu_fc_corr_2                                                                      as loc_sc_num
     , f1.loc_fu_pn_belongs_2_label                                                             as loc_pn_belongs_2
     , f1.loc_fu_pn_belongs_othr_2                                                              as loc_pn_belongs_oth_2
     , f1.loc_fu_who_is_caller_2                                                                as loc_who_is_caller_2
     , f1.loc_fu_enrolled_zapps_label                                                           as loc_enrolled_zapps
     , f1.loc_fu_zapps_ptid                                                                     as loc_zapps_ptid
     , f1.loc_fu_zapps_ptid_src_label                                                           as loc_zapps_ptid_src
     , get_YN_Label(f1.fu_famliid_yn)                                                           as famliid_yn
     , f1.fu_famli_id_scorres                                                                   as famli_id_scorres
     , f1.loc_fu_famli_id_src_label                                                             as loc_famli_id_src
     , get_YN_Label(f1.wra_fu_comments_yn)                                                      as loc_comments_yn
     , useAutoChoiceTrimmer(f1.wra_fu_comments)                                                                       as loc_comments
     , f1.fu_scdmar_scorres_label                                                               as scdmar_scorres
     , f1.scd_fu_agemar_scorres                                                                 as scd_agemar_scorres
     , get_YN_Label(f1.fu_school_scorres)                                                       as school_scorres
     , f1.fu_sd_highest_edu_level_label                                                         as sd_highest_edu_level
     , f1.fu_school_yrs_scorres                                                                 as school_yrs_scorres
     , get_YN_Label(f1.fu_scd_occupation_scorres)                                               as scd_occupation_scorres
     , REGEXP_REPLACE(f1.fu_sd_approx_income_pay, '[[:space:]]+', ' ')                          as sd_approx_income_pay
     , f1.fu_scd_mobile_fcorres_label                                                           as scd_mobile_fcorres
     , get_YN_Label(f1.fu_scd_mh_tob_suyn)                                                      as scd_mh_tob_suyn
     , f1.fu_scd_mh_tob_sudosfrq_label                                                          as scd_mh_tob_sudosfrq
     , get_YN_Label(f1.fu_scd_tob_chew_sutrt)                                                   as scd_tob_chew_sutrt
     , get_YN_Label(f1.fu_scd_alc_suyn)                                                         as scd_alc_suyn
     , get_YN_Label(f1.fu_scd_comments_yn)                                                      as scd_comments_yn
     , useAutoChoiceTrimmer(f1.fu_scd_comments)                                                                       as scd_comments
     , get_YN_Label(f1.fu_hh_nofd_scorres)                                                      as hh_nofd_scorres
     , f1.fu_hh_nofd_frq_scorres_label                                                          as hh_nofd_frq_scorres
     , get_YN_Label(f1.fu_hh_nofd_sleep_scorres)                                                as hh_nofd_sleep_scorres
     , f1.fu_hh_nofd_sleep_frq_label                                                            as hh_nofd_sleep_frq_scorres
     , get_YN_Label(f1.fu_hh_nofd_night_scorres)                                                as hh_nofd_night_scorres
     , f1.fu_hh_nofd_night_frq_label                                                            as hh_nofd_night_frq_scorres
     , get_YN_Label(f1.fu_hfs_coyn)                                                             as hfs_coyn
     , useAutoChoiceTrimmer(f1.fu_hfs_coval)                                                                          as hfs_coval
     , get_YN_Label(ps.fu_lmp_reg_scorres)                                                      as lmp_reg_scorres
     , IF(ps.fu_lmp_kd_scorres = 96, TRIM(ps.lmp_kd_scorres_othr), fu_lmp_kd_scorres_label)     as lmp_kd_scorres
     , TRIM(ps.lmp_kd_scorres_othr)                                                             as lmp_kd_scorres_other
     , get_YN_Label(ps.fu_lmp_start_scorres)                                                    as lmp_start_scorres
     , ps.fu_lmp_scdat                                                                          as lmp_scdat
     , useAutoChoiceTrimmer(ps.fu_lmp_cat_scorres_label)                                        as lmp_cat_scorres
     , ps.fu_lmp_start_weeks                                                                    as lmp_start_weeks
     , ps.fu_lmp_start_months                                                                   as lmp_start_months
     , ps.fu_lmp_start_years                                                                    as lmp_start_years
     , get_YN_Label(ps.fu_lmp_scorres)                                                          as lmp_scorres
     , get_YN_Label(ps.fu_ps_mens_cal_yn)                                                       as ps_mens_cal_yn
     , get_YN_Label(ps.fu_lmp_dt_rec_cal)                                                       as lmp_dt_rec_cal
     , ps.fu_preg_scorres_label                                                                 as preg_scorres
     , useAutoChoiceTrimmer(ps.ps_fu_preg_dur_label)                                            as preg_scorres
     , ps.fu_month_preg_scorres                                                                 as months_preg_scorres
     , ps.fu_np_pregid_mhyn_label                                                               as np_pregid_mhyn
     , ps.fu_np_date_of_test                                                                    as np_date_of_test
     , ps.fu_np_date_of_test_2                                                                  as np_date_of_test_2
     , ps.fu_np_us_test_dat                                                                     as np_us_test_dat
     , ps.fu_np_bld_test_dat                                                                    as np_bld_test_dat
     , ps.ps_fu_pregnancy_id                                                                    as ps_pregnancy_id
     , ps.fu_np_us_edd_dat                                                                      as np_us_edd_dat
     , ps.fu_np_edd_src_label                                                                   as np_edd_src
     , ps.ps_fu_last_upt
     , ps.ps_fu_zapps_enr
     , ps.ps_fu_pregnancy_id
     , get_YN_Label(ps.ps_preg_last_visit)
     , get_YN_Label(ps.ps_same_preg_lv)
     , ps.ps_fu_danger_signs___1_label
     , ps.ps_fu_danger_signs___2_label
     , ps.ps_fu_danger_signs___3_label
     , ps.ps_fu_danger_signs___4_label
     , ps.ps_fu_danger_signs___5_label
     , ps.ps_fu_danger_signs___6_label
     , ps.ps_fu_danger_signs___7_label
     , ps.ps_preg_times
     , get_YN_Label(ps.fu_preg_surv_comm_yn)                                                    as preg_surv_comm
     , useTextTransformer(ps.fu_preg_surv_comm)                                                 as preg_surv_commnts
FROM crt_wra_visit_2_overview v2
         LEFT JOIN wra_follow_up_visit_repeating_instruments f1
                   ON v2.alternate_id = f1.wra_follow_up_visit_repeating_instruments_id
         LEFT JOIN wrafu_pregnancy_surveillance ps ON v2.record_id = ps.record_id;

UPDATE arch_follow_up_1_visit_master_v1 wra
    LEFT JOIN arch_etl_db.crt_wra_visit_2_overview v2 ON wra.record_id = v2.record_id
SET wra.wra_age = v2.age
WHERE wra.wra_ptid = v2.wra_ptid;

UPDATE arch_follow_up_1_visit_master_v1 sd_v2
SET sd_v2.sd_approx_income_pay = REPLACE(REPLACE(REPLACE(sd_approx_income_pay, 'K', ''), 'k', ''), 'Kk', '')
WHERE sd_v2.sd_approx_income_pay = 'Yes';

UPDATE arch_follow_up_1_visit_master_v1 sd_v2
SET sd_v2.sd_approx_income_pay = REPLACE(REPLACE(REPLACE(sd_approx_income_pay, 'K', ''), 'k', ''), 'Kk', '')
WHERE sd_v2.sd_approx_income_pay = 'Yes';

UPDATE arch_follow_up_1_visit_master_v1 sd_v2
SET sd_v2.sd_approx_income_pay = CAST(sd_v2.sd_approx_income_pay AS DECIMAL(12, 2))
WHERE sd_v2.sd_approx_income_pay REGEXP '^[[:digit:]]+$';

UPDATE arch_follow_up_1_visit_master_v1 am
    LEFT JOIN arch_etl_db.wra_physical_exam_and_collection poc ON am.record_id = poc.record_id
SET am.poc_hx_hypertension     = get_YN_Label(poc.poc_hx_hypertension)
  , am.bp_vsstat               = get_YN_Label(poc.bp_vsstat)
  , am.bp_sys_vsorres          = poc.bp_sys_vsorres
  , am.bp_dia_vsorres          = poc.bp_dia_vsorres
  , am.poc_is_cr_required      = CAST(poc.poc_is_cr_required as UNSIGNED)
  , am.pulse_vsorres           = poc.pulse_vsorres
  , am.last_sex_scorres        = poc.last_sex_scorres_label
  , am.poc_wsh_lub             = poc.poc_wsh_lub_label
  , am.poc_lt_antibiotics      = poc.poc_lt_antibiotics_label
  , am.swab_spcperf            = poc.swab_spcperf_label
  , am.swab_spcreasnd          = IF(poc.swab_othr_spcreasnd = 5, useTextTransformer(poc.swab_othr_spcreasnd),
                                    poc.swab_spcreasnd_label)
  , am.swab_othr_spcreasnd     = useTextTransformer(poc.swab_othr_spcreasnd)
  , am.poc_urine_preg_test_done= get_YN_Label(poc.poc_urine_preg_test_done)
  , am.upt_lborres             = poc.upt_lborres_label
  , am.zpoc_preg_date          = poc.zpoc_preg_date
  , am.zpoc_preg_date_2        = poc.zpoc_preg_date_2
  , am.poc_preg_id             = poc.poc_preg_id
  , am.poc_preg_id_2           = poc.poc_preg_id_2
  , am.upt_spcperf             = IF(poc.upt_spcperf = 4, TRIM(poc.poc_reason_upt_nd_oth), poc.upt_spcperf_label)
  , am.poc_reason_upt_nd_oth   = TRIM(poc.poc_reason_upt_nd_oth)
  , am.poc_comments_yn         = get_YN_Label(poc.poc_comments_yn)
  , am.poc_comments            = useTextTransformer(poc.poc_comments)
  , am.weight_peres            = poc.weight_peres
  , am.height_peres            = poc.height_peres
  , am.bmi                     = poc.bmi
  , am.anth_bmi_result         = poc.anth_bmi_result
  , am.pe_coyn                 = get_YN_Label(poc.pe_coyn)
  , am.wra_anthro_comments     = useTextTransformer(poc.wra_anthro_comments)
WHERE poc.redcap_event_name = 'wra_followup_visit_arm_1';

UPDATE arch_follow_up_1_visit_master_v1 am
    LEFT JOIN arch_etl_db.wrafu_pregnancy_assessments pa ON am.record_id = pa.record_id
SET am.poa_ant_preg            = get_YN_Label(pa.poa_ant_preg)
  , am.poa_ant_att             = IF(pa.poa_ant_att = 1, CONCAT(pa.poa_ant_count, ' times'),
                                    pa.poa_ant_att_label)
  , am.poa_ant_count           = pa.poa_ant_count
  , am.poa_fetus_count         = pa.poa_fetus_count_label
  , am.poa_preg_outcome        = pa.poa_preg_outcome_label
  , am.poa_preg_dev_outcome    = pa.poa_preg_dev_outcome_label
  , am.poa_mae_pregend_date    = pa.poa_mae_pregend_date
  , am.poa_preg_dur            = useAutoChoiceTrimmer(pa.poa_preg_dur)
  , am.poa_preg_dur_weeks      = pa.poa_preg_dur_weeks
  , am.poa_preg_dur_months     = pa.poa_preg_dur_months
  , am.poa_pregdev_date        = pa.poa_pregdev_date
  , am.poa_pregdev_dur         = useAutoChoiceTrimmer(pa.poa_pregdev_dur)
  , am.poa_pregdev_dur_weeks   = pa.poa_pregdev_dur_weeks
  , am.poa_pregdev_dur_months  = pa.poa_pregdev_dur_months
  , am.poa_comments_yn         = get_YN_Label(pa.poa_comments_yn)
  , am.poa_comments            = useTextTransformer(pa.poa_comments)
  , am.np_zapps_scorres        = pa.np_fu_zapps_scorres_label
  , am.np_zapps_ptid           = TRIM(pa.np_fu_zapps_ptid)
  , am.np_zapps_id_src         = pa.np_fu_zapps_id_src_label
  , am.np_ident_arch           = get_YN_Label(pa.np_fu_ident_arch)
  , am.np_ptw_1                = pa.np_fu_ptw___1_label
  , am.np_ptw_2                = pa.np_fu_ptw___2_label
  , am.np_ptw_3                = pa.np_fu_ptw___3_label
  , am.np_ptw_4                = pa.np_fu_ptw___4_label
  , am.np_ptw_5                = pa.np_fu_ptw___5_label
  , am.np_ptw_6                = pa.np_fu_ptw___6_label
  , am.np_ptw_7                = pa.np_fu_ptw___7_label
  , am.np_anc_mhyn             = get_YN_Label(pa.np_fu_anc_mhyn)
  , am.np_anc_num_mh           = pa.np_fu_anc_num_mh
  , am.np_anc1_dat             = pa.np_fu_anc1_dat
  , am.np_anc1_ga              = IF(pa.np_fu_anc1_ga = 98, pa.np_fu_anc1_ga_label,
                                    useAutoChoiceTrimmer(pa.np_fu_anc1_ga_label))
  , am.anc1_ga_weeks           = pa.fu_anc1_ga_weeks
  , am.anc1_ga_months          = pa.fu_anc1_ga_months
  , am.np_anc_plan_obsloc      = pa.np_fu_anc_plan_obsloc_label
  , am.birth_plan_fac_obsloc   = IF(pa.fu_birth_plan_fac_obsloc = 88, TRIM(fu_birth_other_loc),
                                    fu_birth_plan_fac_obsloc_label)
  , am.facility_other          = pa.fu_facility_other_label
  , am.birth_other_loc         = TRIM(pa.fu_birth_other_loc)
  , am.np_del_decide_scorres   = IF(pa.np_fu_del_decide_scorres = 88, TRIM(pa.fu_del_decide_spfy_scorres),
                                    pa.np_fu_del_decide_scorres_label)
  , am.del_decide_spfy_scorres = pa.fu_del_decide_spfy_scorres
  , am.cph_comments_yn         = get_YN_Label(pa.np_fu_comments_yn)
  , am.cph_comments            = useTextTransformer(pa.np_fu_comments)
  , am.np_alc_suyn             = get_YN_Label(pa.np_fu_alc_suyn)
  , am.np_alc_cons             = pa.np_fu_alc_cons_label
  , am.np_tob_suyn             = get_YN_Label(pa.np_fu_tob_suyn)
  , am.np_tob_cur_sudosfrq     = pa.np_fu_tob_curr_sudosfrq_label
  , am.tob_oth_sutrt_1         = pa.fu_tob_oth_stutrt___1_label
  , am.tob_oth_sutrt_2         = pa.fu_tob_oth_stutrt___2_label
  , am.tob_oth_sutrt_3         = pa.fu_tob_oth_stutrt___3_label
  , am.tob_oth_sutrt_4         = pa.fu_tob_oth_stutrt___4_label
  , am.tob_oth_sutrt_5         = pa.fu_tob_oth_stutrt___5_label
  , am.tob_oth_sutrt_6         = pa.fu_tob_oth_stutrt___6_label
  , am.tob_oth_sutrt_7         = pa.fu_tob_oth_stutrt___7_label
  , am.other_tbc_use           = useAutoTrimmer(pa.fu_other_tbc_use)
  , am.np_drug_suyn            = get_YN_Label(pa.np_fu_drug_suyn)
  , am.np_drug_usage           = pa.np_fu_drug_usage_label
  , am.np_drug_sutrt_1         = pa.np_fu_drug_sutrt___1_label
  , am.np_drug_sutrt_2         = pa.np_fu_drug_sutrt___2_label
  , am.np_drug_sutrt_3         = pa.np_fu_drug_sutrt___3_label
  , am.np_drug_sutrt_4         = pa.np_fu_drug_sutrt___4_label
  , am.np_drug_sutrt_5         = pa.np_fu_drug_sutrt___5_label
  , am.np_drug_sutrt_6         = pa.np_fu_drug_sutrt___6_label
  , am.np_drug_sutrt_7         = pa.np_fu_drug_sutrt___7_label
  , am.np_drug_sutrt_othr      = useAutoTrimmer(pa.np_fu_drug_sutrt_othr)
  , am.hbp_comments_yn         = get_YN_Label(pa.hbp_fu_comments_yn)
  , am.hbp_comments            = useTextTransformer(pa.hbp_fu_comments)
  , am.name_veri               = pa.fu_name_veri_label
  , am.brthdat_veri            = pa.fu_brthdat_veri_label
  , am.ref_likely_scorres      = get_YN_Label(pa.fu_ref_likely_scorres)
  , am.ref_res_decline_1       = pa.fu_ref_res_decline___1_label
  , am.ref_res_decline_2       = pa.fu_ref_res_decline___2_label
  , am.ref_res_decline_3       = pa.fu_ref_res_decline___3_label
  , am.ref_res_decline_4       = pa.fu_ref_res_decline___4_label
  , am.ref_res_decline_5       = pa.fu_ref_res_decline___5_label
  , am.ref_res_decline_6       = pa.fu_ref_res_decline___6_label
  , am.zr_2_other              = useAutoTrimmer(pa.zr_fu_reas_other)
  , am.pref_zapps_scorres      = pa.zr_fu_pref_zapps_scorres_label
  , am.apnt_dat_scorres        = pa.zr_fu_apnt_dat_scorres
  , am.zr_confirm_contact      = pa.zr_fu_confirm_contact_label
  , am.preg_test               = pa.fu_preg_test
  , am.zr_wra_ptid             = TRIM(pa.zr_fu_wra_ptid)
  , am.zr_comm_yn              = get_YN_Label(pa.zr_fu_comments_yn)
  , am.zr_comm                 = useTextTransformer(pa.zr_fu_comments)
WHERE (pa.poa_ant_preg IS NOT NULL OR pa.np_fu_zapps_scorres IS NOT NULL
    OR pa.fu_name_veri IS NOT NULL)
  AND am.visit_number = 2.0;

UPDATE arch_follow_up_1_visit_master_v1 am
    LEFT JOIN arch_etl_db.infant_outcome_assessment_repeating_instruments io ON am.record_id = io.record_id
SET am.ioa_infant_name             = useAutoTrimmer(io.ioa_infant_name),
    am.ioa_infant_ptid             = CONCAT_WS('-', am.wra_ptid, useAutoTrimmer(io.ioa_infant_name)),
    am.ioa_infant_sex              = io.ioa_infant_sex_label,
    am.ioa_infant_alive            = io.ioa_infant_alive_label,
    am.ioa_infant_age              = useAutoChoiceTrimmer(io.ioa_infant_age),
    am.ioa_infant_age_days         = io.ioa_infant_age_days,
    am.ioa_infant_age_months       = io.ioa_infant_age_months,
    am.ioa_infant_age_death        = useAutoChoiceTrimmer(io.ioa_infant_age_death),
    am.ioa_infant_age_death_days   = io.ioa_infant_age_death_days,
    am.ioa_infant_age_death_months = io.ioa_infant_age_death_months
WHERE io.redcap_repeat_instance = 1
  AND io.redcap_event_name = 'wra_followup_visit_arm_1'
  AND am.visit_number = 2.0;

UPDATE arch_follow_up_1_visit_master_v1 am
    LEFT JOIN arch_etl_db.infant_outcome_assessment_repeating_instruments io ON am.record_id = io.record_id
SET am.ioa_infant_name             = useAutoTrimmer(io.ioa_infant_name),
    am.ioa_infant_ptid             = CONCAT_WS('-', am.wra_ptid, useAutoTrimmer(io.ioa_infant_name)),
    am.ioa_infant_sex              = io.ioa_infant_sex_label,
    am.ioa_infant_alive            = io.ioa_infant_alive_label,
    am.ioa_infant_age              = useAutoChoiceTrimmer(io.ioa_infant_age),
    am.ioa_infant_age_days         = io.ioa_infant_age_days,
    am.ioa_infant_age_months       = io.ioa_infant_age_months,
    am.ioa_infant_age_death        = useAutoChoiceTrimmer(io.ioa_infant_age_death),
    am.ioa_infant_age_death_days   = io.ioa_infant_age_death_days,
    am.ioa_infant_age_death_months = io.ioa_infant_age_death_months
WHERE io.redcap_repeat_instance = 2
  AND io.redcap_event_name = 'wra_followup_visit_arm_1'
  AND am.visit_number = 2.0;

UPDATE arch_follow_up_1_visit_master_v1 am
    LEFT JOIN arch_etl_db.clinical_referral_repeating_instruments cr ON am.record_id = cr.record_id
SET am.cr_refer_to            = IF(cr.cr_refer_to = 4, useAutoTrimmer(cr.cr_refer_to_other), cr.cr_refer_to_label)
  , am.cr_refer_to_other      = cr.cr_refer_to_other
  , am.referral_reasons_1     = cr.referral_reasons___1_label
  , am.referral_reasons_2     = cr.referral_reasons___2_label
  , am.referral_reasons_3     = cr.referral_reasons___3_label
  , am.referral_reasons_4     = cr.referral_reasons___4_label
  , am.referral_reasons_5     = cr.referral_reasons___5_label
  , am.referral_reasons_6     = cr.referral_reasons___6_label
  , am.referral_reasons_7     = cr.referral_reasons___7_label
  , am.referral_reasons_other = cr.referral_reasons_other
  , am.cr_ra_comments_yn      = get_YN_Label(cr.cr_ra_comments_yn)
  , am.cr_ra_comments         = useTextTransformer(cr.cr_ra_comments)
WHERE cr.redcap_repeat_instance = 1
  AND cr.redcap_event_name = 'wra_followup_visit_arm_1'
  AND am.visit_number = 2.0;

UPDATE arch_follow_up_1_visit_master_v1 am
    LEFT JOIN arch_etl_db.clinical_referral_repeating_instruments cr ON am.record_id = cr.record_id
SET am.cr_refer_to_1            = IF(cr.cr_refer_to = 4, useAutoTrimmer(cr.cr_refer_to_other), cr.cr_refer_to_label)
  , am.cr_refer_to_other_1      = cr.cr_refer_to_other
  , am.referral_reasons_1_1     = cr.referral_reasons___1_label
  , am.referral_reasons_2_1     = cr.referral_reasons___2_label
  , am.referral_reasons_3_1     = cr.referral_reasons___3_label
  , am.referral_reasons_4_1     = cr.referral_reasons___4_label
  , am.referral_reasons_5_1     = cr.referral_reasons___5_label
  , am.referral_reasons_6_1     = cr.referral_reasons___6_label
  , am.referral_reasons_7_1     = cr.referral_reasons___7_label
  , am.referral_reasons_other_1 = cr.referral_reasons_other
  , am.cr_ra_comments_yn_1      = get_YN_Label(cr.cr_ra_comments_yn)
  , am.cr_ra_comments_1         = useTextTransformer(cr.cr_ra_comments)
WHERE cr.redcap_repeat_instance = 2
  AND cr.redcap_event_name = 'wra_followup_visit_arm_1'
  AND am.visit_number = 2.0;

UPDATE arch_follow_up_1_visit_master_v1 am
    LEFT JOIN arch_etl_db.clinical_referral_repeating_instruments cr ON am.record_id = cr.record_id
SET am.cr_refer_to_2            = IF(cr.cr_refer_to = 4, useAutoTrimmer(cr.cr_refer_to_other), cr.cr_refer_to_label)
  , am.cr_refer_to_other_2      = cr.cr_refer_to_other
  , am.referral_reasons_1_2     = cr.referral_reasons___1_label
  , am.referral_reasons_2_2     = cr.referral_reasons___2_label
  , am.referral_reasons_3_2     = cr.referral_reasons___3_label
  , am.referral_reasons_4_2     = cr.referral_reasons___4_label
  , am.referral_reasons_5_2     = cr.referral_reasons___5_label
  , am.referral_reasons_6_2     = cr.referral_reasons___6_label
  , am.referral_reasons_7_2     = cr.referral_reasons___7_label
  , am.referral_reasons_other_2 = cr.referral_reasons_other
  , am.cr_ra_comments_yn_2      = get_YN_Label(cr.cr_ra_comments_yn)
  , am.cr_ra_comments_2         = useTextTransformer(cr.cr_ra_comments)
WHERE cr.redcap_repeat_instance = 3
  AND cr.redcap_event_name = 'wra_followup_visit_arm_1'
  AND am.visit_number = 2.0;

UPDATE arch_follow_up_1_visit_master_v1 am
    LEFT JOIN arch_etl_db.outmigration om ON am.record_id = om.record_id
SET am.om_name_scorres = om.om_name_scorres
  , am.return_scorres  = om.return_scorres_label
  , am.om_comments_yn  = get_YN_Label(om.om_comments_yn)
  , am.om_comments     = useTextTransformer(om.om_comments)
WHERE om.redcap_event_name = 'wra_followup_visit_arm_1'
  AND am.visit_number = 2.0;

UPDATE arch_follow_up_1_visit_master_v1 am
    LEFT JOIN arch_etl_db.wra_study_closure sc ON am.record_id = sc.record_id
SET am.sc_1        = get_YN_Label(sc.sc_1)
  , am.sc_2        = sc.sc_2_label
  , am.sc_3        = get_YN_Label(sc.sc_3)
  , am.sc_5        = get_YN_Label(sc.sc_5)
  , am.sc_6        = sc.sc_6_label
  , am.sc_7        = sc.sc_7_label
  , am.sc_7_other  = sc.sc_7_other
  , am.sc_8        = sc.sc_8
  , am.sc_9        = get_YN_Label(sc.sc_9)
  , am.sc_10       = sc.sc_10_label
  , am.sc_10_other = sc.sc_10_other
  , am.sc_11       = get_YN_Label(sc.sc_11)
  , am.sc_comm_yn  = get_YN_Label(sc.sc_comm_yn)
  , am.sc_comm     = useTextTransformer(sc.sc_comm)
WHERE sc.redcap_event_name = 'wra_followup_visit_arm_1'
  AND am.visit_number = 2.0;