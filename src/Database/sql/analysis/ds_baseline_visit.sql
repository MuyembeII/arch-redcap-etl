-- Baseline Overview
SET time_zone = '+02:00';
INSERT INTO arch_etl_db.arch_baseline_visit_master( id
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
                                   , estimated_age
                                   , wra_enr_nok_avail
                                   , kin_lang_scorres
                                   , kin_lang_scorres_oth
                                   , con_witness_signature_pryn
                                   , icf_nok_ca1
                                   , icf_nok_ca2
                                   , icf_nok_ca3
                                   , icf_nok_ca4
                                   , icf_nok_ca5
                                   , icf_nok_ca6
                                   , icf_nok_score
                                   , con_lar_signdat
                                   , wra_enr_nok_name
                                   , con_lar_signdat_2
                                   , wra_enr_nok_ra_name
                                   , con_lar_yn_dsdecod
                                   , wra_enr_nok_ltsa
                                   , wra_enr_nok_lts_sign_date
                                   , wra_enr_nok_lts_name
                                   , wra_enr_nok_name_ent
                                   , wra_enr_nok_lts_ra_sign_date
                                   , wra_enr_nok_lts_ra_name
                                   , con_witness_signdat
                                   , wra_enr_witness_name
                                   , wra_enr_part_lang
                                   , part_lang_other
                                   , wra_enr_wrdc
                                   , icf_ca1
                                   , icf_ca2
                                   , icf_ca3
                                   , icf_ca4
                                   , icf_ca5
                                   , icf_ca6
                                   , icf_score
                                   , wra_enr_aasp
                                   , catchment_ieorres
                                   , con_dsstdat
                                   , wra_participant_name
                                   , con_yn_dsdecod
                                   , wra_enr_ra_sign_date
                                   , wra_ra_name
                                   , con_samples_dsdecod
                                   , wra_enr_date_lts
                                   , wra_enr_part_name_lts
                                   , wra_enr_lts_ra_sign_date
                                   , wra_lts_ra_name
                                   , wra_enr_sign_date_wit
                                   , wra_enr_pr_wit_name
                                   , wra_enr_pdrv
                                   , wra_enr_ptrv
                                   , othr_reason_ieorres_1
                                   , othr_reason_ieorres_2
                                   , othr_reason_ieorres_3
                                   , othr_reason_ieorres_4
                                   , othr_reason_ieorres_5
                                   , othr_reason_ieorres_6
                                   , othr_spfy_ieorres
                                   , icc_eligibility_adult_1
                                   , icc_eligibility_minor_1
                                   , icc_ineligibility_1
                                   , icc_icc_signed_1
                                   , icc_ica_not_signed_1
                                   , icc_ica_sign_time
                                   , icc_wra_or_nok_read
                                   , icc_lang
                                   , icc_witness_name
                                   , icc_witness_rel
                                   , icc_per_sop
                                   , icc_check1
                                   , icc_check2
                                   , icc_check3
                                   , icc_check4
                                   , icc_accepted_sign
                                   , icc_sign_date
                                   , icc_comments
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
                                   , months_preg_scorres
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
SELECT v1.alternate_id                           as id
     , v1.record_id
     , v1.visit_number
     , v1.visit_name
     , v1.visit_outcome
     , bsv.wra_timestamp
     , bsv.hh_scrn_num_obsloc
     , CAST(bsv.wra_enr_visit_count as UNSIGNED) as wra_enr_visit_count
     , CAST(bsv.attempt_count as UNSIGNED)       as attempt_count
     , CAST(bsv.hhe_hh_member_id as UNSIGNED)    as hhe_hh_member_id
     , bsv.scrn_obsstdat
     , bsv.wra_enr_interviewer_obsloc
     , bsv.wra_enr_hhh_pvc
     , bsv.wra_enr_reas_decline
     , bsv.wra_enr_pp_avail
     , bsv.is_wra_avail_other
     , bsv.estimated_age
     , bsv.wra_enr_nok_avail
     , bsv.kin_lang_scorres
     , bsv.kin_lang_scorres_oth
     , bsv.con_witness_signature_pryn
     , bsv.icf_nok_ca1
     , bsv.icf_nok_ca2
     , bsv.icf_nok_ca3
     , bsv.icf_nok_ca4
     , bsv.icf_nok_ca5
     , bsv.icf_nok_ca6
     , bsv.icf_nok_score
     , bsv.con_lar_signdat
     , bsv.wra_enr_nok_name
     , bsv.con_lar_signdat_2
     , bsv.wra_enr_nok_ra_name
     , bsv.con_lar_yn_dsdecod
     , bsv.wra_enr_nok_ltsa
     , bsv.wra_enr_nok_lts_sign_date
     , bsv.wra_enr_nok_lts_name
     , bsv.wra_enr_nok_name_ent
     , bsv.wra_enr_nok_lts_ra_sign_date
     , bsv.wra_enr_nok_lts_ra_name
     , bsv.con_witness_signdat
     , bsv.wra_enr_witness_name
     , bsv.wra_enr_part_lang
     , bsv.part_lang_other
     , bsv.wra_enr_wrdc
     , bsv.icf_ca1
     , bsv.icf_ca2
     , bsv.icf_ca3
     , bsv.icf_ca4
     , bsv.icf_ca5
     , bsv.icf_ca6
     , bsv.icf_score
     , bsv.wra_enr_aasp
     , bsv.catchment_ieorres
     , bsv.con_dsstdat
     , bsv.wra_participant_name
     , bsv.con_yn_dsdecod
     , bsv.wra_enr_ra_sign_date
     , bsv.wra_ra_name
     , bsv.con_samples_dsdecod
     , bsv.wra_enr_date_lts
     , bsv.wra_enr_part_name_lts
     , bsv.wra_enr_lts_ra_sign_date
     , bsv.wra_lts_ra_name
     , bsv.wra_enr_sign_date_wit
     , bsv.wra_enr_pr_wit_name
     , bsv.wra_enr_pdrv
     , bsv.wra_enr_ptrv
     , bsv.othr_reason_ieorres___1               as othr_reason_ieorres_1
     , bsv.othr_reason_ieorres___2               as othr_reason_ieorres_2
     , bsv.othr_reason_ieorres___3               as othr_reason_ieorres_3
     , bsv.othr_reason_ieorres___4               as othr_reason_ieorres_4
     , bsv.othr_reason_ieorres___5               as othr_reason_ieorres_5
     , bsv.othr_reason_ieorres___6               as othr_reason_ieorres_6
     , bsv.othr_spfy_ieorres
     , bsv.icc_eligibility_adult___1             as icc_eligibility_adult_1
     , bsv.icc_eligibility_minor___1             as icc_eligibility_minor_1
     , bsv.icc_ineligibility___1                 as icc_ineligibility_1
     , bsv.icc_icc_signed___1                    as icc_icc_signed_1
     , bsv.icc_ica_not_signed___1                as icc_ica_not_signed_1
     , bsv.icc_ica_sign_time
     , bsv.icc_wra_or_nok_read
     , bsv.icc_lang
     , bsv.icc_witness_name
     , bsv.icc_witness_rel
     , bsv.icc_per_sop
     , bsv.icc_check1
     , bsv.icc_check2
     , bsv.icc_check3
     , bsv.icc_check4
     , bsv.icc_accepted_sign
     , bsv.icc_sign_date
     , bsv.icc_comments
     , bsv.brthdat
     , bsv.wra_age
     , bsv.wra_ptid
     , bsv.fname_scorres
     , bsv.mname_scorres
     , bsv.lname_scorres
     , bsv.wra_enr_full_name
     , bsv.oname_scorres
     , bsv.wra_enr_comments_yn
     , bsv.wra_enr_comments
     , bsv.c19vax_cmyn
     , bsv.c19vax_cmtrt
     , bsv.covid_scrn_3
     , bsv.c19_lbperf
     , bsv.covid_test_dt_range
     , bsv.c19_lbdat
     , bsv.c19_lborres
     , bsv.fever_ceoccur
     , bsv.cough_ceoccur
     , bsv.shortbreath_ceoccur
     , bsv.sorethroat_ceoccur
     , bsv.fatigue_ceoccur
     , bsv.myalgia_ceoccur
     , bsv.anorexia_ceoccur
     , bsv.nausea_ceoccur
     , bsv.diarrhoea_ceoccur
     , bsv.ageusia_ceoccur
     , bsv.anosmia_ceoccur
     , bsv.runnynose_ceoccur
     , bsv.sneeze_ceoccur
     , bsv.headache_ceoccur
     , bsv.rash_ceoccur
     , bsv.conjunct_ceoccur
     , bsv.c19_contact_dx_ceoccur
     , bsv.c19_contact_sx_ceoccur
     , bsv.hh_member_id
     , bsv.covid_scrn_9
     , bsv.c19_zm_scorres
     , bsv.covid_scrn_comments_yn
     , bsv.covid_scrn_comments
     , bsv.loc_fc_num
     , bsv.loc_pn_belongs_oth
     , bsv.loc_who_is_caller
     , bsv.loc_pn_belongs
     , CAST(bsv.loc_sc_num as UNSIGNED)          as loc_sc_num
     , bsv.loc_pn_belongs_2
     , bsv.loc_pn_belongs_oth_2
     , bsv.loc_who_is_caller_2
     , bsv.loc_tc_num
     , bsv.loc_pn_belongs_3
     , bsv.loc_pn_belongs_oth_3
     , bsv.loc_who_is_caller_3
     , bsv.loc_other_contacts_3
     , CAST(bsv.loc_fthc_num as UNSIGNED)        as loc_fthc_num
     , bsv.loc_pn_belongs_4
     , bsv.loc_who_is_caller_4
     , bsv.loc_enrolled_zapps
     , bsv.loc_zapps_ptid
     , bsv.loc_zapps_ptid_src
     , bsv.famliid_yn
     , bsv.famli_id_scorres
     , bsv.loc_famli_id_src
     , bsv.loc_comments_yn
     , bsv.loc_comments
     , bsv.scdmar_scorres
     , bsv.scd_agemar_scorres
     , bsv.school_scorres
     , bsv.sd_highest_edu_level
     , bsv.school_yrs_scorres
     , bsv.scd_occupation_scorres
     , bsv.sd_approx_income_pay
     , bsv.scd_mobile_fcorres
     , bsv.scd_mh_tob_suyn
     , bsv.scd_mh_tob_sudosfrq
     , bsv.scd_tob_chew_sutrt
     , bsv.scd_alc_suyn
     , bsv.scd_comments_yn
     , bsv.scd_comments
     , bsv.hhc_completed
     , bsv.hhc_ha1
     , bsv.hhc_ha1_other
     , bsv.hhc_ha2
     , bsv.hhc_ha2_other
     , bsv.hh_numhh_fcorres
     , bsv.hh_rms_fcorres
     , bsv.hh_sleep_fcorres
     , bsv.hh_assets_fcorres___1                 as hh_assets_fcorres_1
     , bsv.hh_assets_fcorres___2                 as hh_assets_fcorres_2
     , bsv.hh_assets_fcorres___3                 as hh_assets_fcorres_3
     , bsv.hh_assets_fcorres___4                 as hh_assets_fcorres_4
     , bsv.hh_assets_fcorres___5                 as hh_assets_fcorres_5
     , bsv.hh_assets_fcorres___6                 as hh_assets_fcorres_6
     , bsv.hh_assets_fcorres___7                 as hh_assets_fcorres_7
     , bsv.hh_assets_fcorres___8                 as hh_assets_fcorres_8
     , bsv.hh_assets_fcorres___9                 as hh_assets_fcorres_9
     , bsv.hh_assets_fcorres___10                as hh_assets_fcorres_10
     , bsv.hh_assets_fcorres___11                as hh_assets_fcorres_11
     , bsv.hh_assets_fcorres___12                as hh_assets_fcorres_12
     , bsv.hh_assets_fcorres___13                as hh_assets_fcorres_13
     , bsv.hh_assets_fcorres___14                as hh_assets_fcorres_14
     , bsv.hh_assets_fcorres___15                as hh_assets_fcorres_15
     , bsv.hh_assets_fcorres___16                as hh_assets_fcorres_16
     , bsv.hh_assets_fcorres___17                as hh_assets_fcorres_17
     , bsv.hh_assets_fcorres___18                as hh_assets_fcorres_18
     , bsv.hh_assets_fcorres___19                as hh_assets_fcorres_19
     , bsv.hh_assets_fcorres___20                as hh_assets_fcorres_20
     , bsv.hh_assets_fcorres___21                as hh_assets_fcorres_21
     , bsv.hh_assets_fcorres___22                as hh_assets_fcorres_22
     , bsv.hh_asset_ownr___1                     as hh_asset_ownr_1
     , bsv.hh_asset_ownr___2                     as hh_asset_ownr_2
     , bsv.hh_asset_ownr___3                     as hh_asset_ownr_3
     , bsv.hh_asset_ownr___4                     as hh_asset_ownr_4
     , bsv.hh_asset_ownr___5                     as hh_asset_ownr_5
     , bsv.hh_asset_ownr___6                     as hh_asset_ownr_6
     , bsv.hh_asset_ownr___7                     as hh_asset_ownr_7
     , bsv.hh_asset_ownr___8                     as hh_asset_ownr_8
     , bsv.hh_asset_ownr___9                     as hh_asset_ownr_9
     , bsv.livestock_fcorres
     , bsv.land_fcorres
     , bsv.ext_wall_fcorres
     , bsv.ext_wall_othr_fcorres
     , bsv.floor_fcorres
     , bsv.floor_othr_fcorres
     , bsv.roof_fcorres
     , bsv.roof_spfy_fcorres
     , bsv.wash_ob_loc
     , bsv.wash_h2o_ob
     , bsv.wash_soap_ob___1                      as wash_soap_ob_1
     , bsv.wash_soap_ob___2                      as wash_soap_ob_2
     , bsv.wash_soap_ob___3                      as wash_soap_ob_3
     , bsv.h2o_fcorres
     , bsv.h2o_othr_fcorres
     , bsv.h2o_loc_fcorres
     , bsv.hloc_othr_fcorres
     , bsv.minutes
     , bsv.h2o_prep_fcorres
     , bsv.h2o_hprep_fcorres___1                 as h2o_hprep_fcorres_1
     , bsv.h2o_hprep_fcorres___2                 as h2o_hprep_fcorres_2
     , bsv.h2o_hprep_fcorres___3                 as h2o_hprep_fcorres_3
     , bsv.h2o_hprep_fcorres___4                 as h2o_hprep_fcorres_4
     , bsv.h2o_hprep_fcorres___5                 as h2o_hprep_fcorres_5
     , bsv.h2o_hprep_fcorres___6                 as h2o_hprep_fcorres_6
     , bsv.h2o_hprep_fcorres___96                as h2o_hprep_fcorres_96
     , bsv.h2o_hprep_fcorres___98                as h2o_hprep_fcorres_98
     , bsv.h2o_hprep_othr_fcorres
     , bsv.toilet_fcorres
     , bsv.toilet_othr_fcorres
     , bsv.toilet_loc_fcorres
     , bsv.toilet_loc_othr_fcorres
     , bsv.toilet_share_fcorres
     , bsv.toilet_share_num_fcorres
     , bsv.obchar_commnts_yn
     , bsv.obchar_commnts
     , bsv.cooking_inside_fcorres
     , bsv.cooking_room_fcorres
     , bsv.cooking_loc_fcorres
     , bsv.cooking_loc_othr_fcorres
     , bsv.cooking_vent_fcorres
     , bsv.cooking_fuel_fcorres
     , bsv.cooking_fuel_othr_fcorres
     , bsv.light_fuel_fcorres
     , bsv.light_fuel_othr_fcorres
     , bsv.heat_fuel_fcorres
     , bsv.heat_fuel_othr_fcorres
     , bsv.smoke_hhold_freq_in_oecoccur
     , bsv.air_pol_comm_yn
     , bsv.air_pol_comm
     , bsv.hh_nofd_scorres
     , bsv.hh_nofd_frq_scorres
     , bsv.hh_nofd_sleep_scorres
     , bsv.hh_nofd_sleep_frq_scorres
     , bsv.hh_nofd_night_scorres
     , bsv.hh_nofd_night_frq_scorres
     , bsv.hfs_coyn
     , bsv.hfs_coval
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
     , CAST(mha.phq9_total_scorres as UNSIGNED)  as phq9_total_scorres
     , mha.zds_depression_sevr
     , CAST(mha.ds_is_cr_required as UNSIGNED)   as ds_is_cr_required
     , mha.phq9_coyn
     , mha.phq9_coval
     , mha.anx_1
     , mha.anx_2
     , mha.anx_3
     , mha.anx_4
     , mha.anx_5
     , mha.anx_6
     , mha.anx_7
     , CAST(mha.anx_total_score as UNSIGNED)     as anx_total_score
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
     , CAST(mha.pss_total_scorres as UNSIGNED)   as pss_total_scorres
     , mha.sa_zassessment_result
     , mha.pss_coyn
     , mha.ss_comments
     , pos.ph_prev_rporres
     , pos.pho_num_preg_rporres
     , pos.ph_live_rporres
     , CAST(pos.pho_preg_count as UNSIGNED)      as pho_preg_count
     , pos.ph_loss_rporres
     , pos.ph_bs_rporres_2
     , pos.ph_bs_rporres
     , CAST(pos.pho_loss_count as UNSIGNED)      as pho_loss_count
     , pos.stlb_num_rporres_2
     , pos.stlb_num_rporres
     , pos.pho_comments_yn
     , pos.pho_comments
     , pos.lmp_reg_scorres
     , pos.lmp_kd_scorres
     , pos.lmp_kd_scorres_other
     , pos.lmp_start_scorres
     , pos.lmp_scdat
     , pos.lmp_cat_scorres
     , pos.lmp_start_weeks
     , pos.lmp_start_months
     , pos.lmp_start_years
     , pos.lmp_scorres
     , pos.ps_mens_cal_yn
     , pos.lmp_dt_rec_cal
     , pos.preg_scorres
     , pos.months_preg_scorres
     , pos.np_pregid_mhyn
     , pos.np_date_of_test
     , pos.np_date_of_test_2
     , pos.np_us_test_dat
     , pos.np_bld_test_dat
     , pos.apreg_date
     , pos.ps_pregnancy_id
     , pos.np_us_edd_dat
     , pos.np_edd_src
     , pos.preg_surv_comm
     , pos.preg_surv_commnts
FROM crt_wra_visit_1_overview v1
         LEFT JOIN wra_forms_repeating_instruments bsv ON v1.alternate_id = bsv.wra_forms_repeating_instruments_id
         LEFT JOIN wra_mental_health_assessment mha ON v1.record_id = mha.record_id
         LEFT JOIN wra_pregnancy_overview_and_surveillance pos ON v1.record_id = pos.record_id
WHERE mha.redcap_event_name = 'wra_baseline_arm_1'
  AND mha.phq9_interest_scorres IS NOT NULL;


UPDATE arch_baseline_visit_master am
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
WHERE poc.redcap_event_name = 'wra_baseline_arm_1';

UPDATE arch_baseline_visit_master am
    LEFT JOIN arch_etl_db.wra_pregnancy_assessments pa ON am.record_id = pa.record_id
SET am.wra_pregnancy_id        = pa.wra_pregnancy_id
  , am.np_zapps_scorres        = pa.np_zapps_scorres
  , am.np_zapps_ptid           = pa.np_zapps_ptid
  , am.np_zapps_id_src         = pa.np_zapps_id_src
  , am.np_ident_arch           = pa.np_ident_arch
  , am.np_ptw_1                = pa.np_ptw___1
  , am.np_ptw_2                = pa.np_ptw___2
  , am.np_ptw_3                = pa.np_ptw___3
  , am.np_ptw_4                = pa.np_ptw___4
  , am.np_ptw_5                = pa.np_ptw___5
  , am.np_ptw_6                = pa.np_ptw___6
  , am.np_ptw_7                = pa.np_ptw___7
  , am.np_anc_mhyn             = pa.np_anc_mhyn
  , am.np_anc_num_mh           = pa.np_anc_num_mh
  , am.np_anc1_dat             = pa.np_anc1_dat
  , am.np_anc1_ga              = pa.np_anc1_ga
  , am.anc1_ga_weeks           = pa.anc1_ga_weeks
  , am.anc1_ga_months          = pa.anc1_ga_months
  , am.np_anc_plan_obsloc      = pa.np_anc_plan_obsloc
  , am.birth_plan_fac_obsloc   = pa.birth_plan_fac_obsloc
  , am.facility_other          = pa.facility_other
  , am.birth_other_loc         = pa.birth_other_loc
  , am.np_del_decide_scorres   = pa.np_del_decide_scorres
  , am.del_decide_spfy_scorres = pa.del_decide_spfy_scorres
  , am.cph_comments_yn         = pa.cph_comments_yn
  , am.cph_comments            = pa.cph_comments
  , am.np_alc_suyn             = pa.np_alc_suyn
  , am.np_alc_cons             = pa.np_alc_cons
  , am.np_tob_suyn             = pa.np_tob_suyn
  , am.np_tob_cur_sudosfrq     = pa.np_tob_cur_sudosfrq
  , am.tob_oth_sutrt_1         = pa.tob_oth_sutrt___1
  , am.tob_oth_sutrt_2         = pa.tob_oth_sutrt___2
  , am.tob_oth_sutrt_3         = pa.tob_oth_sutrt___3
  , am.tob_oth_sutrt_4         = pa.tob_oth_sutrt___4
  , am.tob_oth_sutrt_5         = pa.tob_oth_sutrt___5
  , am.tob_oth_sutrt_6         = pa.tob_oth_sutrt___6
  , am.tob_oth_sutrt_7         = pa.tob_oth_sutrt___7
  , am.other_tbc_use           = pa.other_tbc_use
  , am.np_drug_suyn            = pa.np_drug_suyn
  , am.np_drug_usage           = pa.np_drug_usage
  , am.np_drug_sutrt_1         = pa.np_drug_sutrt___1
  , am.np_drug_sutrt_2         = pa.np_drug_sutrt___2
  , am.np_drug_sutrt_3         = pa.np_drug_sutrt___3
  , am.np_drug_sutrt_4         = pa.np_drug_sutrt___4
  , am.np_drug_sutrt_5         = pa.np_drug_sutrt___5
  , am.np_drug_sutrt_6         = pa.np_drug_sutrt___6
  , am.np_drug_sutrt_7         = pa.np_drug_sutrt___7
  , am.np_drug_sutrt_othr      = pa.np_drug_sutrt_othr
  , am.hbp_comments_yn         = pa.hbp_comments_yn
  , am.hbp_comments            = pa.hbp_comments
  , am.name_veri               = pa.name_veri
  , am.brthdat_veri            = pa.brthdat_veri
  , am.ref_likely_scorres      = pa.ref_likely_scorres
  , am.ref_res_decline_1       = pa.ref_res_decline___1
  , am.ref_res_decline_2       = pa.ref_res_decline___2
  , am.ref_res_decline_3       = pa.ref_res_decline___3
  , am.ref_res_decline_4       = pa.ref_res_decline___4
  , am.ref_res_decline_5       = pa.ref_res_decline___5
  , am.ref_res_decline_6       = pa.ref_res_decline___6
  , am.zr_2_other              = pa.zr_2_other
  , am.pref_zapps_scorres      = pa.pref_zapps_scorres
  , am.apnt_dat_scorres        = pa.apnt_dat_scorres
  , am.zr_confirm_contact      = pa.zr_confirm_contact
  , am.preg_test               = pa.preg_test
  , am.zr_ega_days             = pa.zr_ega_days
  , am.zr_wra_ptid             = pa.zr_wra_ptid
  , am.zr_comm_yn              = pa.zr_comm_yn
  , am.zr_comm                 = pa.zr_comm
WHERE pa.np_zapps_scorres IS NOT NULL
   OR pa.name_veri IS NOT NULL;

UPDATE arch_baseline_visit_master am
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
  AND cr.redcap_event_name = 'wra_baseline_arm_1';

UPDATE arch_baseline_visit_master am
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
  AND cr.redcap_event_name = 'wra_baseline_arm_1';

UPDATE arch_baseline_visit_master am
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
  AND cr.redcap_event_name = 'wra_baseline_arm_1';

UPDATE arch_baseline_visit_master am
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
WHERE sc.redcap_event_name = 'wra_baseline_arm_1';

