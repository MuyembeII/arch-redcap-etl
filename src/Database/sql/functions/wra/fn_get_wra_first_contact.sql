/**
 * Returns WRA first contact number
 *
 * @author Gift Jr <muyembegift@gmail.com> | 04.04.24
 * @since 0.0.1
 * @alias Get WRA First Contact Number.
 * @param varchar Record ID
 * @return Contact
 */
DROP PROCEDURE IF EXISTS `get_WRA_FirstContactNumber`;
DELIMITER $$
CREATE PROCEDURE get_WRA_FirstContactNumber(IN p_record_id INT)
BEGIN
    DECLARE v_contact_number BIGINT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS(' ', 'ERROR - Failed to get WRA First Contact; ENR_ID=', p_record_id, '|', @errno, '(', @sqlstate,
                              '):', @text);
            SELECT @full_error;
        END;

    DROP TEMPORARY TABLE IF EXISTS wra_contact_overview;
    CREATE TEMPORARY TABLE wra_contact_overview
    (
        record_id       MEDIUMINT NOT NULL,
        visit_1_contact VARCHAR(11),
        visit_2_contact VARCHAR(11),
        visit_3_contact VARCHAR(11),
        visit_4_contact VARCHAR(11),
        visit_5_contact VARCHAR(11)
    );

    -- Get first contact number
    INSERT INTO wra_contact_overview(record_id, visit_3_contact)
    SELECT fu_2_loc.record_id, fu_2_loc.loc_fu_fc_corr_f2 as visit_3_contact
    FROM wra_follow_up_visit_2_repeating_instruments fu_2_loc
    WHERE fu_2_loc.record_id = p_record_id
      AND fu_2_loc.redcap_repeat_instance = (SELECT MAX(w.redcap_repeat_instance) as instance_id
                                             FROM wra_follow_up_visit_2_repeating_instruments w
                                             WHERE w.record_id = p_record_id);

    UPDATE wra_contact_overview co
        LEFT JOIN wra_follow_up_visit_repeating_instruments w ON w.record_id = co.record_id
    SET co.visit_2_contact = w.loc_fu_fc_corr
    WHERE co.record_id = p_record_id
      AND w.redcap_repeat_instance = (SELECT MAX(w.redcap_repeat_instance) as instance_id
                                      FROM wra_follow_up_visit_repeating_instruments w
                                      WHERE w.record_id = p_record_id);
    SELECT *
    FROM wra_contact_overview;
    UPDATE wra_contact_overview co
        LEFT JOIN wra_forms_repeating_instruments w ON w.record_id = co.record_id
    SET co.visit_1_contact = w.loc_fc_num
    WHERE co.record_id = p_record_id
      AND w.redcap_repeat_instance = (SELECT MAX(w.redcap_repeat_instance) as instance_id
                                      FROM wra_forms_repeating_instruments w
                                      WHERE w.record_id = p_record_id);

    SET v_contact_number =
            (SELECT COALESCE(co.visit_3_contact, co.visit_2_contact, co.visit_1_contact) as first_contact_number
             FROM wra_contact_overview co);

    -- Return status as result
    SELECT v_contact_number;
END $$

DELIMITER ;
