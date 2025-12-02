-- Baseline Overview
-- SET time_zone = '+02:00';
TRUNCATE arch_etl_db.arch_baseline_visit_master_v1;
INSERT INTO arch_etl_db.arch_baseline_visit_master_v1( id
                                                     , record_id
                                                     , visit_number
                                                     , visit_name
                                                     , visit_outcome
                                                     , wra_timestamp
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
                                                     , brthdat
                                                     , wra_age
                                                     , wra_ptid
                                                     , fname_scorres
                                                     , mname_scorres
                                                     , lname_scorres
                                                     , wra_enr_full_name
                                                     , oname_scorres
                                                     , wra_enr_comments_yn
                                                     , wra_enr_comments
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
                                                     , loc_fc_num
                                                     , loc_pn_belongs_oth
                                                     , loc_who_is_caller
                                                     , loc_pn_belongs
                                                     , loc_sc_num
                                                     , loc_pn_belongs_2
                                                     , loc_pn_belongs_oth_2
                                                     , loc_who_is_caller_2
                                                     , loc_tc_num
                                                     , loc_pn_belongs_3
                                                     , loc_pn_belongs_oth_3
                                                     , loc_who_is_caller_3
                                                     , loc_other_contacts_3
                                                     , loc_fthc_num
                                                     , loc_pn_belongs_4
                                                     , loc_who_is_caller_4
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
                                                     , ph_prev_rporres
                                                     , pho_num_preg_rporres
                                                     , ph_live_rporres
                                                     , pho_preg_count
                                                     , ph_loss_rporres
                                                     , ph_bs_rporres_2
                                                     , ph_bs_rporres
                                                     , pho_loss_count
                                                     , stlb_num_rporres_2
                                                     , stlb_num_rporres
                                                     , pho_comments_yn
                                                     , pho_comments
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
                                                     , apreg_date
                                                     , ps_pregnancy_id
                                                     , np_us_edd_dat
                                                     , np_edd_src
                                                     , preg_surv_comm
                                                     , preg_surv_commnts)
