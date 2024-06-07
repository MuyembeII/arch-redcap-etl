/**
 * Returns WRA ZAPPS participant ID
 *
 * @author Gift Jr <muyembegift@gmail.com> | 22.10.23
 * @since 0.0.1
 * @alias Get WRA ZAPPS PTID.
 * @param varchar WRA PTID
 * @return ZAPPS PTID
 */
DROP FUNCTION IF EXISTS `get_WRA_ZAPPS_PTID`;
DELIMITER $$
CREATE FUNCTION get_WRA_ZAPPS_PTID(p_wra_ptid VARCHAR(6))
    RETURNS VARCHAR(11)
    NOT DETERMINISTIC
BEGIN

    DECLARE v_wra_zapps_ptid VARCHAR(3);

    SELECT wl.loc_zapps_ptid
    INTO v_wra_zapps_ptid
    FROM wra_locator wl
    WHERE wl.wra_ptid = p_wra_ptid;

    -- return the ZAPPS PTID
    RETURN v_wra_zapps_ptid;

END $$

DELIMITER ;
