-- Follow Up 4 Overview / Fourth Follow Up Visit
TRUNCATE arch_etl_db.arch_follow_up_4_visit_master;
SET time_zone = '+02:00';
INSERT INTO arch_etl_db.arch_follow_up_4_visit_master( id
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
                                                     , hhc_completed
                                                     , hhc_ha1
                                                     , hhc_ha1_other
                                                     , hhc_ha2
                                                     , hhc_ha2_other
                                                     , hh_numhh_fcorres
                                                     , hh_rms_fcorres
                                                     , hh_sleep_fcorres
                                                     , hh_assets_fcorres_1
                                                     , hh_assets_fcorres_2
                                                     , hh_assets_fcorres_3
                                                     , hh_assets_fcorres_4
                                                     , hh_assets_fcorres_5
                                                     , hh_assets_fcorres_6
                                                     , hh_assets_fcorres_7
                                                     , hh_assets_fcorres_8
                                                     , hh_assets_fcorres_9
                                                     , hh_assets_fcorres_10
                                                     , hh_assets_fcorres_11
                                                     , hh_assets_fcorres_12
                                                     , hh_assets_fcorres_13
                                                     , hh_assets_fcorres_14
                                                     , hh_assets_fcorres_15
                                                     , hh_assets_fcorres_16
                                                     , hh_assets_fcorres_17
                                                     , hh_assets_fcorres_18
                                                     , hh_assets_fcorres_19
                                                     , hh_assets_fcorres_20
                                                     , hh_assets_fcorres_21
                                                     , hh_assets_fcorres_22
                                                     , hh_asset_ownr_1
                                                     , hh_asset_ownr_2
                                                     , hh_asset_ownr_3
                                                     , hh_asset_ownr_4
                                                     , hh_asset_ownr_5
                                                     , hh_asset_ownr_6
                                                     , hh_asset_ownr_7
                                                     , hh_asset_ownr_8
                                                     , hh_asset_ownr_9
                                                     , livestock_fcorres
                                                     , land_fcorres
                                                     , ext_wall_fcorres
                                                     , ext_wall_othr_fcorres
                                                     , floor_fcorres
                                                     , floor_othr_fcorres
                                                     , roof_fcorres
                                                     , roof_spfy_fcorres
                                                     , wash_ob_loc
                                                     , wash_h2o_ob
                                                     , wash_soap_ob_1
                                                     , wash_soap_ob_2
                                                     , wash_soap_ob_3
                                                     , h2o_fcorres
                                                     , h2o_othr_fcorres
                                                     , h2o_loc_fcorres
                                                     , hloc_othr_fcorres
                                                     , minutes
                                                     , h2o_prep_fcorres
                                                     , h2o_hprep_fcorres_1
                                                     , h2o_hprep_fcorres_2
                                                     , h2o_hprep_fcorres_3
                                                     , h2o_hprep_fcorres_4
                                                     , h2o_hprep_fcorres_5
                                                     , h2o_hprep_fcorres_6
                                                     , h2o_hprep_fcorres_96
                                                     , h2o_hprep_fcorres_98
                                                     , h2o_hprep_othr_fcorres
                                                     , toilet_fcorres
                                                     , toilet_othr_fcorres
                                                     , toilet_loc_fcorres
                                                     , toilet_loc_othr_fcorres
                                                     , toilet_share_fcorres
                                                     , toilet_share_num_fcorres
                                                     , obchar_commnts_yn
                                                     , obchar_commnts
                                                     , cooking_inside_fcorres
                                                     , cooking_room_fcorres
                                                     , cooking_loc_fcorres
                                                     , cooking_loc_othr_fcorres
                                                     , cooking_vent_fcorres
                                                     , cooking_fuel_fcorres
                                                     , cooking_fuel_othr_fcorres
                                                     , light_fuel_fcorres
                                                     , light_fuel_othr_fcorres
                                                     , heat_fuel_fcorres
                                                     , heat_fuel_othr_fcorres
                                                     , smoke_hhold_freq_in_oecoccur
                                                     , air_pol_comm_yn
                                                     , air_pol_comm
                                                     , hh_nofd_scorres
                                                     , hh_nofd_frq_scorres
                                                     , hh_nofd_sleep_scorres
                                                     , hh_nofd_sleep_frq_scorres
                                                     , hh_nofd_night_scorres
                                                     , hh_nofd_night_frq_scorres
                                                     , hfs_coyn
                                                     , hfs_coval
                                                     , phq9_interest_scorres
                                                     , phq9_dprs_scorres
                                                     , phq9_sleep_scorres
                                                     , phq9_tired_scorres
                                                     , phq9_app_scorres
                                                     , phq9_bad_scorres
                                                     , phq9_conc_scorres
                                                     , phq9_slow_scorres
                                                     , phq9_hurt_scorres
                                                     , phq9_difficult_scorres
                                                     , phq9_total_scorres
                                                     , zds_depression_sevr
                                                     , ds_is_cr_required
                                                     , phq9_coyn
                                                     , phq9_coval
                                                     , anx_1
                                                     , anx_2
                                                     , anx_3
                                                     , anx_4
                                                     , anx_5
                                                     , anx_6
                                                     , anx_7
                                                     , anx_total_score
                                                     , gad_result
                                                     , anx_comments_yn
                                                     , anx_comments
                                                     , pss_upset_scorres
                                                     , pss_no_ctrl_scorres
                                                     , pss_nervous_scorres
                                                     , pss_confid_scorres
                                                     , pss_yrway_scorres
                                                     , pss_cope_scorres
                                                     , pss_ctrl_scorres
                                                     , pss_ontop_scorres
                                                     , pss_anger_scorres
                                                     , pss_dfclt_scorres
                                                     , pss_total_scorres
                                                     , sa_zassessment_result
                                                     , pss_coyn
                                                     , ss_comments
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
SELECT v5.alternate_id                             as id
     , v5.record_id
     , v5.visit_number
     , v5.visit_name
     , v5.visit_outcome
     , v5.screening_id                             as hh_scrn_num_obsloc
     , CAST(f4.redcap_repeat_instance as UNSIGNED) as wra_enr_visit_count
     , CAST(f4.fu_attempt_count_f4 as UNSIGNED)    as attempt_count
     , CAST(f4.hhe_hh_member_id_f4 as UNSIGNED)    as hhe_hh_member_id
     , f4.wra_fu_visit_date_f4                     as scrn_obsstdat
     , f4.wra_fu_interviewer_obsloc_f4             as wra_enr_interviewer_obsloc
     , f4.wra_fu_conf_consent_f4                   as wra_enr_hhh_pvc
     , f4.wra_fu_reas_decline_const_f4             as wra_enr_reas_decline
     , f4.wra_fu_pp_avail_f4                       as wra_enr_pp_avail
     , f4.wra_fu_is_wra_avail_other_f4             as is_wra_avail_other
     , v5.wra_ptid                                 as wra_ptid
     , f4.fu_c19vax_cmyn_f4                        as c19vax_cmyn
     , f4.fu_c19vax_cmtrt_f4                       as c19vax_cmtrt
     , f4.fu_covid_scrn_3_f4                       as covid_scrn_3
     , f4.fu_c19_lbperf_f4                         as c19_lbperf
     , ''                                          as covid_test_dt_range
     , f4.fu_c19_lbdat_f4                          as c19_lbdat
     , f4.fu_c19_lborres_f4                        as c19_lborres
     , f4.fu_fever_ceoccur_f4                      as fever_ceoccur
     , f4.fu_cough_ceoccur_f4                      as cough_ceoccur
     , f4.fu_shortbreath_ceoccur_f4                as shortbreath_ceoccur
     , f4.fu_sorethroat_ceoccur_f4                 as sorethroat_ceoccur
     , f4.fu_fatigue_ceoccur_f4                    as fatigue_ceoccur
     , f4.fu_myalgia_ceoccur_f4                    as myalgia_ceoccur
     , f4.fu_anorexia_ceoccur_f4                   as anorexia_ceoccur
     , f4.fu_nausea_ceoccur_f4                     as nausea_ceoccur
     , f4.fu_diarrhoea_ceoccur_f4                  as diarrhoea_ceoccur
     , f4.fu_ageusia_ceoccur_f4                    as ageusia_ceoccur
     , f4.fu_anosmia_ceoccur_f4                    as anosmia_ceoccur
     , f4.fu_runnynose_ceoccur_f4                  as runnynose_ceoccur
     , f4.fu_sneeze_ceoccur_f4                     as sneeze_ceoccur
     , f4.fu_headache_ceoccur_f4                   as headache_ceoccur
     , f4.fu_rash_ceoccur_f4                       as rash_ceoccur
     , f4.fu_conjunct_ceoccur_f4                   as conjunct_ceoccur
     , f4.fu_c19_contact_dx_ceoccur_f4             as c19_contact_dx_ceoccur
     , f4.fu_c19_contact_sx_ceoccur_f4             as c19_contact_sx_ceoccur
     , f4.fu_hh_member_id_f4                       as hh_member_id
     , f4.fu_covid_scrn_9_f4                       as covid_scrn_9
     , f4.fu_c19_zm_scorres_f4                     as c19_zm_scorres
     , f4.fu_covid_scrn_comments_yn_f4             as covid_scrn_comments_yn
     , f4.fu_covid_scrn_comments_f4                as covid_scrn_comments
     , f4.fu_loc_same_hh_lv_f4                     as fu_loc_same_hh_lv
     , f4.wra_fu_cluster_new_f4                   as wra_fu_cluster_prev
     , f4.wra_fu_sbn_new_f4                       as wra_fu_sbn_prev
     , f4.wra_fu_hun_new_f4                       as wra_fu_hun_prev
     , f4.wra_fu_hhn_new_f4                       as wra_fu_hhn_prev
     , f4.wra_fu_prev_screening_id_f4              as wra_fu_prev_screening_id
     , f4.wra_fu_hh_screening_id_f4                as wra_fu_hh_screening_id
     , f4.loc_fu_mig_to_scorres_f4                 as loc_fu_mig_to_scorres
     , f4.loc_fu_loc_known_f4                      as loc_fu_loc_known
     , f4.loc_fu_locality_name_f4                  as loc_fu_locality_name
     , f4.loc_fu_newloc_scorres_yn_f4              as loc_fu_newloc_scorres_yn
     , f4.loc_fu_newloc_scorres_f4                 as loc_fu_newloc_scorres
     , f4.loc_fu_newloc_landmark_f4                as loc_fu_newloc_landmark
     , f4.loc_fu_loc_landmarks_f4                  as loc_fu_loc_landmarks
     , f4.loc_fu_loc_direction_f4                  as loc_fu_loc_direction
     , f4.loc_fu_new_directions_f4                 as loc_fu_new_directions
     , f4.loc_fu_mig_dat_scorres_f4                as loc_fu_mig_dat_scorres
     , f4.loc_fu_fc_corr_f4                        as loc_fc_num
     , f4.loc_fu_pn_belongs_othr_f4                as loc_pn_belongs_oth
     , f4.loc_fu_who_is_caller_f4                  as loc_who_is_caller
     , f4.loc_fu_pn_belongs_f4                     as loc_pn_belongs
     , f4.loc_fu_fc_corr_2_f4                      as loc_sc_num
     , f4.loc_fu_pn_belongs_2_f4                   as loc_pn_belongs_2
     , f4.loc_fu_pn_belongs_othr_2_f4              as loc_pn_belongs_oth_2
     , f4.loc_fu_who_is_caller_2_f4                as loc_who_is_caller_2
     , f4.loc_fu_enrolled_zapps_f4                 as loc_enrolled_zapps
     , f4.loc_fu_zapps_ptid_f4                     as loc_zapps_ptid
     , f4.loc_fu_zapps_ptid_src_f4                 as loc_zapps_ptid_src
     , f4.fu_famliid_yn_f4                         as famliid_yn
     , f4.fu_famli_id_scorres_f4                   as famli_id_scorres
     , f4.fu_famli_id_scorres_f4                   as loc_famli_id_src
     , f4.wra_fu_comments_yn_f4                    as loc_comments_yn
     , f4.wra_fu_comments_f4                       as loc_comments
     , f4.fu_scdmar_scorres_f4                     as scdmar_scorres
     , f4.scd_fu_agemar_scorres_f4                 as scd_agemar_scorres
     , f4.fu_school_scorres_f4                     as school_scorres
     , f4.fu_sd_highest_edu_level_f4               as sd_highest_edu_level
     , f4.fu_school_yrs_scorres_f4                 as school_yrs_scorres
     , f4.fu_scd_occupation_scorres_f4             as scd_occupation_scorres
     , f4.fu_sd_approx_income_pay_f4               as sd_approx_income_pay
     , f4.fu_scd_mobile_fcorres_f4                 as scd_mobile_fcorres
     , f4.fu_scd_mh_tob_suyn_f4                    as scd_mh_tob_suyn
     , f4.fu_scd_mh_tob_sudosfrq_f4                as scd_mh_tob_sudosfrq
     , f4.fu_scd_tob_chew_sutrt_f4                 as scd_tob_chew_sutrt
     , f4.fu_scd_alc_suyn_f4                       as scd_alc_suyn
     , f4.fu_scd_comments_yn_f4                    as scd_comments_yn
     , f4.fu_scd_comments_f4                       as scd_comments
     , f4.hhc_completed_f4                         as hhc_completed
     , f4.hhc_ha1_f4                               as hhc_ha1
     , f4.hhc_ha1_other_f4                         as hhc_ha1_other
     , f4.hhc_ha2_f4                               as hhc_ha2
     , f4.hhc_ha2_other_f4                         as hhc_ha2_other
     , f4.hh_numhh_fcorres_f4                      as hh_numhh_fcorres
     , f4.hh_rms_fcorres_f4                        as hh_rms_fcorres
     , f4.hh_sleep_fcorres_f4                      as hh_sleep_fcorres
     , f4.hh_assets_fcorres_f4___1                 as hh_assets_fcorres_1
     , f4.hh_assets_fcorres_f4___2                 as hh_assets_fcorres_2
     , f4.hh_assets_fcorres_f4___3                 as hh_assets_fcorres_3
     , f4.hh_assets_fcorres_f4___4                 as hh_assets_fcorres_4
     , f4.hh_assets_fcorres_f4___5                 as hh_assets_fcorres_5
     , f4.hh_assets_fcorres_f4___6                 as hh_assets_fcorres_6
     , f4.hh_assets_fcorres_f4___7                 as hh_assets_fcorres_7
     , f4.hh_assets_fcorres_f4___8                 as hh_assets_fcorres_8
     , f4.hh_assets_fcorres_f4___9                 as hh_assets_fcorres_9
     , f4.hh_assets_fcorres_f4___10                as hh_assets_fcorres_10
     , f4.hh_assets_fcorres_f4___11                as hh_assets_fcorres_11
     , f4.hh_assets_fcorres_f4___12                as hh_assets_fcorres_12
     , f4.hh_assets_fcorres_f4___13                as hh_assets_fcorres_13
     , f4.hh_assets_fcorres_f4___14                as hh_assets_fcorres_14
     , f4.hh_assets_fcorres_f4___15                as hh_assets_fcorres_15
     , f4.hh_assets_fcorres_f4___16                as hh_assets_fcorres_16
     , f4.hh_assets_fcorres_f4___17                as hh_assets_fcorres_17
     , f4.hh_assets_fcorres_f4___18                as hh_assets_fcorres_18
     , f4.hh_assets_fcorres_f4___19                as hh_assets_fcorres_19
     , f4.hh_assets_fcorres_f4___20                as hh_assets_fcorres_20
     , f4.hh_assets_fcorres_f4___21                as hh_assets_fcorres_21
     , f4.hh_assets_fcorres_f4___22                as hh_assets_fcorres_22
     , f4.hh_asset_ownr_f4___1                     as hh_asset_ownr_1
     , f4.hh_asset_ownr_f4___2                     as hh_asset_ownr_2
     , f4.hh_asset_ownr_f4___3                     as hh_asset_ownr_3
     , f4.hh_asset_ownr_f4___4                     as hh_asset_ownr_4
     , f4.hh_asset_ownr_f4___5                     as hh_asset_ownr_5
     , f4.hh_asset_ownr_f4___6                     as hh_asset_ownr_6
     , f4.hh_asset_ownr_f4___7                     as hh_asset_ownr_7
     , f4.hh_asset_ownr_f4___8                     as hh_asset_ownr_8
     , f4.hh_asset_ownr_f4___9                     as hh_asset_ownr_9
     , f4.livestock_fcorres_f4                     as livestock_fcorres
     , f4.land_fcorres_f4                          as land_fcorres
     , f4.ext_wall_fcorres_f4                      as ext_wall_fcorres
     , f4.ext_wall_othr_fcorres_f4                 as ext_wall_othr_fcorres
     , f4.floor_fcorres_f4                         as floor_fcorres
     , f4.floor_othr_fcorres_f4                    as floor_othr_fcorres
     , f4.roof_fcorres_f4                          as roof_fcorres
     , f4.roof_spfy_fcorres_f4                     as roof_spfy_fcorres
     , f4.wash_ob_loc_f4                           as wash_ob_loc
     , f4.wash_h2o_ob_f4                           as wash_h2o_ob
     , f4.wash_soap_ob_f4___1                      as wash_soap_ob_1
     , f4.wash_soap_ob_f4___2                      as wash_soap_ob_2
     , f4.wash_soap_ob_f4___3                      as wash_soap_ob_3
     , f4.h2o_fcorres_f4                           as h2o_fcorres
     , f4.h2o_othr_fcorres_f4                      as h2o_othr_fcorres
     , f4.h2o_loc_fcorres_f4                       as h2o_loc_fcorres
     , f4.hloc_othr_fcorres_f4                     as hloc_othr_fcorres
     , f4.minutes_f4                               as minutes
     , f4.h2o_prep_fcorres_f4                      as h2o_prep_fcorres
     , f4.h2o_hprep_fcorres_f4___1                 as h2o_hprep_fcorres_1
     , f4.h2o_hprep_fcorres_f4___2                 as h2o_hprep_fcorres_2
     , f4.h2o_hprep_fcorres_f4___3                 as h2o_hprep_fcorres_3
     , f4.h2o_hprep_fcorres_f4___4                 as h2o_hprep_fcorres_4
     , f4.h2o_hprep_fcorres_f4___5                 as h2o_hprep_fcorres_5
     , f4.h2o_hprep_fcorres_f4___6                 as h2o_hprep_fcorres_6
     , f4.h2o_hprep_fcorres_f4___96                as h2o_hprep_fcorres_96
     , f4.h2o_hprep_fcorres_f4___98                as h2o_hprep_fcorres_98
     , f4.h2o_hprep_othr_fcorres_f4                as h2o_hprep_othr_fcorres
     , f4.toilet_fcorres_f4                        as toilet_fcorres
     , f4.toilet_othr_fcorres_f4                   as toilet_othr_fcorres
     , f4.toilet_loc_fcorres_f4                    as toilet_loc_fcorres
     , f4.toilet_loc_othr_fcorres_f4               as toilet_loc_othr_fcorres
     , f4.toilet_share_fcorres_f4                  as toilet_share_fcorres
     , f4.toilet_share_num_fcorres_f4              as toilet_share_num_fcorres
     , f4.obchar_commnts_yn_f4                     as obchar_commnts_yn
     , f4.obchar_commnts_f4                        as obchar_commnts
     , f4.cooking_inside_fcorres_f4                as cooking_inside_fcorres
     , f4.cooking_room_fcorres_f4                  as cooking_room_fcorres
     , f4.cooking_loc_fcorres_f4                   as cooking_loc_fcorres
     , f4.cooking_loc_othr_fcorres_f4              as cooking_loc_othr_fcorres
     , f4.cooking_vent_fcorres_f4                  as cooking_vent_fcorres
     , f4.cooking_fuel_fcorres_f4                  as cooking_fuel_fcorres
     , f4.cooking_fuel_othr_fcorres_f4             as cooking_fuel_othr_fcorres
     , f4.light_fuel_fcorres_f4                    as light_fuel_fcorres
     , f4.light_fuel_othr_fcorres_f4               as light_fuel_othr_fcorres
     , f4.heat_fuel_fcorres_f4                     as heat_fuel_fcorres
     , f4.heat_fuel_othr_fcorres_f4                as heat_fuel_othr_fcorres
     , f4.smoke_hhold_freq_in_oecoccur_f4          as smoke_hhold_freq_in_oecoccur
     , f4.air_pol_comm_yn_f4                       as air_pol_comm_yn
     , f4.air_pol_comm_f4                          as air_pol_comm
     , f4.fu_hh_nofd_scorres_f4                    as hh_nofd_scorres
     , f4.fu_hh_nofd_frq_scorres_f4                as hh_nofd_frq_scorres
     , f4.fu_hh_nofd_sleep_scorres_f4              as hh_nofd_sleep_scorres
     , f4.fu_hh_nofd_sleep_frq_f4                  as hh_nofd_sleep_frq_scorres
     , f4.fu_hh_nofd_night_scorres_f4              as hh_nofd_night_scorres
     , f4.fu_hh_nofd_night_scorres_f4              as hh_nofd_night_frq_scorres
     , f4.fu_hfs_coyn_f4                           as hfs_coyn
     , f4.fu_hfs_coval_f4                          as hfs_coval
     , mha.phq9_interest_scorres
     , mha.phq9_dprs_scorres
     , mha.phq9_sleep_scorres
     , mha.phq9_tired_scorres
     , mha.phq9_app_scorres
     , mha.phq9_bad_scorres
     , mha.phq9_conc_scorres
     , mha.phq9_slow_scorres
     , mha.phq9_hurt_scorres
     , mha.phq9_difficult_scorres
     , CAST(mha.phq9_total_scorres as UNSIGNED)    as phq9_total_scorres
     , mha.zds_depression_sevr
     , CAST(mha.ds_is_cr_required as UNSIGNED)     as ds_is_cr_required
     , mha.phq9_coyn
     , mha.phq9_coval
     , mha.anx_1
     , mha.anx_2
     , mha.anx_3
     , mha.anx_4
     , mha.anx_5
     , mha.anx_6
     , mha.anx_7
     , CAST(mha.anx_total_score as UNSIGNED)       as anx_total_score
     , mha.gad_result
     , mha.anx_comments_yn
     , mha.anx_comments
     , mha.pss_upset_scorres
     , mha.pss_no_ctrl_scorres
     , mha.pss_nervous_scorres
     , mha.pss_confid_scorres
     , mha.pss_yrway_scorres
     , mha.pss_cope_scorres
     , mha.pss_ctrl_scorres
     , mha.pss_ontop_scorres
     , mha.pss_anger_scorres
     , mha.pss_dfclt_scorres
     , CAST(mha.pss_total_scorres as UNSIGNED)     as pss_total_scorres
     , mha.sa_zassessment_result
     , mha.pss_coyn
     , mha.ss_comments
     , ps.fu_lmp_reg_scorres_f4                    as lmp_reg_scorres
     , ps.fu_lmp_kd_scorres_f4                     as lmp_kd_scorres
     , ps.lmp_kd_scorres_othr_f4                   as lmp_kd_scorres_other
     , ps.fu_lmp_start_scorres_f4                  as lmp_start_scorres
     , ps.fu_lmp_scdat_f4                          as lmp_scdat
     , ps.fu_lmp_cat_scorres_f4                    as lmp_cat_scorres
     , ps.fu_lmp_start_weeks_f4                    as lmp_start_weeks
     , ps.fu_lmp_start_months_f4                   as lmp_start_months
     , ps.fu_lmp_start_years_f4                    as lmp_start_years
     , ps.fu_lmp_scorres_f4                        as lmp_scorres
     , ps.fu_ps_mens_cal_yn_f4                     as ps_mens_cal_yn
     , ps.fu_lmp_dt_rec_cal_f4                     as lmp_dt_rec_cal
     , ps.fu_preg_scorres_f4                       as preg_scorres
     , ps.fu_month_preg_scorres_f4                 as months_preg_scorres
     , ps.fu_np_pregid_mhyn_f4                     as np_pregid_mhyn
     , ps.fu_np_date_of_test_f4                    as np_date_of_test
     , ps.fu_np_date_of_test_2_f4                  as np_date_of_test_2
     , ps.fu_np_us_test_dat_f4                     as np_us_test_dat
     , ps.fu_np_bld_test_dat_f4                    as np_bld_test_dat
     , ps.ps_fu_pregnancy_id_f4                    as ps_pregnancy_id
     , ps.fu_np_us_edd_dat_f4                      as np_us_edd_dat
     , ps.fu_np_edd_src_f4                         as np_edd_src
     , ps.ps_fu_last_upt_f4                        as ps_fu_last_upt
     , ps.ps_fu_zapps_enr_f4                       as ps_fu_zapps_enr
     , ps.ps_fu_pregnancy_id_f4                    as ps_fu_pregnancy_id
     , ps.ps_preg_last_visit_f4                    as ps_preg_last_visit
     , ps.ps_same_preg_lv_f4                       as ps_same_preg_lv
     , ps.ps_fu_danger_signs_f4___1                as ps_fu_danger_signs___1
     , ps.ps_fu_danger_signs_f4___2                as ps_fu_danger_signs___2
     , ps.ps_fu_danger_signs_f4___3                as ps_fu_danger_signs___3
     , ps.ps_fu_danger_signs_f4___4                as ps_fu_danger_signs___4
     , ps.ps_fu_danger_signs_f4___5                as ps_fu_danger_signs___5
     , ps.ps_fu_danger_signs_f4___6                as ps_fu_danger_signs___6
     , ps.ps_fu_danger_signs_f4___7                as ps_fu_danger_signs___7
     , ps.ps_preg_times_f4                         as ps_preg_times
     , ps.fu_preg_surv_comm_yn_f4                  as preg_surv_comm
     , ps.fu_preg_surv_comm_f4                     as preg_surv_commnts
FROM crt_wra_visit_5_overview v5
         LEFT JOIN wra_follow_up_visit_4_repeating_instruments f4
                   ON v5.alternate_id = f4.wra_follow_up_visit_4_repeating_instruments_id
         LEFT JOIN wra_mental_health_assessment mha ON v5.record_id = mha.record_id
         LEFT JOIN wrafu_pregnancy_surveillance_4 ps ON v5.record_id = ps.record_id
WHERE mha.redcap_event_name = 'wra_followup_visit_arm_1d';


UPDATE arch_follow_up_4_visit_master am
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
WHERE poc.redcap_event_name = 'wra_followup_visit_arm_1d';

UPDATE arch_follow_up_4_visit_master am
    LEFT JOIN arch_etl_db.wrafu_pregnancy_assessments_4 pa ON am.record_id = pa.record_id
SET am.poa_ant_preg            = pa.poa_ant_preg_f4
  , am.poa_ant_att             = pa.poa_ant_att_f4
  , am.poa_ant_count           = pa.poa_ant_count_f4
  , am.poa_fetus_count         = pa.poa_fetus_count_f4
  , am.poa_preg_outcome        = pa.poa_preg_outcome_f4
  , am.poa_preg_dev_outcome    = pa.poa_preg_dev_outcome_f4
  , am.poa_mae_pregend_date    = pa.poa_mae_pregend_date_f4
  , am.poa_preg_dur            = pa.poa_preg_dur_f4
  , am.poa_preg_dur_weeks      = pa.poa_preg_dur_weeks_f4
  , am.poa_preg_dur_months     = pa.poa_preg_dur_months_f4
  , am.poa_pregdev_date        = pa.poa_pregdev_date_f4
  , am.poa_pregdev_dur         = pa.poa_pregdev_dur_f4
  , am.poa_pregdev_dur_weeks   = pa.poa_pregdev_dur_weeks_f4
  , am.poa_pregdev_dur_months  = pa.poa_pregdev_dur_months_f4
  , am.poa_comments_yn         = pa.poa_comments_yn_f4
  , am.poa_comments            = pa.poa_comments_f4
  , am.np_zapps_scorres        = pa.np_fu_zapps_scorres_f4
  , am.np_zapps_ptid           = pa.np_fu_zapps_ptid_f4
  , am.np_zapps_id_src         = pa.np_fu_zapps_id_src_f4
  , am.np_ident_arch           = pa.np_fu_ident_arch_f4
  , am.np_ptw_1                = pa.np_fu_ptw_f4___1
  , am.np_ptw_2                = pa.np_fu_ptw_f4___2
  , am.np_ptw_3                = pa.np_fu_ptw_f4___3
  , am.np_ptw_4                = pa.np_fu_ptw_f4___4
  , am.np_ptw_5                = pa.np_fu_ptw_f4___5
  , am.np_ptw_6                = pa.np_fu_ptw_f4___6
  , am.np_ptw_7                = pa.np_fu_ptw_f4___7
  , am.np_anc_mhyn             = pa.np_fu_anc_mhyn_f4
  , am.np_anc_num_mh           = pa.np_fu_anc_num_mh_f4
  , am.np_anc1_dat             = pa.np_fu_anc1_dat_f4
  , am.np_anc1_ga              = pa.np_fu_anc1_ga_f4
  , am.anc1_ga_weeks           = pa.fu_anc1_ga_weeks_f4
  , am.anc1_ga_months          = pa.fu_anc1_ga_months_f4
  , am.np_anc_plan_obsloc      = pa.np_fu_anc_plan_obsloc_f4
  , am.birth_plan_fac_obsloc   = pa.fu_birth_plan_fac_obsloc_f4
  , am.facility_other          = pa.fu_facility_other_f4
  , am.birth_other_loc         = pa.fu_birth_other_loc_f4
  , am.np_del_decide_scorres   = pa.np_fu_del_decide_scorres_f4
  , am.del_decide_spfy_scorres = pa.fu_del_decide_spfy_scorres_f4
  , am.cph_comments_yn         = pa.np_fu_comments_yn_f4
  , am.cph_comments            = pa.np_fu_comments_f4
  , am.np_alc_suyn             = pa.np_fu_alc_suyn_f4
  , am.np_alc_cons             = pa.np_fu_alc_cons_f4
  , am.np_tob_suyn             = pa.np_fu_tob_suyn_f4
  , am.np_tob_cur_sudosfrq     = pa.np_fu_tob_curr_sudosfrq_f4
  , am.tob_oth_sutrt_1         = pa.fu_tob_oth_stutrt_f4___1
  , am.tob_oth_sutrt_2         = pa.fu_tob_oth_stutrt_f4___2
  , am.tob_oth_sutrt_3         = pa.fu_tob_oth_stutrt_f4___3
  , am.tob_oth_sutrt_4         = pa.fu_tob_oth_stutrt_f4___4
  , am.tob_oth_sutrt_5         = pa.fu_tob_oth_stutrt_f4___5
  , am.tob_oth_sutrt_6         = pa.fu_tob_oth_stutrt_f4___6
  , am.tob_oth_sutrt_7         = pa.fu_tob_oth_stutrt_f4___7
  , am.other_tbc_use           = pa.fu_other_tbc_use_f4
  , am.np_drug_suyn            = pa.np_fu_drug_suyn_f4
  , am.np_drug_usage           = pa.np_fu_drug_usage_f4
  , am.np_drug_sutrt_1         = pa.np_fu_drug_sutrt_f4___1
  , am.np_drug_sutrt_2         = pa.np_fu_drug_sutrt_f4___2
  , am.np_drug_sutrt_3         = pa.np_fu_drug_sutrt_f4___3
  , am.np_drug_sutrt_4         = pa.np_fu_drug_sutrt_f4___4
  , am.np_drug_sutrt_5         = pa.np_fu_drug_sutrt_f4___5
  , am.np_drug_sutrt_6         = pa.np_fu_drug_sutrt_f4___6
  , am.np_drug_sutrt_7         = pa.np_fu_drug_sutrt_f4___7
  , am.np_drug_sutrt_othr      = pa.np_fu_drug_sutrt_othr_f4
  , am.hbp_comments_yn         = pa.hbp_fu_comments_yn_f4
  , am.hbp_comments            = pa.hbp_fu_comments_f4
  , am.name_veri               = pa.fu_name_veri_f4
  , am.brthdat_veri            = pa.fu_brthdat_veri_f4
  , am.ref_likely_scorres      = pa.fu_ref_likely_scorres_f4
  , am.ref_res_decline_1       = pa.fu_ref_res_decline_f4___1
  , am.ref_res_decline_2       = pa.fu_ref_res_decline_f4___2
  , am.ref_res_decline_3       = pa.fu_ref_res_decline_f4___3
  , am.ref_res_decline_4       = pa.fu_ref_res_decline_f4___4
  , am.ref_res_decline_5       = pa.fu_ref_res_decline_f4___5
  , am.ref_res_decline_6       = pa.fu_ref_res_decline_f4___6
  , am.zr_2_other              = pa.zr_fu_reas_other_f4
  , am.pref_zapps_scorres      = pa.zr_fu_pref_zapps_scorres_f4
  , am.apnt_dat_scorres        = pa.zr_fu_apnt_dat_scorres_f4
  , am.zr_confirm_contact      = pa.zr_fu_confirm_contact_f4
  , am.preg_test               = pa.fu_preg_test_f4
  , am.zr_wra_ptid             = pa.zr_fu_wra_ptid_f4
  , am.zr_comm_yn              = pa.zr_fu_comments_yn_f4
  , am.zr_comm                 = pa.zr_fu_comments_f4
WHERE (pa.poa_ant_preg_f4 IS NOT NULL OR pa.np_fu_zapps_scorres_f4 IS NOT NULL
    OR pa.fu_name_veri_f4 IS NOT NULL)
  AND am.visit_number = 5.0;

UPDATE arch_follow_up_4_visit_master am
    LEFT JOIN arch_etl_db.infant_outcome_assessment_4_repeating_instruments io ON am.record_id = io.record_id
SET am.ioa_infant_name     = io.ioa_infant_name_f4,
    am.ioa_infant_ptid     = CONCAT_WS('-', am.wra_ptid, useAutoTrimmer(io.ioa_infant_name_f4)),
    am.ioa_infant_sex      = io.ioa_infant_sex_f4,
    am.ioa_infant_alive    = io.ioa_infant_alive_f4,
    am.ioa_infant_age_days = io.ioa_infant_age_days_f4,
    am.ioa_infant_age_days = io.ioa_infant_age_months_f4,
    am.ioa_infant_age_days = io.ioa_infant_age_death_days_f4,
    am.ioa_infant_age_days = io.ioa_infant_age_death_months_f4
WHERE io.redcap_repeat_instance = 1
  AND io.redcap_event_name = 'wra_followup_visit_arm_1d'
  AND am.visit_number = 5.0;

UPDATE arch_follow_up_4_visit_master am
    LEFT JOIN arch_etl_db.infant_outcome_assessment_4_repeating_instruments io ON am.record_id = io.record_id
SET am.ioa_infant_name_2     = io.ioa_infant_name_f4,
    am.ioa_infant_ptid_2     = CONCAT_WS('-', am.wra_ptid, useAutoTrimmer(io.ioa_infant_name_f4)),
    am.ioa_infant_sex_2      = io.ioa_infant_sex_f4,
    am.ioa_infant_alive_2    = io.ioa_infant_alive_f4,
    am.ioa_infant_age_days_2 = io.ioa_infant_age_days_f4,
    am.ioa_infant_age_days_2 = io.ioa_infant_age_months_f4,
    am.ioa_infant_age_days_2 = io.ioa_infant_age_death_days_f4,
    am.ioa_infant_age_days_2 = io.ioa_infant_age_death_months_f4
WHERE io.redcap_repeat_instance = 2
  AND io.redcap_event_name = 'wra_followup_visit_arm_1d'
  AND am.visit_number = 5.0;


UPDATE arch_follow_up_4_visit_master am
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

UPDATE arch_follow_up_4_visit_master am
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
  AND cr.redcap_event_name = 'wra_followup_visit_arm_1d'
  AND am.visit_number = 5.0;

UPDATE arch_follow_up_4_visit_master am
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
  AND cr.redcap_event_name = 'wra_followup_visit_arm_1d'
  AND am.visit_number = 5.0;

UPDATE arch_follow_up_4_visit_master am
    LEFT JOIN arch_etl_db.outmigration om ON am.record_id = om.record_id
SET am.om_name_scorres        = om.om_name_scorres
  , am.return_scorres        = om.return_scorres
  , am.om_comments_yn        = om.om_comments_yn
  , am.om_comments        = om.om_comments
WHERE om.redcap_event_name = 'wra_followup_visit_arm_1d'
  AND am.visit_number = 5.0;

UPDATE arch_follow_up_4_visit_master am
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
WHERE sc.redcap_event_name = 'wra_followup_visit_arm_1d'
  AND am.visit_number = 5.0;