SELECT v1.alternate_id                                               as id
     , v1.record_id
     , v1.visit_number
     , v1.visit_name
     , v1.visit_outcome
     , bsv.wra_timestamp
     , bsv.hh_scrn_num_obsloc
     , CAST(bsv.wra_enr_visit_count as UNSIGNED)                     as wra_enr_visit_count
     , CAST(bsv.attempt_count as UNSIGNED)                           as attempt_count
     , CAST(bsv.hhe_hh_member_id as UNSIGNED)                        as hhe_hh_member_id
     , bsv.scrn_obsstdat
     , bsv.wra_enr_interviewer_obsloc
     , get_YN_Label(bsv.wra_enr_hhh_pvc)                             as wra_enr_hhh_pvc
     , bsv.wra_enr_reas_decline
     , bsv.wra_enr_pp_avail_label                                    as wra_enr_pp_avail
     , bsv.is_wra_avail_other
     , bsv.brthdat
     , bsv.wra_age
     , bsv.wra_ptid
     , bsv.fname_scorres
     , bsv.mname_scorres
     , bsv.lname_scorres
     , bsv.wra_enr_full_name
     , bsv.oname_scorres
     , get_YN_Label(bsv.wra_enr_comments_yn)                         as wra_enr_comments_yn
     , TRIM(bsv.wra_enr_comments)
     , get_YN_Label(bsv.c19vax_cmyn)                                 as c19vax_cmyn
     , bsv.c19vax_cmtrt_label                                        as c19vax_cmtrt
     , bsv.covid_scrn_3_label                                        as covid_scrn_3
     , get_YN_Label(bsv.c19_lbperf)                                  as c19_lbperf
     , bsv.covid_test_dt_range
     , bsv.c19_lbdat
     , bsv.c19_lborres_label                                         as c19_lborres
     , bsv.fever_ceoccur_label                                       as fever_ceoccur
     , bsv.cough_ceoccur_label                                       as cough_ceoccur
     , bsv.shortbreath_ceoccur_label                                 as shortbreath_ceoccur
     , bsv.sorethroat_ceoccur_label                                  as sorethroat_ceoccur
     , bsv.fatigue_ceoccur_label                                     as fatigue_ceoccur
     , bsv.myalgia_ceoccur_label                                     as myalgia_ceoccur
     , bsv.anorexia_ceoccur_label                                    as anorexia_ceoccur
     , bsv.nausea_ceoccur_label                                      as nausea_ceoccur
     , bsv.diarrhoea_ceoccur_label                                   as diarrhoea_ceoccur
     , bsv.ageusia_ceoccur_label                                     as ageusia_ceoccur
     , bsv.anosmia_ceoccur_label                                     as anosmia_ceoccur
     , bsv.runnynose_ceoccur_label                                   as runnynose_ceoccur
     , bsv.sneeze_ceoccur_label                                      as sneeze_ceoccur
     , bsv.headache_ceoccur_label                                    as headache_ceoccur
     , bsv.rash_ceoccur_label                                        as rash_ceoccur
     , bsv.conjunct_ceoccur_label                                    as conjunct_ceoccur
     , bsv.c19_contact_dx_ceoccur_label                              as c19_contact_dx_ceoccur
     , bsv.c19_contact_sx_ceoccur_label                              as c19_contact_sx_ceoccur
     , bsv.hh_member_id
     , get_YN_Label(bsv.covid_scrn_9)                                as covid_scrn_9
     , get_YN_Label(bsv.c19_zm_scorres)                              as c19_zm_scorres
     , get_YN_Label(bsv.covid_scrn_comments_yn)                      as covid_scrn_comments_yn
     , useTextTransformer(bsv.covid_scrn_comments)
     , bsv.loc_fc_num
     , TRIM(bsv.loc_pn_belongs_oth)
     , TRIM(bsv.loc_who_is_caller)
     , bsv.loc_pn_belongs_label                                      as loc_pn_belongs
     , CAST(bsv.loc_sc_num as UNSIGNED)                              as loc_sc_num
     , bsv.loc_pn_belongs_2_label                                    as loc_pn_belongs_2
     , TRIM(bsv.loc_pn_belongs_oth_2)
     , TRIM(bsv.loc_who_is_caller_2)
     , bsv.loc_tc_num
     , bsv.loc_pn_belongs_3_label                                    as loc_pn_belongs_3
     , TRIM(bsv.loc_pn_belongs_oth_3)
     , TRIM(bsv.loc_who_is_caller_3)
     , get_YN_Label(bsv.loc_other_contacts_3)                        as loc_other_contacts_3
     , CAST(bsv.loc_fthc_num as UNSIGNED)                            as loc_fthc_num
     , bsv.loc_pn_belongs_4_label                                    as loc_pn_belongs_4
     , TRIM(bsv.loc_who_is_caller_4)
     , get_YN_Label(bsv.loc_enrolled_zapps)                          as loc_enrolled_zapps
     , TRIM(bsv.loc_zapps_ptid)
     , bsv.loc_zapps_ptid_src_label                                  as loc_zapps_ptid_src
     , get_YN_Label(bsv.famliid_yn)                                  as famliid_yn
     , bsv.famli_id_scorres
     , bsv.loc_famli_id_src_label                                    as loc_famli_id_src
     , get_YN_Label(bsv.loc_comments_yn)                             as loc_comments_yn
     , useTextTransformer(bsv.loc_comments)
     , bsv.scdmar_scorres_label                                      as scdmar_scorres
     , bsv.scd_agemar_scorres
     , get_YN_Label(bsv.school_scorres)                              as school_scorres
     , bsv.sd_highest_edu_level_label                                as sd_highest_edu_level
     , bsv.school_yrs_scorres
     , get_YN_Label(bsv.scd_occupation_scorres)                      as scd_occupation_scorres
     , REGEXP_REPLACE(bsv.sd_approx_income_pay, '[[:space:]]+', ' ') as sd_approx_income_pay
     , bsv.scd_mobile_fcorres_label                                  as scd_mobile_fcorres
     , get_YN_Label(bsv.scd_mh_tob_suyn)                             as scd_mh_tob_suyn
     , bsv.scd_mh_tob_sudosfrq_label                                 as scd_mh_tob_sudosfrq
     , get_YN_Label(bsv.scd_tob_chew_sutrt)                          as scd_tob_chew_sutrt
     , get_YN_Label(bsv.scd_alc_suyn)                                as scd_alc_suyn
     , get_YN_Label(bsv.scd_comments_yn)                             as scd_comments_yn
     , useTextTransformer(bsv.scd_comments)
     , get_YN_Label(bsv.hhc_completed)                               as hhc_completed
     , bsv.hhc_ha1_label                                             as hhc_ha1
     , bsv.hhc_ha1_other
     , bsv.hhc_ha2_label                                             as hhc_ha2
     , bsv.hhc_ha2_other
     , bsv.hh_numhh_fcorres
     , bsv.hh_rms_fcorres
     , bsv.hh_sleep_fcorres
     , bsv.hh_assets_fcorres___1_label                               as hh_assets_fcorres_1
     , bsv.hh_assets_fcorres___2_label                               as hh_assets_fcorres_2
     , bsv.hh_assets_fcorres___3_label                               as hh_assets_fcorres_3
     , bsv.hh_assets_fcorres___4_label                               as hh_assets_fcorres_4
     , bsv.hh_assets_fcorres___5_label                               as hh_assets_fcorres_5
     , bsv.hh_assets_fcorres___6_label                               as hh_assets_fcorres_6
     , bsv.hh_assets_fcorres___7_label                               as hh_assets_fcorres_7
     , bsv.hh_assets_fcorres___8_label                               as hh_assets_fcorres_8
     , bsv.hh_assets_fcorres___9_label                               as hh_assets_fcorres_9
     , bsv.hh_assets_fcorres___10_label                              as hh_assets_fcorres_10
     , bsv.hh_assets_fcorres___11_label                              as hh_assets_fcorres_11
     , bsv.hh_assets_fcorres___12_label                              as hh_assets_fcorres_12
     , bsv.hh_assets_fcorres___13_label                              as hh_assets_fcorres_13
     , bsv.hh_assets_fcorres___14_label                              as hh_assets_fcorres_14
     , bsv.hh_assets_fcorres___15_label                              as hh_assets_fcorres_15
     , bsv.hh_assets_fcorres___16_label                              as hh_assets_fcorres_16
     , bsv.hh_assets_fcorres___17_label                              as hh_assets_fcorres_17
     , bsv.hh_assets_fcorres___18_label                              as hh_assets_fcorres_18
     , bsv.hh_assets_fcorres___19_label                              as hh_assets_fcorres_19
     , bsv.hh_assets_fcorres___20_label                              as hh_assets_fcorres_20
     , bsv.hh_assets_fcorres___21_label                              as hh_assets_fcorres_21
     , bsv.hh_assets_fcorres___22_label                              as hh_assets_fcorres_22
     , bsv.hh_asset_ownr___1_label                                   as hh_asset_ownr_1
     , bsv.hh_asset_ownr___2_label                                   as hh_asset_ownr_2
     , bsv.hh_asset_ownr___3_label                                   as hh_asset_ownr_3
     , bsv.hh_asset_ownr___4_label                                   as hh_asset_ownr_4
     , bsv.hh_asset_ownr___5_label                                   as hh_asset_ownr_5
     , bsv.hh_asset_ownr___6_label                                   as hh_asset_ownr_6
     , bsv.hh_asset_ownr___7_label                                   as hh_asset_ownr_7
     , bsv.hh_asset_ownr___8_label                                   as hh_asset_ownr_8
     , bsv.hh_asset_ownr___9_label                                   as hh_asset_ownr_9
     , get_YN_Label(bsv.livestock_fcorres)                           as livestock_fcorres
     , get_YN_Label(bsv.land_fcorres)                                as land_fcorres
     , bsv.ext_wall_fcorres_label                                    as ext_wall_fcorres
     , bsv.ext_wall_othr_fcorres
     , bsv.floor_fcorres_label                                       as floor_fcorres
     , bsv.floor_othr_fcorres
     , bsv.roof_fcorres_label                                        as roof_fcorres
     , bsv.roof_spfy_fcorres
     , bsv.wash_ob_loc_label                                         as wash_ob_loc
     , bsv.wash_h2o_ob_label                                         as wash_h2o_ob
     , bsv.wash_soap_ob___1_label                                    as wash_soap_ob_1
     , bsv.wash_soap_ob___2_label                                    as wash_soap_ob_2
     , bsv.wash_soap_ob___3_label                                    as wash_soap_ob_3
     , bsv.h2o_fcorres_label                                         as h2o_fcorres
     , bsv.h2o_othr_fcorres
     , bsv.h2o_loc_fcorres_label                                     as h2o_loc_fcorres
     , bsv.hloc_othr_fcorres
     , bsv.minutes
     , bsv.h2o_prep_fcorres_label                                    as h2o_prep_fcorres
     , bsv.h2o_hprep_fcorres___1_label                               as h2o_hprep_fcorres_1
     , bsv.h2o_hprep_fcorres___2_label                               as h2o_hprep_fcorres_2
     , bsv.h2o_hprep_fcorres___3_label                               as h2o_hprep_fcorres_3
     , bsv.h2o_hprep_fcorres___4_label                               as h2o_hprep_fcorres_4
     , bsv.h2o_hprep_fcorres___5_label                               as h2o_hprep_fcorres_5
     , bsv.h2o_hprep_fcorres___6_label                               as h2o_hprep_fcorres_6
     , bsv.h2o_hprep_fcorres___96_label                              as h2o_hprep_fcorres_96
     , bsv.h2o_hprep_fcorres___98_label                              as h2o_hprep_fcorres_98
     , bsv.h2o_hprep_othr_fcorres
     , bsv.toilet_fcorres_label                                      as toilet_fcorres
     , TRIM(bsv.toilet_othr_fcorres)
     , bsv.toilet_loc_fcorres_label                                  as toilet_loc_fcorres
     , TRIM(bsv.toilet_loc_othr_fcorres)
     , get_YN_Label(bsv.toilet_share_fcorres)                        as toilet_share_fcorres
     , bsv.toilet_share_num_fcorres
     , get_YN_Label(bsv.obchar_commnts_yn)                           as obchar_commnts_yn
     , useTextTransformer(bsv.obchar_commnts)
     , get_YN_Label(bsv.cooking_inside_fcorres)                      as cooking_inside_fcorres
     , bsv.cooking_room_fcorres
     , bsv.cooking_loc_fcorres_label                                 as cooking_loc_fcorres
     , bsv.cooking_loc_othr_fcorres
     , get_YN_Label(bsv.cooking_vent_fcorres)                        as cooking_vent_fcorres
     , bsv.cooking_fuel_fcorres_label                                as cooking_fuel_fcorres
     , bsv.cooking_fuel_othr_fcorres
     , bsv.light_fuel_fcorres_label                                  as light_fuel_fcorres
     , bsv.light_fuel_othr_fcorres
     , bsv.heat_fuel_fcorres_label                                   as heat_fuel_fcorres
     , bsv.heat_fuel_othr_fcorres
     , bsv.smoke_hhold_freq_in_oecoccur_label                        as smoke_hhold_freq_in_oecoccur
     , get_YN_Label(bsv.air_pol_comm_yn)                             as air_pol_comm_yn
     , useTextTransformer(bsv.air_pol_comm)
     , get_YN_Label(bsv.hh_nofd_scorres)                             as hh_nofd_scorres
     , bsv.hh_nofd_frq_scorres_label                                 as hh_nofd_scorres
     , get_YN_Label(bsv.hh_nofd_sleep_scorres)                       as hh_nofd_scorres
     , bsv.hh_nofd_sleep_frq_scorres_label                           as hh_nofd_scorres
     , get_YN_Label(bsv.hh_nofd_night_scorres)                       as hh_nofd_scorres
     , bsv.hh_nofd_night_frq_scorres_label                           as hh_nofd_scorres
     , get_YN_Label(bsv.hfs_coyn)                                    as hfs_coyn
     , useTextTransformer(bsv.hfs_coval)
     , mha.phq9_interest_scorres_label                               as phq9_interest_scorres
     , mha.phq9_dprs_scorres_label                                   as phq9_dprs_scorres
     , mha.phq9_sleep_scorres_label                                  as phq9_sleep_scorres
     , mha.phq9_tired_scorres_label                                  as phq9_tired_scorres
     , mha.phq9_app_scorres_label                                    as phq9_app_scorres
     , mha.phq9_bad_scorres_label                                    as phq9_bad_scorres
     , mha.phq9_conc_scorres_label                                   as phq9_conc_scorres
     , mha.phq9_slow_scorres_label                                   as phq9_slow_scorres
     , mha.phq9_hurt_scorres_label                                   as phq9_hurt_scorres
     , mha.phq9_difficult_scorres_label                              as phq9_difficult_scorres
     , CAST(mha.phq9_total_scorres as UNSIGNED)                      as phq9_total_scorres
     , mha.zds_depression_sevr
     , CAST(mha.ds_is_cr_required as UNSIGNED)                       as ds_is_cr_required
     , get_YN_Label(mha.phq9_coyn)                                   as phq9_coyn
     , useTextTransformer(mha.phq9_coval)
     , mha.anx_1_label                                               as anx_1
     , mha.anx_2_label                                               as anx_2
     , mha.anx_3_label                                               as anx_3
     , mha.anx_4_label                                               as anx_4
     , mha.anx_5_label                                               as anx_5
     , mha.anx_6_label                                               as anx_6
     , mha.anx_7_label                                               as anx_7
     , CAST(mha.anx_total_score as UNSIGNED)                         as anx_total_score
     , mha.gad_result
     , get_YN_Label(mha.anx_comments_yn)                             as anx_comments_yn
     , useTextTransformer(mha.anx_comments)
     , mha.pss_upset_scorres_label                                   as pss_upset_scorres
     , mha.pss_no_ctrl_scorres_label                                 as pss_no_ctrl_scorres
     , mha.pss_nervous_scorres_label                                 as pss_nervous_scorres
     , mha.pss_confid_scorres_label                                  as pss_confid_scorres
     , mha.pss_yrway_scorres_label                                   as pss_yrway_scorres
     , mha.pss_cope_scorres_label                                    as pss_cope_scorres
     , mha.pss_ctrl_scorres_label                                    as pss_ctrl_scorres
     , mha.pss_ontop_scorres_label                                   as pss_ontop_scorres
     , mha.pss_anger_scorres_label                                   as pss_anger_scorres
     , mha.pss_dfclt_scorres_label                                   as pss_dfclt_scorres
     , CAST(mha.pss_total_scorres as UNSIGNED)                       as pss_total_scorres
     , mha.sa_zassessment_result
     , get_YN_Label(mha.pss_coyn)                                    as pss_coyn
     , useTextTransformer(mha.ss_comments)
     , get_YN_Label(pos.ph_prev_rporres)                             as ph_prev_rporres
     , pos.pho_num_preg_rporres
     , pos.ph_live_rporres
     , CAST(pos.pho_preg_count as UNSIGNED)                          as pho_preg_count
     , pos.ph_loss_rporres
     , pos.ph_bs_rporres_2_label                                     as ph_bs_rporres_2
     , pos.ph_bs_rporres
     , CAST(pos.pho_loss_count as UNSIGNED)                          as pho_loss_count
     , pos.stlb_num_rporres_2_label                                  as stlb_num_rporres_2
     , pos.stlb_num_rporres
     , get_YN_Label(pos.pho_comments_yn)                             as pho_comments_yn
     , useTextTransformer(pos.pho_comments)
     , get_YN_Label(pos.lmp_reg_scorres)                             as lmp_reg_scorres
     , pos.lmp_kd_scorres_label                                      as lmp_kd_scorres
     , useTextTransformer(pos.lmp_kd_scorres_other)
     , get_YN_Label(pos.lmp_start_scorres)                           as lmp_start_scorres
     , pos.lmp_scdat
     , TRIM(pos.lmp_cat_scorres_label)                                     as lmp_cat_scorres
     , pos.lmp_start_weeks
     , pos.lmp_start_months
     , pos.lmp_start_years
     , get_YN_Label(pos.lmp_scorres)                                 as lmp_scorres
     , get_YN_Label(pos.ps_mens_cal_yn)                              as ps_mens_cal_yn
     , get_YN_Label(pos.lmp_dt_rec_cal)                              as lmp_dt_rec_cal
     , pos.preg_scorres_label                                        as preg_scorres
     , NULL                                                          as ps_preg_dur
     , pos.months_preg_scorres
     , NULL
     , pos.np_pregid_mhyn_label                                      as np_pregid_mhyn
     , pos.np_date_of_test
     , pos.np_date_of_test_2
     , pos.np_us_test_dat
     , pos.np_bld_test_dat
     , pos.apreg_date
     , pos.ps_pregnancy_id
     , pos.np_us_edd_dat
     , pos.np_edd_src_label                                          as np_edd_src
     , get_YN_Label(pos.preg_surv_comm)                              as preg_surv_comm
     , useTextTransformer(pos.preg_surv_commnts)
