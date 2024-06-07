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

    SELECT wl.loc_pn_belongs_oth_2
    INTO @v_loc_owner_other
    FROM wra_locator wl
    WHERE wl.wra_ptid = p_wra_ptid;

    SELECT
    CASE wl.loc_pn_belongs_2
        WHEN 1 THEN 'Self'
        WHEN 2 THEN 'Spouse/Partner'
        WHEN 3 THEN 'Sibling'
        WHEN 4 THEN 'Aunt/Uncle'
        WHEN 5 THEN 'Parent'
        WHEN 6 THEN 'Child'
        WHEN 7 THEN 'Friend/Neighbor'
        WHEN 8 THEN CONCAT_WS('-', 'Other', @v_loc_owner_other_2)
        ELSE ''
        end sec_contact_number_owner
    INTO @v_loc_owner
    FROM wra_locator wl
    WHERE wl.wra_ptid = p_wra_ptid;
    -- return the Owner
    RETURN @v_loc_owner;
END $$

DELIMITER ;
