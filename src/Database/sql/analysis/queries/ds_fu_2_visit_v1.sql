-- Follow Up 2 Overview
TRUNCATE arch_etl_db.arch_follow_up_2_visit_master_v1;
SET time_zone = '+02:00';
INSERT INTO arch_etl_db.arch_follow_up_2_visit_master_v1( id
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
                                                        , ps_preg_dur
                                                        , months_preg_scorres
                                                        , weeks_preg_scorres
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
SELECT v3.alternate_id                                                                               as id
     , v3.record_id
     , v3.visit_number
     , v3.visit_name
     , v3.visit_outcome
     , v3.screening_id                                                                               as hh_scrn_num_obsloc
     , CAST(f2.redcap_repeat_instance as UNSIGNED)                                                   as wra_enr_visit_count
     , CAST(f2.attempt_count_f2 as UNSIGNED)                                                         as attempt_count
     , CAST(f2.hhe_hh_member_id_f2 as UNSIGNED)                                                      as hhe_hh_member_id
     , f2.scrn_obsstdat_f2                                                                           as scrn_obsstdat
     , f2.wra_enr_interviewer_obsloc_f2                                                              as wra_enr_interviewer_obsloc
     , get_YN_Label(f2.wra_fu_conf_consent_f2)                                                       as wra_enr_hhh_pvc
     , f2.wra_fu_reas_decline_f2                                                                     as wra_enr_reas_decline
     , f2.wra_enr_pp_avail_f2_label                                                                  as wra_enr_pp_avail
     , f2.wra_fu_is_wra_avail_other_f2                                                               as is_wra_avail_other
     , v3.wra_ptid                                                                                   as wra_ptid
     , f2.c19vax_cmyn_f2_label                                                                       as c19vax_cmyn
     , f2.c19vax_cmtrt_f2_label                                                                      as c19vax_cmtrt
     , f2.covid_scrn_3_f2_label                                                                      as covid_scrn_3
     , get_YN_Label(f2.c19_lbperf_f2)                                                                as c19_lbperf
     , ''                                                                                            as covid_test_dt_range
     , f2.c19_lbdat_f2                                                                               as c19_lbdat
     , f2.c19_lborres_f2_label                                                                       as c19_lborres
     , f2.fever_ceoccur_f2_label                                                                     as fever_ceoccur
     , f2.cough_ceoccur_f2_label                                                                     as cough_ceoccur
     , f2.shortbreath_ceoccur_f2_label                                                               as shortbreath_ceoccur
     , f2.sorethroat_ceoccur_f2_label                                                                as sorethroat_ceoccur
     , f2.fatigue_ceoccur_f2_label                                                                   as fatigue_ceoccur
     , f2.myalgia_ceoccur_f2_label                                                                   as myalgia_ceoccur
     , f2.anorexia_ceoccur_f2_label                                                                  as anorexia_ceoccur
     , f2.nausea_ceoccur_f2_label                                                                    as nausea_ceoccur
     , f2.diarrhoea_ceoccur_f2_label                                                                 as diarrhoea_ceoccur
     , f2.ageusia_ceoccur_f2_label                                                                   as ageusia_ceoccur
     , f2.anosmia_ceoccur_f2_label                                                                   as anosmia_ceoccur
     , f2.runnynose_ceoccur_f2_label                                                                 as runnynose_ceoccur
     , f2.sneeze_ceoccur_f2_label                                                                    as sneeze_ceoccur
     , f2.headache_ceoccur_f2_label                                                                  as headache_ceoccur
     , f2.rash_ceoccur_f2_label                                                                      as rash_ceoccur
     , f2.conjunct_ceoccur_f2_label                                                                  as conjunct_ceoccur
     , f2.c19_contact_dx_ceoccur_f2_label                                                            as c19_contact_dx_ceoccur
     , f2.c19_contact_sx_ceoccur_f2_label                                                            as c19_contact_sx_ceoccur
     , f2.hh_member_id_f2                                                                            as hh_member_id
     , get_YN_Label(f2.covid_scrn_9_f2)                                                              as covid_scrn_9
     , get_YN_Label(f2.c19_zm_scorres_f2)                                                            as c19_zm_scorres
     , get_YN_Label(f2.covid_scrn_comments_yn_f2)                                                    as covid_scrn_comments_yn
     , f2.covid_scrn_comments_f2                                                                     as covid_scrn_comments
     , get_YN_Label(f2.fu_loc_same_hh_lv_f2)                                                         as fu_loc_same_hh_lv
     , f2.wra_fu_cluster_new                                                                         as wra_fu_cluster_prev
     , f2.wra_fu_sbn_new_label                                                                       as wra_fu_sbn_prev
     , f2.wra_fu_hun_new_label                                                                       as wra_fu_hun_prev
     , f2.wra_fu_hhn_new_label                                                                       as wra_fu_hhn_prev
     , f2.wra_fu_new_screening_id                                                                    as wra_fu_prev_screening_id
     , f2.wra_fu_hh_screening_id_f2                                                                  as wra_fu_hh_screening_id
     , f2.loc_fu_mig_to_scorres_f2_label                                                             as loc_fu_mig_to_scorres
     , get_YN_Label(f2.loc_fu_loc_known_f2)                                                          as loc_fu_loc_known
     , f2.loc_fu_locality_name_f2                                                                    as loc_fu_locality_name
     , get_YN_Label(f2.loc_fu_newloc_scorres_yn_f2)                                                  as loc_fu_newloc_scorres_yn
     , f2.loc_fu_newloc_scorres_f2                                                                   as loc_fu_newloc_scorres
     , f2.loc_fu_newloc_landmark_f2                                                                  as loc_fu_newloc_landmark
     , f2.loc_fu_loc_landmarks_f2                                                                    as loc_fu_loc_landmarks
     , f2.loc_fu_loc_direction_f2                                                                    as loc_fu_loc_direction
     , f2.loc_fu_new_directions_f2                                                                   as loc_fu_new_directions
     , f2.loc_fu_mig_dat_scorres_f2                                                                  as loc_fu_mig_dat_scorres
     , f2.loc_fu_fc_corr_f2                                                                          as loc_fc_num
     , f2.loc_fu_pn_belongs_othr_f2                                                                  as loc_pn_belongs_oth
     , f2.loc_fu_who_is_caller_f2                                                                    as loc_who_is_caller
     , f2.loc_fu_pn_belongs_f2_label                                                                 as loc_pn_belongs
     , get_YN_Label(f2.loc_fu_fc_corr_2_f2)                                                          as loc_sc_num
     , f2.loc_fu_pn_belongs_2_f2_label                                                               as loc_pn_belongs_2
     , f2.loc_fu_pn_belongs_othr_2_f2                                                                as loc_pn_belongs_oth_2
     , f2.loc_fu_who_is_caller_2_f2                                                                  as loc_who_is_caller_2
     , get_YN_Label(f2.loc_fu_enrolled_zapps_f2)                                                     as loc_enrolled_zapps
     , f2.loc_fu_zapps_ptid_f2                                                                       as loc_zapps_ptid
     , f2.loc_fu_zapps_ptid_src_f2_label                                                             as loc_zapps_ptid_src
     , get_YN_Label(f2.fu_famliid_yn_f2)                                                             as famliid_yn
     , f2.fu_famli_id_scorres_f2                                                                     as famli_id_scorres
     , f2.loc_fu_famli_id_src_f2_label                                                               as loc_famli_id_src
     , get_YN_Label(f2.wra_fu_comments_yn_f2)                                                        as loc_comments_yn
     , useAutoChoiceTrimmer(f2.wra_fu_comments_f2)                                                   as loc_comments
     , f2.scdmar_scorres_f2_label                                                                    as scdmar_scorres
     , f2.scd_agemar_scorres_f2                                                                      as scd_agemar_scorres
     , get_YN_Label(f2.school_scorres_f2)                                                            as school_scorres
     , f2.sd_highest_edu_level_f2_label                                                              as sd_highest_edu_level
     , f2.school_yrs_scorres_f2                                                                      as school_yrs_scorres
     , get_YN_Label(f2.scd_occupation_scorres_f2)                                                    as scd_occupation_scorres
     , f2.sd_approx_income_pay_f2                                                                    as sd_approx_income_pay
     , f2.scd_mobile_fcorres_f2_label                                                                as scd_mobile_fcorres
     , get_YN_Label(f2.scd_mh_tob_suyn_f2)                                                           as scd_mh_tob_suyn
     , f2.scd_mh_tob_sudosfrq_f2_label                                                               as scd_mh_tob_sudosfrq
     , get_YN_Label(f2.scd_tob_chew_sutrt_f2)                                                        as scd_tob_chew_sutrt
     , get_YN_Label(f2.scd_alc_suyn_f2)                                                              as scd_alc_suyn
     , get_YN_Label(f2.scd_comments_yn_f2)                                                           as scd_comments_yn
     , useTextTransformer(f2.scd_comments_f2)                                                        as scd_comments
     , get_YN_Label(f2.hhc_completed_f2)                                                             as hhc_completed
     , f2.hhc_ha1_f2_label                                                                           as hhc_ha1
     , f2.hhc_ha1_other_f2
     , f2.hhc_ha2_f2_label                                                                           as hhc_ha2
     , f2.hhc_ha2_other_f2
     , f2.hh_numhh_fcorres_f2
     , f2.hh_rms_fcorres_f2
     , f2.hh_sleep_fcorres_f2
     , f2.hh_assets_fcorres_f2___1_label                                                             as hh_assets_fcorres_1
     , f2.hh_assets_fcorres_f2___2_label                                                             as hh_assets_fcorres_2
     , f2.hh_assets_fcorres_f2___3_label                                                             as hh_assets_fcorres_3
     , f2.hh_assets_fcorres_f2___4_label                                                             as hh_assets_fcorres_4
     , f2.hh_assets_fcorres_f2___5_label                                                             as hh_assets_fcorres_5
     , f2.hh_assets_fcorres_f2___6_label                                                             as hh_assets_fcorres_6
     , f2.hh_assets_fcorres_f2___7_label                                                             as hh_assets_fcorres_7
     , f2.hh_assets_fcorres_f2___8_label                                                             as hh_assets_fcorres_8
     , f2.hh_assets_fcorres_f2___9_label                                                             as hh_assets_fcorres_9
     , f2.hh_assets_fcorres_f2___10_label                                                            as hh_assets_fcorres_10
     , f2.hh_assets_fcorres_f2___11_label                                                            as hh_assets_fcorres_11
     , f2.hh_assets_fcorres_f2___12_label                                                            as hh_assets_fcorres_12
     , f2.hh_assets_fcorres_f2___13_label                                                            as hh_assets_fcorres_13
     , f2.hh_assets_fcorres_f2___14_label                                                            as hh_assets_fcorres_14
     , f2.hh_assets_fcorres_f2___15_label                                                            as hh_assets_fcorres_15
     , f2.hh_assets_fcorres_f2___16_label                                                            as hh_assets_fcorres_16
     , f2.hh_assets_fcorres_f2___17_label                                                            as hh_assets_fcorres_17
     , f2.hh_assets_fcorres_f2___18_label                                                            as hh_assets_fcorres_18
     , f2.hh_assets_fcorres_f2___19_label                                                            as hh_assets_fcorres_19
     , f2.hh_assets_fcorres_f2___20_label                                                            as hh_assets_fcorres_20
     , f2.hh_assets_fcorres_f2___21_label                                                            as hh_assets_fcorres_21
     , f2.hh_assets_fcorres_f2___22_label                                                            as hh_assets_fcorres_22
     , f2.hh_asset_ownr_f2___1_label                                                                 as hh_asset_ownr_1
     , f2.hh_asset_ownr_f2___2_label                                                                 as hh_asset_ownr_2
     , f2.hh_asset_ownr_f2___3_label                                                                 as hh_asset_ownr_3
     , f2.hh_asset_ownr_f2___4_label                                                                 as hh_asset_ownr_4
     , f2.hh_asset_ownr_f2___5_label                                                                 as hh_asset_ownr_5
     , f2.hh_asset_ownr_f2___6_label                                                                 as hh_asset_ownr_6
     , f2.hh_asset_ownr_f2___7_label                                                                 as hh_asset_ownr_7
     , f2.hh_asset_ownr_f2___8_label                                                                 as hh_asset_ownr_8
     , f2.hh_asset_ownr_f2___9_label                                                                 as hh_asset_ownr_9
     , get_YN_Label(f2.livestock_fcorres_f2)                                                         as livestock_fcorres
     , get_YN_Label(f2.land_fcorres_f2)                                                              as land_fcorres
     , f2.ext_wall_fcorres_f2_label                                                                  as ext_wall_fcorres
     , f2.ext_wall_othr_fcorres_f2
     , f2.floor_fcorres_f2_label                                                                     as floor_fcorres
     , f2.floor_othr_fcorres_f2
     , f2.roof_fcorres_f2_label                                                                      as roof_fcorres
     , f2.roof_spfy_fcorres_f2
     , f2.wash_ob_loc_f2_label                                                                       as wash_ob_loc
     , f2.wash_h2o_ob_f2_label                                                                       as wash_h2o_ob
     , f2.wash_soap_ob_f2___1_label                                                                  as wash_soap_ob_1
     , f2.wash_soap_ob_f2___2_label                                                                  as wash_soap_ob_2
     , f2.wash_soap_ob_f2___3_label                                                                  as wash_soap_ob_3
     , f2.h2o_fcorres_f2_label                                                                       as h2o_fcorres
     , f2.h2o_othr_fcorres_f2
     , f2.h2o_loc_fcorres_f2_label                                                                   as h2o_loc_fcorres
     , f2.hloc_othr_fcorres_f2
     , f2.minutes_f2
     , f2.h2o_prep_fcorres_f2_label                                                                  as h2o_prep_fcorres
     , f2.h2o_hprep_fcorres_f2___1_label                                                             as h2o_hprep_fcorres_1
     , f2.h2o_hprep_fcorres_f2___2_label                                                             as h2o_hprep_fcorres_2
     , f2.h2o_hprep_fcorres_f2___3_label                                                             as h2o_hprep_fcorres_3
     , f2.h2o_hprep_fcorres_f2___4_label                                                             as h2o_hprep_fcorres_4
     , f2.h2o_hprep_fcorres_f2___5_label                                                             as h2o_hprep_fcorres_5
     , f2.h2o_hprep_fcorres_f2___6_label                                                             as h2o_hprep_fcorres_6
     , f2.h2o_hprep_fcorres_f2___96_label                                                            as h2o_hprep_fcorres_96
     , f2.h2o_hprep_fcorres_f2___98_label                                                            as h2o_hprep_fcorres_98
     , f2.h2o_hprep_othr_fcorres_f2
     , f2.toilet_fcorres_f2_label                                                                    as toilet_fcorres
     , f2.toilet_othr_fcorres_f2
     , f2.toilet_loc_fcorres_f2_label                                                                as toilet_loc_fcorres
     , f2.toilet_loc_othr_fcorres_f2
     , get_YN_Label(f2.toilet_share_fcorres_f2)                                                      as toilet_share_fcorres
     , f2.toilet_share_num_fcorres_f2
     , get_YN_Label(f2.obchar_commnts_yn_f2)                                                         as obchar_commnts_yn
     , f2.obchar_commnts_f2
     , get_YN_Label(f2.cooking_inside_fcorres_f2)                                                    as cooking_inside_fcorres
     , f2.cooking_room_fcorres_f2
     , f2.cooking_loc_fcorres_f2_label                                                               as cooking_loc_fcorres
     , f2.cooking_loc_othr_fcorres_f2
     , get_YN_Label(f2.cooking_vent_fcorres_f2)                                                      as cooking_vent_fcorres
     , f2.cooking_fuel_fcorres_f2_label                                                              as cooking_fuel_fcorres
     , f2.cooking_fuel_othr_fcorres_f2
     , f2.light_fuel_fcorres_f2_label                                                                as light_fuel_fcorres
     , f2.light_fuel_othr_fcorres_f2
     , f2.heat_fuel_fcorres_f2_label                                                                 as heat_fuel_fcorres
     , f2.heat_fuel_othr_fcorres_f2
     , f2.smoke_hhold_freq_in_oecoccur_f2_label                                                      as smoke_hhold_freq_in_oecoccur
     , get_YN_Label(f2.air_pol_comm_yn_f2)                                                           as air_pol_comm_yn
     , f2.air_pol_comm_f2
     , get_YN_Label(f2.hh_nofd_scorres_f2)                                                           as hh_nofd_scorres
     , f2.hh_nofd_frq_scorres_f2_label                                                               as hh_nofd_frq_scorres
     , get_YN_Label(f2.hh_nofd_sleep_scorres_f2)                                                     as hh_nofd_sleep_scorres
     , f2.hh_nofd_sleep_frq_scorres_f2_label                                                         as hh_nofd_sleep_frq_scorres
     , get_YN_Label(f2.hh_nofd_night_scorres_f2)                                                     as hh_nofd_night_scorres
     , f2.hh_nofd_night_frq_scorres_f2_label                                                         as hh_nofd_night_frq_scorres
     , get_YN_Label(f2.hfs_coyn_f2)                                                                  as hfs_coyn
     , useTextTransformer(f2.hfs_coval_f2)
     , mha.phq9_interest_scorres_label
     , mha.phq9_dprs_scorres_label
     , mha.phq9_sleep_scorres_label
     , mha.phq9_tired_scorres_label
     , mha.phq9_app_scorres_label
     , mha.phq9_bad_scorres_label
     , mha.phq9_conc_scorres_label
     , mha.phq9_slow_scorres_label
     , mha.phq9_hurt_scorres_label
     , mha.phq9_difficult_scorres_label
     , CAST(mha.phq9_total_scorres as UNSIGNED)                                                      as phq9_total_scorres
     , mha.zds_depression_sevr
     , CAST(mha.ds_is_cr_required as UNSIGNED)                                                       as ds_is_cr_required
     , get_YN_Label(mha.phq9_coyn)
     , useAutoChoiceTrimmer(mha.phq9_coval)
     , mha.anx_1_label
     , mha.anx_2_label
     , mha.anx_3_label
     , mha.anx_4_label
     , mha.anx_5_label
     , mha.anx_6_label
     , mha.anx_7_label
     , CAST(mha.anx_total_score as UNSIGNED)                                                         as anx_total_score
     , mha.gad_result
     , get_YN_Label(mha.anx_comments_yn)
     , useAutoChoiceTrimmer(mha.anx_comments)
     , mha.pss_upset_scorres_label
     , mha.pss_no_ctrl_scorres_label
     , mha.pss_nervous_scorres_label
     , mha.pss_confid_scorres_label
     , mha.pss_yrway_scorres_label
     , mha.pss_cope_scorres_label
     , mha.pss_ctrl_scorres_label
     , mha.pss_ontop_scorres_label
     , mha.pss_anger_scorres_label
     , mha.pss_dfclt_scorres_label
     , CAST(mha.pss_total_scorres as UNSIGNED)                                                       as pss_total_scorres
     , useAutoChoiceTrimmer(mha.sa_zassessment_result)
     , get_YN_Label(mha.pss_coyn)
     , useAutoChoiceTrimmer(mha.ss_comments)
     , get_YN_Label(ps.fu_lmp_reg_scorres_f2)                                                        as lmp_reg_scorres
     , IF(ps.fu_lmp_kd_scorres_f2 = 96, TRIM(ps.lmp_kd_scorres_othr_f2), fu_lmp_kd_scorres_f2_label) as lmp_kd_scorres
     , TRIM(ps.lmp_kd_scorres_othr_f2)                                                               as lmp_kd_scorres_other
     , get_YN_Label(ps.fu_lmp_start_scorres_f2)                                                      as lmp_start_scorres
     , ps.fu_lmp_scdat_f2                                                                            as lmp_scdat
     , useAutoChoiceTrimmer(ps.fu_lmp_cat_scorres_f2_label)                                          as lmp_cat_scorres
     , ps.fu_lmp_start_weeks_f2                                                                      as lmp_start_weeks
     , ps.fu_lmp_start_months_f2                                                                     as lmp_start_months
     , ps.fu_lmp_start_years_f2                                                                      as lmp_start_years
     , get_YN_Label(ps.fu_lmp_scorres_f2)                                                            as lmp_scorres
     , get_YN_Label(ps.fu_ps_mens_cal_yn_f2)                                                         as ps_mens_cal_yn
     , get_YN_Label(ps.fu_lmp_dt_rec_cal_f2)                                                         as lmp_dt_rec_cal
     , ps.fu_preg_scorres_f2_label                                                                   as preg_scorres
     , useAutoChoiceTrimmer(ps.ps_fu_preg_dur_f2_label)                                              as ps_preg_dur
     , ps.fu_month_preg_scorres_f2                                                                   as months_preg_scorres
     , ps.fu_weeks_preg_scorres_f2                                                                   as weeks_preg_scorres
     , ps.fu_np_pregid_mhyn_f2_label                                                                 as np_pregid_mhyn
     , ps.fu_np_date_of_test_f2                                                                      as np_date_of_test
     , ps.fu_np_date_of_test_2_f2                                                                    as np_date_of_test_2
     , ps.fu_np_us_test_dat_f2                                                                       as np_us_test_dat
     , ps.fu_np_bld_test_dat_f2                                                                      as np_bld_test_dat
     , ps.ps_fu_pregnancy_id_f2                                                                      as ps_pregnancy_id
     , ps.fu_np_us_edd_dat_f2                                                                        as np_us_edd_dat
     , ps.fu_np_edd_src_f2_label                                                                     as np_edd_src
     , ps.ps_fu_last_upt_f2                                                                          as ps_fu_last_upt
     , ps.ps_fu_zapps_enr_f2                                                                         as ps_fu_zapps_enr
     , ps.ps_fu_pregnancy_id_f2                                                                      as ps_fu_pregnancy_id
     , get_YN_Label(ps.ps_preg_last_visit_f2)                                                        as ps_preg_last_visit
     , get_YN_Label(ps.ps_same_preg_lv_f2)                                                           as ps_same_preg_lv
     , ps.ps_fu_danger_signs_f2___1_label                                                            as ps_fu_danger_signs___1
     , ps.ps_fu_danger_signs_f2___2_label                                                            as ps_fu_danger_signs___2
     , ps.ps_fu_danger_signs_f2___3_label                                                            as ps_fu_danger_signs___3
     , ps.ps_fu_danger_signs_f2___4_label                                                            as ps_fu_danger_signs___4
     , ps.ps_fu_danger_signs_f2___5_label                                                            as ps_fu_danger_signs___5
     , ps.ps_fu_danger_signs_f2___6_label                                                            as ps_fu_danger_signs___6
     , ps.ps_fu_danger_signs_f2___7_label                                                            as ps_fu_danger_signs___7
     , ps.ps_preg_times_f2                                                                           as ps_preg_times
     , get_YN_Label(ps.fu_preg_surv_comm_yn_f2)                                                      as preg_surv_comm
     , useTextTransformer(ps.fu_preg_surv_comm_f2)
FROM crt_wra_visit_3_overview v3
         LEFT JOIN wra_follow_up_visit_2_repeating_instruments f2
                   ON v3.alternate_id = f2.wra_follow_up_visit_2_repeating_instruments_id
         LEFT JOIN wra_mental_health_assessment mha ON v3.record_id = mha.record_id
         LEFT JOIN wrafu_pregnancy_surveillance_2 ps ON v3.record_id = ps.record_id
WHERE mha.redcap_event_name = 'wra_followup_visit_arm_1b';

UPDATE arch_follow_up_2_visit_master_v1 wra
    LEFT JOIN arch_etl_db.crt_wra_visit_3_overview v3 ON wra.record_id = v3.record_id
SET wra.wra_age = v3.age
WHERE wra.wra_ptid = v3.wra_ptid;

UPDATE arch_follow_up_2_visit_master_v1 sd_v3
SET sd_v3.sd_approx_income_pay = REPLACE(REPLACE(REPLACE(sd_v3.sd_approx_income_pay, 'K', ''), 'k', ''), 'Kk', '')
WHERE sd_v3.sd_approx_income_pay = 'Yes';

UPDATE arch_follow_up_2_visit_master_v1 sd_v3
SET sd_v3.sd_approx_income_pay = CAST(sd_v3.sd_approx_income_pay AS DECIMAL(12, 2))
WHERE sd_v3.sd_approx_income_pay REGEXP '^[[:digit:]]+$';

UPDATE arch_follow_up_2_visit_master_v1 am
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
WHERE poc.redcap_event_name = 'wra_followup_visit_arm_1b';

UPDATE arch_follow_up_2_visit_master_v1 am
    LEFT JOIN arch_etl_db.wrafu_pregnancy_assessments_2 pa ON am.record_id = pa.record_id
SET am.poa_ant_preg            = get_YN_Label(pa.poa_ant_preg_f2)
  , am.poa_ant_att             = IF(pa.poa_ant_att_f2 = 1, CONCAT(pa.poa_ant_count_f2, ' times'),
                                    pa.poa_ant_att_f2_label)
  , am.poa_ant_count           = pa.poa_ant_count_f2
  , am.poa_fetus_count         = pa.poa_fetus_count_f2_label
  , am.poa_preg_outcome        = pa.poa_preg_outcome_f2_label
  , am.poa_preg_dev_outcome    = pa.poa_preg_dev_outcome_f2_label
  , am.poa_mae_pregend_date    = pa.poa_mae_pregend_date_f2
  , am.poa_preg_dur            = useAutoChoiceTrimmer(pa.poa_preg_dur_f2)
  , am.poa_preg_dur_weeks      = pa.poa_preg_dur_weeks_f2
  , am.poa_preg_dur_months     = pa.poa_preg_dur_months_f2
  , am.poa_pregdev_date        = pa.poa_pregdev_date_f2
  , am.poa_pregdev_dur         = useAutoChoiceTrimmer(pa.poa_pregdev_dur_f2)
  , am.poa_pregdev_dur_weeks   = pa.poa_pregdev_dur_weeks_f2
  , am.poa_pregdev_dur_months  = pa.poa_pregdev_dur_months_f2
  , am.poa_comments_yn         = get_YN_Label(pa.poa_comments_yn_f2)
  , am.poa_comments            = useTextTransformer(pa.poa_comments_f2)
  , am.np_zapps_scorres        = pa.np_fu_zapps_scorres_f2_label
  , am.np_zapps_ptid           = TRIM(pa.np_fu_zapps_ptid_f2)
  , am.np_zapps_id_src         = pa.np_fu_zapps_id_src_f2_label
  , am.np_ident_arch           = get_YN_Label(pa.np_fu_ident_arch_f2)
  , am.np_ptw_1                = pa.np_fu_ptw_f2___1_label
  , am.np_ptw_2                = pa.np_fu_ptw_f2___2_label
  , am.np_ptw_3                = pa.np_fu_ptw_f2___3_label
  , am.np_ptw_4                = pa.np_fu_ptw_f2___4_label
  , am.np_ptw_5                = pa.np_fu_ptw_f2___5_label
  , am.np_ptw_6                = pa.np_fu_ptw_f2___6_label
  , am.np_ptw_7                = pa.np_fu_ptw_f2___7_label
  , am.np_anc_mhyn             = get_YN_Label(pa.np_fu_anc_mhyn_f2)
  , am.np_anc_num_mh           = pa.np_fu_anc_num_mh_f2
  , am.np_anc1_dat             = pa.np_fu_anc1_dat_f2
  , am.np_anc1_ga              = IF(pa.np_fu_anc1_ga_f2 = 98, pa.np_fu_anc1_ga_f2_label,
                                    useAutoChoiceTrimmer(pa.np_fu_anc1_ga_f2_label))
  , am.anc1_ga_weeks           = pa.fu_anc1_ga_weeks_f2
  , am.anc1_ga_months          = pa.fu_anc1_ga_months_f2
  , am.np_anc_plan_obsloc      = pa.np_fu_anc_plan_obsloc_f2_label
  , am.birth_plan_fac_obsloc   = IF(pa.fu_birth_plan_fac_obsloc_f2 = 88, TRIM(fu_birth_other_loc_f2),
                                    fu_birth_plan_fac_obsloc_f2_label)
  , am.facility_other          = pa.fu_facility_other_f2_label
  , am.birth_other_loc         = TRIM(pa.fu_birth_other_loc_f2)
  , am.np_del_decide_scorres   = IF(pa.np_fu_del_decide_scorres_f2 = 88, TRIM(pa.fu_del_decide_spfy_scorres_f2),
                                    pa.np_fu_del_decide_scorres_f2_label)
  , am.del_decide_spfy_scorres = pa.fu_del_decide_spfy_scorres_f2
  , am.cph_comments_yn         = get_YN_Label(pa.np_fu_comments_yn_f2)
  , am.cph_comments            = useTextTransformer(pa.np_fu_comments_f2)
  , am.np_alc_suyn             = get_YN_Label(pa.np_fu_alc_suyn_f2)
  , am.np_alc_cons             = pa.np_fu_alc_cons_f2_label
  , am.np_tob_suyn             = get_YN_Label(pa.np_fu_tob_suyn_f2)
  , am.np_tob_cur_sudosfrq     = pa.np_fu_tob_curr_sudosfrq_f2_label
  , am.tob_oth_sutrt_1         = pa.fu_tob_oth_stutrt_f2___1_label
  , am.tob_oth_sutrt_2         = pa.fu_tob_oth_stutrt_f2___2_label
  , am.tob_oth_sutrt_3         = pa.fu_tob_oth_stutrt_f2___3_label
  , am.tob_oth_sutrt_4         = pa.fu_tob_oth_stutrt_f2___4_label
  , am.tob_oth_sutrt_5         = pa.fu_tob_oth_stutrt_f2___5_label
  , am.tob_oth_sutrt_6         = pa.fu_tob_oth_stutrt_f2___6_label
  , am.tob_oth_sutrt_7         = pa.fu_tob_oth_stutrt_f2___7_label
  , am.other_tbc_use           = useAutoTrimmer(pa.fu_other_tbc_use_f2)
  , am.np_drug_suyn            = get_YN_Label(pa.np_fu_drug_suyn_f2)
  , am.np_drug_usage           = pa.np_fu_drug_usage_f2_label
  , am.np_drug_sutrt_1         = pa.np_fu_drug_sutrt_f2___1_label
  , am.np_drug_sutrt_2         = pa.np_fu_drug_sutrt_f2___2_label
  , am.np_drug_sutrt_3         = pa.np_fu_drug_sutrt_f2___3_label
  , am.np_drug_sutrt_4         = pa.np_fu_drug_sutrt_f2___4_label
  , am.np_drug_sutrt_5         = pa.np_fu_drug_sutrt_f2___5_label
  , am.np_drug_sutrt_6         = pa.np_fu_drug_sutrt_f2___6_label
  , am.np_drug_sutrt_7         = pa.np_fu_drug_sutrt_f2___7_label
  , am.np_drug_sutrt_othr      = useAutoTrimmer(pa.np_fu_drug_sutrt_othr_f2)
  , am.hbp_comments_yn         = get_YN_Label(pa.hbp_fu_comments_yn_f2)
  , am.hbp_comments            = useTextTransformer(pa.hbp_fu_comments_f2)
  , am.name_veri               = pa.fu_name_veri_f2_label
  , am.brthdat_veri            = pa.fu_brthdat_veri_f2_label
  , am.ref_likely_scorres      = get_YN_Label(pa.fu_ref_likely_scorres_f2)
  , am.ref_res_decline_1       = pa.fu_ref_res_decline_f2___1_label
  , am.ref_res_decline_2       = pa.fu_ref_res_decline_f2___2_label
  , am.ref_res_decline_3       = pa.fu_ref_res_decline_f2___3_label
  , am.ref_res_decline_4       = pa.fu_ref_res_decline_f2___4_label
  , am.ref_res_decline_5       = pa.fu_ref_res_decline_f2___5_label
  , am.ref_res_decline_6       = pa.fu_ref_res_decline_f2___6_label
  , am.zr_2_other              = useAutoTrimmer(pa.zr_fu_reas_other_f2)
  , am.pref_zapps_scorres      = pa.zr_fu_pref_zapps_scorres_f2_label
  , am.apnt_dat_scorres        = pa.zr_fu_apnt_dat_scorres_f2
  , am.zr_confirm_contact      = pa.zr_fu_confirm_contact_f2_label
  , am.preg_test               = pa.fu_preg_test_f2
  , am.zr_wra_ptid             = TRIM(pa.zr_fu_wra_ptid_f2)
  , am.zr_comm_yn              = get_YN_Label(pa.zr_fu_comments_yn_f2)
  , am.zr_comm                 = useTextTransformer(pa.zr_fu_comments_f2)
WHERE (pa.poa_ant_preg_f2 IS NOT NULL OR pa.np_fu_zapps_scorres_f2 IS NOT NULL
    OR pa.fu_name_veri_f2 IS NOT NULL)
  AND am.visit_number = 3.0;

UPDATE arch_follow_up_2_visit_master_v1 am
    LEFT JOIN arch_etl_db.wrafu_infant_outcome_assessment_repeating_instruments io ON am.record_id = io.record_id
SET am.ioa_infant_name             = useAutoTrimmer(io.ioa_infant_name_f2),
    am.ioa_infant_ptid             = CONCAT_WS('-', am.wra_ptid, useAutoTrimmer(io.ioa_infant_name_f2)),
    am.ioa_infant_sex              = io.ioa_infant_sex_f2_label,
    am.ioa_infant_alive            = io.ioa_infant_alive_f2_label,
    am.ioa_infant_age              = useAutoChoiceTrimmer(io.ioa_infant_age_f2),
    am.ioa_infant_age_days         = io.ioa_infant_age_days_f2,
    am.ioa_infant_age_months       = io.ioa_infant_age_months_f2,
    am.ioa_infant_age_death        = useAutoChoiceTrimmer(io.ioa_infant_age_death_f2),
    am.ioa_infant_age_death_days   = io.ioa_infant_age_death_days_f2,
    am.ioa_infant_age_death_months = io.ioa_infant_age_death_months_f2
WHERE io.redcap_repeat_instance = 1
  AND io.redcap_event_name = 'wra_followup_visit_arm_1b'
  AND am.visit_number = 3.0;

UPDATE arch_follow_up_2_visit_master_v1 am
    LEFT JOIN arch_etl_db.wrafu_infant_outcome_assessment_repeating_instruments io ON am.record_id = io.record_id
SET am.ioa_infant_name             = useAutoTrimmer(io.ioa_infant_name_f2),
    am.ioa_infant_ptid             = CONCAT_WS('-', am.wra_ptid, useAutoTrimmer(io.ioa_infant_name_f2)),
    am.ioa_infant_sex              = io.ioa_infant_sex_f2_label,
    am.ioa_infant_alive            = io.ioa_infant_alive_f2_label,
    am.ioa_infant_age              = useAutoChoiceTrimmer(io.ioa_infant_age_f2),
    am.ioa_infant_age_days         = io.ioa_infant_age_days_f2,
    am.ioa_infant_age_months       = io.ioa_infant_age_months_f2,
    am.ioa_infant_age_death        = useAutoChoiceTrimmer(io.ioa_infant_age_death_f2),
    am.ioa_infant_age_death_days   = io.ioa_infant_age_death_days_f2,
    am.ioa_infant_age_death_months = io.ioa_infant_age_death_months_f2
WHERE io.redcap_repeat_instance = 2
  AND io.redcap_event_name = 'wra_followup_visit_arm_1b'
  AND am.visit_number = 3.0;

UPDATE arch_follow_up_2_visit_master_v1 am
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
  AND cr.redcap_event_name = 'wra_followup_visit_arm_1b'
  AND am.visit_number = 3.0;

UPDATE arch_follow_up_2_visit_master_v1 am
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
  AND cr.redcap_event_name = 'wra_followup_visit_arm_1b'
  AND am.visit_number = 3.0;

UPDATE arch_follow_up_2_visit_master_v1 am
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
  AND cr.redcap_event_name = 'wra_followup_visit_arm_1b'
  AND am.visit_number = 3.0;

UPDATE arch_follow_up_2_visit_master_v1 am
    LEFT JOIN arch_etl_db.outmigration om ON am.record_id = om.record_id
SET am.om_name_scorres = om.om_name_scorres
  , am.return_scorres  = om.return_scorres_label
  , am.om_comments_yn  = get_YN_Label(om.om_comments_yn)
WHERE om.redcap_event_name = 'wra_followup_visit_arm_1b'
  AND am.visit_number = 3.0;

UPDATE arch_follow_up_2_visit_master_v1 am
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
WHERE sc.redcap_event_name = 'wra_followup_visit_arm_1b'
  AND am.visit_number = 3.0;