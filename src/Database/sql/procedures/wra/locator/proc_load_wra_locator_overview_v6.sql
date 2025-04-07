/**
 * Load FU-5 WRA Locator.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 07.04.25
 * @since 0.0.1
 * @alias Load WRA Locator FU-5 Visit Details
 */
DROP PROCEDURE IF EXISTS `Load_WRA_Locator_Overview_V6`;

DELIMITER $$
CREATE PROCEDURE arch_etl_db.Load_WRA_Locator_Overview_V6()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load FU-6 WRA Locator Overview;', @errno, '(',
                              @sqlstate, '):',
                              @text);
            SELECT @full_error;
            RESIGNAL;
        END;
    -- Op matrices
    SET @v_tx_pre_loc_v6 := 0; -- Initial count
    SET @vv_tx_pro_loc_v6 := 0; -- After count

    START TRANSACTION;
    SET @v_tx_pre_loc_v6 = (SELECT COUNT(wra_v6.root_id)
                            FROM arch_etl_db.wra_follow_up_visit_5_repeating_instruments wra_v6
                            WHERE wra_v6.fu_covid_scrn_comments_yn_f5 IN (0, 1));

    TRUNCATE arch_etl_db.crt_wra_visit_6_locator_overview;
    INSERT INTO arch_etl_db.crt_wra_visit_6_locator_overview(record_id,
                                                             alternate_id,
                                                             wra_ptid,
                                                             member_id,
                                                             screening_id,
                                                             age,
                                                             ra,
                                                             visit_number,
                                                             visit_name,
                                                             visit_date)
    SELECT v6.record_id,
           v6.alternate_id,
           v6.wra_ptid,
           v6.member_id,
           v6.screening_id,
           v6.age,
           v6.ra,
           v6.visit_number,
           v6.visit_name,
           v6.visit_date
    FROM arch_etl_db.crt_wra_visit_6_overview v6
             LEFT JOIN arch_etl_db.vw_wra_consent_overview ic
                       ON (v6.record_id = ic.record_id AND v6.visit_number = ic.visit_number)
    WHERE v6.visit_outcome = 'Completed'
      AND ic.ongoing_consent_outcome = 'Accepted'
    ORDER BY v6.visit_date, v6.screening_id DESC;

    UPDATE arch_etl_db.crt_wra_visit_6_locator_overview loc
        LEFT JOIN arch_etl_db.wra_follow_up_visit_5_repeating_instruments wra_v6 ON loc.record_id = wra_v6.record_id
    SET loc.is_same_sbn_from_last_visit             = wra_v6.fu_loc_same_hh_lv_f5_label,
        loc.new_cluster_number                      = wra_v6.wra_fu_cluster_new_f5,
        loc.new_structural_building_number          = wra_v6.wra_fu_sbn_new_f5,
        loc.new_household_unit_number               = wra_v6.wra_fu_hun_new_f5,
        loc.new_household_number                    = wra_v6.wra_fu_hhn_new_f5,
        loc.new_hh_screening_id                     = IF(wra_v6.fu_loc_same_hh_lv_f5 = 0,
                                                         CONCAT_WS('-',
                                                                   LPAD(wra_v6.wra_fu_cluster_new_f5, 3, 0),
                                                                   LPAD(wra_v6.wra_fu_sbn_new_f5, 3, 0),
                                                                   LPAD(wra_v6.wra_fu_hun_new_f5, 3, 0),
                                                                   LPAD(wra_v6.wra_fu_hhn_new_f5, 2, 0)), ''),
        loc.new_migration_location                  = wra_v6.loc_fu_mig_to_scorres_f5_label,
        loc.is_locality_name_known                  = get_YN_Label(wra_v6.loc_fu_loc_known_f5),
        loc.locality_name                           = useStringCapFirst(useAutoTrimmer(wra_v6.loc_fu_locality_name_f5)),
        loc.is_location_address_known               = get_YN_Label(wra_v6.loc_fu_newloc_scorres_yn_f5),
        loc.address_plot_number                     = useStringCapFirst(useAutoTrimmer(wra_v6.loc_fu_newloc_scorres_f5)),
        loc.is_visible_landmark_near_location_known = get_YN_Label(wra_v6.loc_fu_newloc_landmark_f5),
        loc.landmarks                               = useStringCapFirst(useAutoTrimmer(wra_v6.loc_fu_loc_landmarks_f5)),
        loc.directions_known                        = get_YN_Label(wra_v6.loc_fu_loc_direction_f5),
        loc.location_directions                     = useStringCapFirst(useAutoTrimmer(wra_v6.loc_fu_new_directions_f5)),
        loc.date_of_migration                       = wra_v6.loc_fu_mig_dat_scorres_f5,
        loc.is_first_contact_details_valid          = wra_v6.loc_fu_num1_corr_f5_label,
        loc.first_contact_number                    = wra_v6.loc_fu_fc_corr_f5,
        loc.first_contact_number_owner              = IF(wra_v6.loc_fu_pn_belongs_f5 = 8,
                                                         CONCAT_WS(', ', 'Other',
                                                                   useStringCapFirst(useAutoTrimmer(wra_v6.loc_fu_pn_belongs_othr_f5))),
                                                         wra_v6.loc_fu_pn_belongs_f5_label),
        loc.first_contact_person_identification     = useStringCapFirst(useAutoTrimmer(wra_v6.loc_fu_who_is_caller_f5)),
        loc.is_second_contact_details_valid         = wra_v6.loc_fu_num2_corr_f5_label,
        loc.second_contact_number                   = wra_v6.loc_fu_fc_corr_2_f5,
        loc.second_contact_number_owner             = IF(wra_v6.loc_fu_pn_belongs_2_f5 = 8,
                                                         CONCAT_WS(', ', 'Other',
                                                                   useStringCapFirst(useAutoTrimmer(wra_v6.loc_fu_pn_belongs_othr_2_f5))),
                                                         wra_v6.loc_fu_pn_belongs_2_f5_label),
        loc.second_contact_person_identification    = useStringCapFirst(useAutoTrimmer(wra_v6.loc_fu_who_is_caller_2_f5))
    WHERE wra_v6.wra_follow_up_visit_5_repeating_instruments_id = loc.alternate_id;
    COMMIT;

    -- Process Metrics
    SET @vv_tx_pro_loc_v6 = (SELECT COUNT(loc_v6.record_id) FROM arch_etl_db.crt_wra_visit_6_locator_overview loc_v6);
    SET @v_load_metrics = CONCAT_WS(' of ', @vv_tx_pro_loc_v6, @v_tx_pre_loc_v6);
    SET @v_load_info = CONCAT('WRA-Locator-V6-Data: LOADING COMPLETE. ', @v_load_metrics);
    SELECT @v_load_info as `|_________________| Operation_Summary |_________________|`;

END $$

DELIMITER ;
