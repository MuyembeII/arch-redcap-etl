/**
 * Load Baseline WRA Locator.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 23.03.25
 * @since 0.0.1
 * @alias Load WRA Locator Baseline Visit Details
 */
DROP PROCEDURE IF EXISTS `Load_WRA_Locator_Overview_V1`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_Locator_Overview_V1()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to load Baseline WRA Locator Overview;', @errno, '(',
                              @sqlstate, '):',
                              @text);
            SELECT @full_error;
            RESIGNAL;
        END;
    -- Op matrices
    SET @v_tx_pre_loc_v1 := 0; -- Initial count
    SET @vv_tx_pro_loc_v1 := 0; -- After count

    START TRANSACTION;
    SET @v_tx_pre_loc_v1 = (SELECT COUNT(wra_v1.root_id)
                            FROM arch_etl_db.wra_forms_repeating_instruments wra_v1
                            WHERE wra_v1.covid_scrn_comments_yn IN (0, 1));

    TRUNCATE arch_etl_db.crt_wra_visit_1_locator_overview;
    INSERT INTO arch_etl_db.crt_wra_visit_1_locator_overview(record_id,
                                                             alternate_id,
                                                             wra_ptid,
                                                             member_id,
                                                             screening_id,
                                                             age,
                                                             ra,
                                                             visit_number,
                                                             visit_name,
                                                             visit_date)
    SELECT v1.record_id,
           v1.alternate_id,
           v1.wra_ptid,
           v1.member_id,
           v1.screening_id,
           v1.age,
           v1.ra,
           v1.visit_number,
           v1.visit_name,
           v1.visit_date
    FROM arch_etl_db.crt_wra_visit_1_overview v1
    ORDER BY v1.visit_date, v1.screening_id DESC;

    UPDATE arch_etl_db.crt_wra_visit_1_locator_overview loc
        LEFT JOIN arch_etl_db.wra_forms_repeating_instruments wra_v1 ON loc.record_id = wra_v1.record_id
    SET loc.first_contact_number                 = wra_v1.loc_fc_num,
        loc.first_contact_number_owner           = IF(wra_v1.loc_pn_belongs = 8,
                                                      CONCAT_WS(', ', 'Other',
                                                                useStringCapFirst(useAutoTrimmer(wra_v1.loc_pn_belongs_oth))),
                                                      wra_v1.loc_pn_belongs_label),
        loc.first_contact_person_identification  = useStringCapFirst(useAutoTrimmer(wra_v1.loc_who_is_caller)),
        loc.second_contact_number                = wra_v1.loc_sc_num,
        loc.second_contact_number_owner          = IF(wra_v1.loc_pn_belongs_2 = 8,
                                                      CONCAT_WS(', ', 'Other',
                                                                useStringCapFirst(useAutoTrimmer(wra_v1.loc_pn_belongs_oth_2))),
                                                      wra_v1.loc_pn_belongs_2_label),
        loc.second_contact_person_identification = useStringCapFirst(useAutoTrimmer(wra_v1.loc_who_is_caller_2)),
        loc.third_contact_number                 = wra_v1.loc_tc_num,
        loc.third_contact_number_owner           = IF(wra_v1.loc_pn_belongs_3 = 8,
                                                      CONCAT_WS(', ', 'Other',
                                                                useStringCapFirst(useAutoTrimmer(wra_v1.loc_pn_belongs_oth_3))),
                                                      wra_v1.loc_pn_belongs_3_label),
        loc.third_contact_person_identification  = useStringCapFirst(useAutoTrimmer(wra_v1.loc_who_is_caller_3)),
        loc.fourth_contact_number                = wra_v1.loc_fthc_num,
        loc.fourth_contact_number_owner          = wra_v1.loc_pn_belongs_4_label
    WHERE wra_v1.wra_forms_repeating_instruments_id = loc.alternate_id;
    COMMIT;

    -- Process Metrics
    SET @vv_tx_pro_loc_v1 = (SELECT COUNT(loc_v1.record_id) FROM arch_etl_db.crt_wra_visit_1_locator_overview loc_v1);
    SET @v_load_metrics = CONCAT_WS(' of ', @vv_tx_pro_loc_v1, @v_tx_pre_loc_v1);
    SET @v_load_info = CONCAT('WRA-Locator-V1-Data: LOADING COMPLETE. ', @v_load_metrics);
    SELECT @v_load_info as `|_________________| Operation_Summary |_________________|`;

END $$

DELIMITER ;
