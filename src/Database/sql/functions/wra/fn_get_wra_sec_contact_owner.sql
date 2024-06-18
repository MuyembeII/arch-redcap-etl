/**
 * Returns WRA Locator Second Contact Owner
 *
 * @author Gift Jr <muyembegift@gmail.com> | 18.03.24
 * @since 0.0.1
 * @alias Get WRA Locator Second Phone Contact.
 * @param varchar WRA PTID
 * @return Phone Number
 */
DROP FUNCTION IF EXISTS `get_WRA_SecondContactOwner`;
DELIMITER $$
CREATE FUNCTION get_WRA_SecondContactOwner(p_wra_ptid VARCHAR(6))
    RETURNS VARCHAR(16)
    NOT DETERMINISTIC
BEGIN
    DECLARE v_owner VARCHAR(15);

    SELECT wfri.loc_pn_belongs_oth_2
    INTO @v_loc_owner_other
    FROM vw_wra_enrolled wl
             LEFT JOIN wra_forms_repeating_instruments wfri on wl.record_id = wfri.record_id
    WHERE wl.wra_ptid = p_wra_ptid
      AND wfri.loc_pn_belongs_oth_2 <> ''
    LIMIT 1;

    SELECT wfri.loc_pn_belongs_2_label as sec_contact_number_owner
    INTO @v_loc_owner
    FROM vw_wra_enrolled wl
             LEFT JOIN wra_forms_repeating_instruments wfri on wl.record_id = wfri.record_id
    WHERE wl.wra_ptid = p_wra_ptid
      AND wfri.loc_pn_belongs_2_label <> ''
    LIMIT 1;
    -- return the Owner
    RETURN @v_loc_owner;
END $$

DELIMITER ;
