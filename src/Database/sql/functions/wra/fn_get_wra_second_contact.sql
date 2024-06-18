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
    RETURNS VARCHAR(11)
    NOT DETERMINISTIC
BEGIN
    DECLARE v_contact_number VARCHAR(11);
    -- Get second contact number
    SET v_contact_number = (SELECT s2.second_contact
                            FROM (SELECT s1.record_id,
                                         s1.visit_date,
                                         s1.second_contact,
                                         ROW_NUMBER() over (
                                             PARTITION BY s1.record_id ORDER BY s1.visit_date DESC) as visit_count
                                  FROM ((
                                            -- Visit Number: 4.0
                                            SELECT fu.record_id,
                                                   v4.visit_date,
                                                   -- pick the first non null contact field from the
                                                   -- WRA Locator Update form starting with last descended field ;|
                                                   COALESCE(
                                                           fu.loc_fu_fc_corr_2_f3,
                                                           TRIM(TRAILING ')' FROM TRIM('___' FROM fu.wra_fu_curr_scontact_f3)) -- top chef :(
                                                       ) as second_contact
                                            FROM vw_wra_fu_3_visit v4
                                                     LEFT JOIN wra_follow_up_visit_3_repeating_instruments fu ON v4.id = fu.root_id
                                            WHERE v4.record_id = p_record_id)
                                        UNION
                                        (
                                            -- Visit Number: 3.0
                                            SELECT fu.record_id,
                                                   v3.visit_date,
                                                   COALESCE(
                                                           fu.loc_fu_fc_corr_2_f2,
                                                           TRIM(LEADING ')' FROM
                                                                TRIM(TRAILING ')' FROM TRIM('___' FROM fu.wra_fu_curr_scontact))) -- contact number sanitizer
                                                       ) as second_contact
                                            FROM vw_wra_fu_2_visit v3
                                                     LEFT JOIN wra_follow_up_visit_2_repeating_instruments fu ON v3.id = fu.root_id
                                            WHERE v3.record_id = p_record_id)
                                        UNION
                                        (
                                            -- Visit Number: 1.0 & 2.0
                                            SELECT fu.record_id,
                                                   v1.visit_date,
                                                   COALESCE(fu.loc_fu_fc_corr_2, fu_1.loc_fc_num) as second_contact
                                            FROM vw_wra_fu_1_visit v1
                                                     LEFT JOIN wra_follow_up_visit_repeating_instruments fu ON v1.id = fu.root_id
                                                     LEFT JOIN wra_forms_repeating_instruments fu_1 ON v1.record_id = fu_1.record_id
                                            WHERE fu_1.wra_enr_pp_avail = 1
                                              AND v1.record_id = p_record_id)) s1
                                  ORDER BY s1.visit_date DESC) s2
                            WHERE s2.visit_count = 1);

    -- return contact number
    RETURN v_contact_number;
END $$

DELIMITER ;