FROM crt_wra_visit_1_overview v1
         LEFT JOIN wra_forms_repeating_instruments bsv ON v1.alternate_id = bsv.wra_forms_repeating_instruments_id
         LEFT JOIN wra_mental_health_assessment mha ON v1.record_id = mha.record_id
         LEFT JOIN wra_pregnancy_overview_and_surveillance pos ON v1.record_id = pos.record_id
WHERE mha.redcap_event_name = 'wra_baseline_arm_1'
  AND mha.phq9_interest_scorres IS NOT NULL;

UPDATE arch_baseline_visit_master_v1 sd_v1
SET sd_v1.sd_approx_income_pay = REPLACE(REPLACE(REPLACE(sd_approx_income_pay, 'K', ''), 'k', ''), 'Kk', '')
WHERE sd_v1.sd_approx_income_pay = 'Yes';

UPDATE arch_baseline_visit_master_v1 sd_v1
SET sd_v1.sd_approx_income_pay = CAST(sd_v1.sd_approx_income_pay AS DECIMAL(12, 2))
WHERE sd_v1.sd_approx_income_pay REGEXP '^[[:digit:]]+$';


UPDATE arch_baseline_visit_master_v1 am
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
WHERE poc.redcap_event_name = 'wra_baseline_arm_1';

