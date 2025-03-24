/*_________________________| M & L - Cluster Loading |______________________________*/
/**
 * Load WRA Contact Numbers.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 14.02.24
 * @since 0.0.1
 * @alias Load Contacts
 */
DROP PROCEDURE IF EXISTS `LoadContactNumbers`;
DELIMITER $$
CREATE PROCEDURE LoadContactNumbers()
BEGIN

    /*
       Properly raise errors that could be propagated throughout a
       call stack for convenient examination of exceptions.
    */
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
        BEGIN
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS(
                            CHAR(10 using UTF8),
                            'Failed to load contact details;',
                            @errno, '(', @sqlstate, '):', @text
                    );
            SELECT @full_error as Proc_Error_Details;
            RESIGNAL;
        END;

    START TRANSACTION;

    TRUNCATE crt_wra_contacts;
    -- Visit 1.0
    INSERT INTO crt_wra_contacts (record_id, wra_ptid, wra_first_contact_v1, wra_second_contact_v1,
                                  wra_first_contact_owner_v1, wra_second_contact_owner_v1)
    SELECT v1.record_id, v1.wra_ptid, v1.loc_fc_num, v1.loc_sc_num, v1.loc_pn_belongs_label, v1.loc_pn_belongs_2_label
    FROM wra_forms_repeating_instruments v1
    WHERE v1.wra_enr_pp_avail = 1
      AND v1.wra_age > 0;
    -- Visit 2.0
    UPDATE
        crt_wra_contacts wc
            LEFT JOIN wra_follow_up_visit_repeating_instruments v2 ON v2.record_id = wc.record_id
    SET wc.wra_first_contact_v2  = v2.loc_fu_fc_corr,
        wc.wra_second_contact_v2 = v2.loc_fu_fc_corr_2,
        wc.wra_first_contact_owner_v2 = v2.loc_fu_pn_belongs_label,
        wc.wra_second_contact_owner_v2 = v2.loc_fu_pn_belongs_2_label
    WHERE wc.record_id = v2.record_id;
    -- Visit 3.0
    UPDATE
        crt_wra_contacts wc
            LEFT JOIN wra_follow_up_visit_2_repeating_instruments v2 ON v2.record_id = wc.record_id
    SET wc.wra_first_contact_v3  = v2.loc_fu_fc_corr_f2,
        wc.wra_second_contact_v3 = v2.loc_fu_fc_corr_2_f2,
        wc.wra_first_contact_owner_v3 = v2.loc_fu_pn_belongs_f2_label,
        wc.wra_second_contact_owner_v3 = v2.loc_fu_pn_belongs_2_f2_label
    WHERE wc.record_id = v2.record_id;
    -- Visit 4.0
    UPDATE
        crt_wra_contacts wc
            LEFT JOIN wra_follow_up_visit_3_repeating_instruments v2 ON v2.record_id = wc.record_id
    SET wc.wra_first_contact_v4  = v2.loc_fu_fc_corr_f3,
        wc.wra_second_contact_v4 = v2.loc_fu_fc_corr_2_f3,
        wc.wra_first_contact_owner_v4 = v2.loc_fu_pn_belongs_f3_label,
        wc.wra_second_contact_owner_v4 = v2.loc_fu_pn_belongs_2_f3_label
    WHERE wc.record_id = v2.record_id;
    -- Visit 5.0
    UPDATE
        crt_wra_contacts wc
            LEFT JOIN wra_follow_up_visit_4_repeating_instruments v5 ON v5.record_id = wc.record_id
    SET wc.wra_first_contact_v5  = v5.loc_fu_fc_corr_f4,
        wc.wra_second_contact_v5 = v5.loc_fu_fc_corr_2_f4,
        wc.wra_first_contact_owner_v5 = v5.loc_fu_pn_belongs_f4_label,
        wc.wra_second_contact_owner_v5 = v5.loc_fu_pn_belongs_2_f4_label
    WHERE wc.record_id = v5.record_id;
    COMMIT;

END $$

DELIMITER ;
