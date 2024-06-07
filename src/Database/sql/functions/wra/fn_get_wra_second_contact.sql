/**
 * Returns WRA second contact number
 *
 * @author Gift Jr <muyembegift@gmail.com> | 04.04.24
 * @since 0.0.1
 * @alias Get WRA Second Contact Number.
 * @param varchar Record ID
 * @return Contact
 */
DROP FUNCTION IF EXISTS `get_WRA_SecondContactNumber`;
DELIMITER $$
CREATE FUNCTION get_WRA_SecondContactNumber(p_record_id MEDIUMINT)
    RETURNS BIGINT
    NOT DETERMINISTIC
BEGIN
    DECLARE v_contact_number BIGINT;
    -- Get second contact number
    SET v_contact_number = (SELECT COALESCE(fu_2_loc.loc_fu_num2_corr_f2, fu_loc.loc_fu_fc_corr_2, loc.loc_sc_num)
                            FROM wra_fu_locator fu_loc
                                     LEFT JOIN wra_locator loc ON fu_loc.record_id = loc.record_id
                                     LEFT JOIN wra_fu_2_locator fu_2_loc ON loc.record_id = fu_2_loc.record_id
                            WHERE fu_loc.record_id = p_record_id
                            UNION
                            SELECT COALESCE(fu_2_loc.loc_fu_num2_corr_f2, fu_loc.loc_fu_fc_corr_2, loc.loc_sc_num)
                            FROM wra_fu_locator fu_loc
                                     RIGHT JOIN wra_locator loc ON fu_loc.record_id = loc.record_id
                                     LEFT JOIN wra_fu_2_locator fu_2_loc ON loc.record_id = fu_2_loc.record_id
                            WHERE loc.record_id = p_record_id);

    -- return contact number
    RETURN v_contact_number;
END $$

DELIMITER ;