UPDATE arch_baseline_visit_master_v1 am
    LEFT JOIN arch_etl_db.wra_pregnancy_assessments pa ON am.record_id = pa.record_id
SET am.wra_pregnancy_id        = pa.wra_pregnancy_id
  , am.np_zapps_scorres        = pa.np_zapps_scorres_label
  , am.np_zapps_ptid           = TRIM(pa.np_zapps_ptid)
  , am.np_zapps_id_src         = pa.np_zapps_id_src_label
  , am.np_ident_arch           = get_YN_Label(pa.np_ident_arch)
  , am.np_ptw_1                = pa.np_ptw___1_label
  , am.np_ptw_2                = pa.np_ptw___2_label
  , am.np_ptw_3                = pa.np_ptw___3_label
  , am.np_ptw_4                = pa.np_ptw___4_label
  , am.np_ptw_5                = pa.np_ptw___5_label
  , am.np_ptw_6                = pa.np_ptw___6_label
  , am.np_ptw_7                = pa.np_ptw___7_label
  , am.np_anc_mhyn             = get_YN_Label(pa.np_anc_mhyn)
  , am.np_anc_num_mh           = pa.np_anc_num_mh
  , am.np_anc1_dat             = pa.np_anc1_dat
  , am.np_anc1_ga              = pa.np_anc1_ga_label
  , am.anc1_ga_weeks           = pa.anc1_ga_weeks
  , am.anc1_ga_months          = pa.anc1_ga_months
  , am.np_anc_plan_obsloc      = get_YN_Label(pa.np_anc_plan_obsloc)
  , am.birth_plan_fac_obsloc   = pa.birth_plan_fac_obsloc_label
  , am.facility_other          = useTextTransformer(pa.facility_other)
  , am.birth_other_loc         = useTextTransformer(pa.birth_other_loc)
  , am.np_del_decide_scorres   = pa.np_del_decide_scorres_label
  , am.del_decide_spfy_scorres = TRIM(pa.del_decide_spfy_scorres)
  , am.cph_comments_yn         = get_YN_Label(pa.cph_comments_yn)
  , am.cph_comments            = useTextTransformer(pa.cph_comments)
  , am.np_alc_suyn             = get_YN_Label(pa.np_alc_suyn)
  , am.np_alc_cons             = get_YN_Label(pa.np_alc_cons)
  , am.np_tob_suyn             = get_YN_Label(pa.np_tob_suyn)
  , am.np_tob_cur_sudosfrq     = pa.np_tob_cur_sudosfrq_label
  , am.tob_oth_sutrt_1         = pa.tob_oth_sutrt___1_label
  , am.tob_oth_sutrt_2         = pa.tob_oth_sutrt___2_label
  , am.tob_oth_sutrt_3         = pa.tob_oth_sutrt___3_label
  , am.tob_oth_sutrt_4         = pa.tob_oth_sutrt___4_label
  , am.tob_oth_sutrt_5         = pa.tob_oth_sutrt___5_label
  , am.tob_oth_sutrt_6         = pa.tob_oth_sutrt___6_label
  , am.tob_oth_sutrt_7         = pa.tob_oth_sutrt___7_label
  , am.other_tbc_use           = useTextTransformer(pa.other_tbc_use)
  , am.np_drug_suyn            = get_YN_Label(pa.np_drug_suyn)
  , am.np_drug_usage           = pa.np_drug_usage_label
  , am.np_drug_sutrt_1         = pa.np_drug_sutrt___1_label
  , am.np_drug_sutrt_2         = pa.np_drug_sutrt___2_label
  , am.np_drug_sutrt_3         = pa.np_drug_sutrt___3_label
  , am.np_drug_sutrt_4         = pa.np_drug_sutrt___4_label
  , am.np_drug_sutrt_5         = pa.np_drug_sutrt___5_label
  , am.np_drug_sutrt_6         = pa.np_drug_sutrt___6_label
  , am.np_drug_sutrt_7         = pa.np_drug_sutrt___7_label
  , am.np_drug_sutrt_othr      = useTextTransformer(pa.np_drug_sutrt_othr)
  , am.hbp_comments_yn         = get_YN_Label(pa.hbp_comments_yn)
  , am.hbp_comments            = useTextTransformer(pa.hbp_comments)
  , am.name_veri               = pa.name_veri_label
  , am.brthdat_veri            = pa.brthdat_veri_label
  , am.ref_likely_scorres      = get_YN_Label(pa.ref_likely_scorres)
  , am.ref_res_decline_1       = pa.ref_res_decline___1_label
  , am.ref_res_decline_2       = pa.ref_res_decline___2_label
  , am.ref_res_decline_3       = pa.ref_res_decline___3_label
  , am.ref_res_decline_4       = pa.ref_res_decline___4_label
  , am.ref_res_decline_5       = pa.ref_res_decline___5_label
  , am.ref_res_decline_6       = pa.ref_res_decline___6_label
  , am.zr_2_other              = useTextTransformer(pa.zr_2_other)
  , am.pref_zapps_scorres      = pa.pref_zapps_scorres_label
  , am.apnt_dat_scorres        = pa.apnt_dat_scorres
  , am.zr_confirm_contact      = pa.zr_confirm_contact_label
  , am.preg_test               = pa.preg_test
  , am.zr_ega_days             = pa.zr_ega_days
  , am.zr_wra_ptid             = TRIM(pa.zr_wra_ptid)
  , am.zr_comm_yn              =get_YN_Label(pa.zr_comm_yn)
  , am.zr_comm                 = useTextTransformer(pa.zr_comm)
WHERE pa.np_zapps_scorres IS NOT NULL
   OR pa.name_veri IS NOT NULL;

UPDATE arch_baseline_visit_master_v1 am
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
  AND cr.redcap_event_name = 'wra_baseline_arm_1';

UPDATE arch_baseline_visit_master_v1 am
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
  AND cr.redcap_event_name = 'wra_baseline_arm_1';

UPDATE arch_baseline_visit_master_v1 am
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
  AND cr.redcap_event_name = 'wra_baseline_arm_1';

UPDATE arch_baseline_visit_master_v1 am
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
WHERE sc.redcap_event_name = 'wra_baseline_arm_1';