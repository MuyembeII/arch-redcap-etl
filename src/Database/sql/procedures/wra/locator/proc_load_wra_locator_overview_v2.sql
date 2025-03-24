/**
 * Load FU-1 WRA Locator.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 24.03.25
 * @since 0.0.1
 * @alias Load WRA Locator FU-1 Visit Details
 */
DROP PROCEDURE IF EXISTS `Load_WRA_Locator_Overview_V2`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_Locator_Overview_V2()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load FU-1 WRA Locator Overview;', @errno, '(',
                              @sqlstate, '):',
                              @text);
            SELECT @full_error;
            RESIGNAL;
        END;
    -- Op matrices
    SET @v_tx_pre_loc_v2 := 0; -- Initial count
    SET @vv_tx_pro_loc_v2 := 0; -- After count

    START TRANSACTION;
    SET @v_tx_pre_loc_v2 = (SELECT COUNT(wra_v2.root_id)
                            FROM arch_etl_db.wra_follow_up_visit_repeating_instruments wra_v2
                            WHERE wra_v2.fu_covid_scrn_comments_yn IN (0, 1));

    TRUNCATE arch_etl_db.crt_wra_visit_2_locator_overview;
    INSERT INTO arch_etl_db.crt_wra_visit_2_locator_overview(record_id,
                                                             alternate_id,
                                                             wra_ptid,
                                                             member_id,
                                                             screening_id,
                                                             age,
                                                             ra,
                                                             visit_number,
                                                             visit_name,
                                                             visit_date)
    SELECT v2.record_id,
           v2.alternate_id,
           v2.wra_ptid,
           v2.member_id,
           v2.screening_id,
           v2.age,
           v2.ra,
           v2.visit_number,
           v2.visit_name,
           v2.visit_date
    FROM arch_etl_db.crt_wra_visit_2_overview v2
             LEFT JOIN arch_etl_db.vw_wra_consent_overview ic
                       ON (v2.record_id = ic.record_id AND v2.visit_number = ic.visit_number)
    WHERE v2.visit_outcome = 'Completed'
      AND ic.ongoing_consent_outcome = 'Accepted'
    ORDER BY v2.visit_date, v2.screening_id DESC;

    UPDATE arch_etl_db.crt_wra_visit_2_locator_overview loc
        LEFT JOIN arch_etl_db.wra_follow_up_visit_repeating_instruments wra_v2 ON loc.record_id = wra_v2.record_id
    SET loc.is_same_sbn_from_last_visit             = wra_v2.fu_loc_same_hh_lv_label,
        loc.new_cluster_number                      = wra_v2.wra_fu_cluster_prev,
        loc.new_structural_building_number          = wra_v2.wra_fu_sbn_prev,
        loc.new_household_unit_number               = wra_v2.wra_fu_hun_prev,
        loc.new_household_number                    = wra_v2.wra_fu_hhn_prev,
        loc.new_hh_screening_id                     = IF(wra_v2.fu_loc_same_hh_lv = 0,
                                                         CONCAT_WS('-',
                                                                   LPAD(wra_v2.wra_fu_cluster_prev, 3, 0),
                                                                   LPAD(wra_v2.wra_fu_sbn_prev, 3, 0),
                                                                   LPAD(wra_v2.wra_fu_hun_prev, 3, 0),
                                                                   LPAD(wra_v2.wra_fu_hhn_prev, 2, 0)), ''),
        loc.new_migration_location                  = wra_v2.loc_fu_mig_to_scorres_label,
        loc.is_locality_name_known                  = get_YN_Label(wra_v2.loc_fu_loc_known),
        loc.locality_name                           = useStringCapFirst(useAutoTrimmer(wra_v2.loc_fu_locality_name)),
        loc.is_location_address_known               = get_YN_Label(wra_v2.loc_fu_newloc_scorres_yn),
        loc.address_plot_number                     = useStringCapFirst(useAutoTrimmer(wra_v2.loc_fu_newloc_scorres)),
        loc.is_visible_landmark_near_location_known = get_YN_Label(wra_v2.loc_fu_newloc_landmark),
        loc.landmarks                               = useStringCapFirst(useAutoTrimmer(wra_v2.loc_fu_loc_landmarks)),
        loc.directions_known                        = get_YN_Label(wra_v2.loc_fu_loc_direction),
        loc.location_directions                     = useStringCapFirst(useAutoTrimmer(wra_v2.loc_fu_new_directions)),
        loc.date_of_migration                       = wra_v2.loc_fu_mig_dat_scorres,
        loc.is_first_contact_details_valid          = wra_v2.loc_fu_num1_corr_label,
        loc.first_contact_number                    = wra_v2.loc_fu_fc_corr,
        loc.first_contact_number_owner              = IF(wra_v2.loc_fu_pn_belongs = 8,
                                                         CONCAT_WS(', ', 'Other',
                                                                   useStringCapFirst(useAutoTrimmer(wra_v2.loc_fu_pn_belongs_othr))),
                                                         wra_v2.loc_fu_pn_belongs_label),
        loc.first_contact_person_identification     = useStringCapFirst(useAutoTrimmer(wra_v2.loc_fu_who_is_caller)),
        loc.is_second_contact_details_valid         = wra_v2.loc_fu_num2_corr_label,
        loc.second_contact_number                   = wra_v2.loc_fu_fc_corr_2,
        loc.second_contact_number_owner             = IF(wra_v2.loc_fu_pn_belongs_2 = 8,
                                                         CONCAT_WS(', ', 'Other',
                                                                   useStringCapFirst(useAutoTrimmer(wra_v2.loc_fu_pn_belongs_othr_2))),
                                                         wra_v2.loc_fu_pn_belongs_2_label),
        loc.second_contact_person_identification    = useStringCapFirst(useAutoTrimmer(wra_v2.loc_fu_who_is_caller_2))
    WHERE wra_v2.wra_follow_up_visit_repeating_instruments_id = loc.alternate_id;
    COMMIT;

    -- Process Metrics
    SET @vv_tx_pro_loc_v2 = (SELECT COUNT(loc_v2.record_id) FROM arch_etl_db.crt_wra_visit_2_locator_overview loc_v2);
    SET @v_load_metrics = CONCAT_WS(' of ', @vv_tx_pro_loc_v2, @v_tx_pre_loc_v2);
    SET @v_load_info = CONCAT('WRA-Locator-V2-Data: LOADING COMPLETE. ', @v_load_metrics);
    SELECT @v_load_info as `|_________________| Operation_Summary |_________________|`;

END $$

DELIMITER ;
