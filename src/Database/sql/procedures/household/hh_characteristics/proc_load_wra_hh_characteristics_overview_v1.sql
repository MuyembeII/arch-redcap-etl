/**
 * Load Baseline WRA Household Characteristics.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 01.04.25
 * @since 0.0.1
 * @alias Load WRA HH Characteristics Baseline
 */
DROP PROCEDURE IF EXISTS `Load_WRA_HH_Characteristics_Overview_V1`;

DELIMITER $$
CREATE PROCEDURE arch_etl_db.Load_WRA_HH_Characteristics_Overview_V1()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to run CRT PROC [Load_WRA_HH_Characteristics_Overview_V1];', @errno,
                              '(',
                              @sqlstate, '):',
                              @text);
            SELECT @full_error;
            RESIGNAL;
        END;
    -- Op matrices
    SET @v_tx_pre_hhc_v1 := 0; -- Initial count
    SET @v_tx_pro_hhc_v1 := 0; -- After count

    START TRANSACTION;
    SET @v_tx_pre_hhc_v1 = (SELECT COUNT(wra_v1.root_id)
                            FROM wra_forms_repeating_instruments wra_v1
                            WHERE wra_v1.scd_comments_yn IN (0, 1));

    TRUNCATE arch_etl_db.crt_wra_household_characteristics_overview;
    INSERT INTO arch_etl_db.crt_wra_household_characteristics_overview(record_id,
                                                                       alternate_id,
                                                                       wra_ptid,
                                                                       member_id,
                                                                       screening_id,
                                                                       age,
                                                                       ra,
                                                                       visit_number,
                                                                       visit_name,
                                                                       visit_date,
                                                                       days_since_baseline)
    SELECT v1.record_id,
           v1.alternate_id,
           v1.wra_ptid,
           v1.member_id,
           v1.screening_id,
           v1.age,
           v1.ra,
           v1.visit_number,
           v1.visit_name,
           v1.visit_date,
           getDaysSinceBaselineVisit(v1.record_id, v1.visit_date) as days_since_baseline
    FROM crt_wra_visit_1_overview v1
    WHERE v1.record_id IN
          (SELECT CAST(bsl.record_id as UNSIGNED) as record_id
           FROM wra_forms_repeating_instruments bsl
           WHERE bsl.scd_comments_yn IS NOT NULL AND hhc_completed = 0)
    ORDER BY v1.visit_date, v1.screening_id DESC;

    UPDATE crt_wra_household_characteristics_overview hhc
        LEFT JOIN wra_forms_repeating_instruments wra_v1 ON hhc.record_id = CAST(wra_v1.record_id as UNSIGNED)
    SET hhc.house_ownership                         = IF(wra_v1.hhc_ha1 = 7, useAutoTrimmer(wra_v1.hhc_ha1_other),
                                                         wra_v1.hhc_ha1_label),
        hhc.head_of_household                       = IF(wra_v1.hhc_ha2 = 6, useAutoTrimmer(wra_v1.hhc_ha2_other),
                                                         wra_v1.hhc_ha2_label),
        hhc.hh_tx_people                            = wra_v1.hh_numhh_fcorres,
        hhc.hh_tx_rooms                             = wra_v1.hh_rms_fcorres,
        hhc.hh_tx_rooms_for_sleeping                = wra_v1.hh_sleep_fcorres,
        hhc.hh_assets                               = getHouseholdAssets_V1(hhc.alternate_id),
        hhc.hh_member_assets                        = getHouseholdMemberAssets_V1(hhc.alternate_id),
        hhc.hh_owns_livestock_herds_poultry         =get_YN_Label(wra_v1.livestock_fcorres),
        hhc.hh_owns_agriculture_land                = get_YN_Label(wra_v1.land_fcorres),
        hhc.hh_exterior_wall_building_material      = IF(wra_v1.ext_wall_fcorres = 96,
                                                         useAutoTrimmer(wra_v1.ext_wall_othr_fcorres),
                                                         wra_v1.ext_wall_fcorres_label),
        hhc.hh_floor_building_material              = IF(wra_v1.floor_fcorres = 96,
                                                         useAutoTrimmer(wra_v1.floor_othr_fcorres),
                                                         wra_v1.floor_fcorres_label),
        hhc.hh_roof_building_material               = IF(wra_v1.roof_fcorres = 96,
                                                         useAutoTrimmer(wra_v1.roof_spfy_fcorres),
                                                         wra_v1.roof_fcorres_label),
        hhc.hh_place_for_hand_wash                  = wra_v1.wash_ob_loc_label,
        hhc.hh_place_for_hand_wash_observation      = IF(wra_v1.wash_h2o_ob = 1,
                                                         'Water is Available', IF(wra_v1.wash_h2o_ob = 2,
                                                                                  'Water isn''t Available', '')),
        hhc.hh_handwash_cleansing_agent_observation = getHouseholdHandWashCleansingAgents_V1(hhc.alternate_id)
    WHERE wra_v1.wra_forms_repeating_instruments_id = hhc.alternate_id;
    COMMIT;

    -- Process Metrics
    SET @v_tx_pro_hhc_v1 = (SELECT COUNT(hhc_v1.record_id) FROM crt_wra_household_characteristics_overview hhc_v1);
    SET @v_load_metrics = CONCAT_WS(' of ', @v_tx_pro_hhc_v1, @v_tx_pre_hhc_v1);
    SET @v_load_info = CONCAT('WRA-HH-Characteristics-V1-Data: LOADING COMPLETE. ', @v_load_metrics);
    SELECT @v_load_info as `|_________________| Operation_Summary |_________________|`;

END $$

DELIMITER ;
