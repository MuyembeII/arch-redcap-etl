/**
 * Returns WRA last recorded first contact number. Iterate over visit
 * encounters starting with the latest/newest visit.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 04.04.24
 * @since 0.0.1
 * @alias Get WRA First Contact Number.
 * @param VARCHAR Record ID
 * @return Contact
 */
DROP FUNCTION IF EXISTS `get_WRA_FirstContactNumber`;
DELIMITER $$
CREATE FUNCTION get_WRA_FirstContactNumber(p_record_id MEDIUMINT)
    RETURNS VARCHAR(11)
    NOT DETERMINISTIC
BEGIN
    DECLARE v_contact_number VARCHAR(11);
    -- Get first contact number
    SET v_contact_number = (SELECT s2.first_contact
                            FROM (SELECT s1.record_id,
                                         s1.visit_date,
                                         s1.first_contact,
                                         ROW_NUMBER() over (
                                             PARTITION BY s1.record_id ORDER BY s1.visit_date DESC) as visit_count
                                  FROM ((SELECT fu.record_id,
                                                v4.visit_date,
                                                COALESCE(fu.wra_fu_curr_fcontact_f3, fu.loc_fu_fc_corr_f3) as first_contact
                                         FROM vw_wra_fu_3_visit v4
                                                  LEFT JOIN wra_follow_up_visit_3_repeating_instruments fu ON v4.id = fu.root_id
                                         WHERE v4.record_id = p_record_id)
                                        -- Visit Number: 4.0
                                        UNION
                                        (SELECT fu.record_id,
                                                v3.visit_date,
                                                COALESCE(
                                                        fu.loc_fu_fc_corr_f2,
                                                        TRIM(TRAILING ')' FROM TRIM('___' FROM fu.wra_fu_curr_fcontact)) -- contact number sanitizer
                                                    ) as first_contact
                                         FROM vw_wra_fu_2_visit v3
                                                  LEFT JOIN wra_follow_up_visit_2_repeating_instruments fu ON v3.id = fu.root_id
                                         WHERE v3.record_id = p_record_id)
                                        -- Visit Number: 3.0
                                        UNION
                                        (SELECT fu.record_id,
                                                v1.visit_date,
                                                COALESCE(fu_1.loc_fc_num, fu.loc_fu_fc_corr) as first_contact
                                         FROM vw_wra_fu_1_visit v1
                                                  LEFT JOIN wra_follow_up_visit_repeating_instruments fu ON v1.id = fu.root_id
                                                  LEFT JOIN wra_forms_repeating_instruments fu_1 ON v1.record_id = fu_1.record_id
                                         WHERE fu_1.wra_enr_pp_avail = 1
                                           AND v1.record_id = p_record_id)) s1 -- Visit Number: 1.0 & 2.0
                                  ORDER BY s1.visit_date DESC) s2
                            WHERE s2.visit_count = 1);

    -- return contact number
    RETURN v_contact_number;
END $$

DELIMITER ;
