/**
 * Returns WRA FAMLI participant ID
 *
 * @author Gift Jr <muyembegift@gmail.com> | 22.10.23
 * @since 0.0.1
 * @alias Get WRA FAMLI PTID.
 * @param varchar WRA PTID
 * @return FAMLI PTID
 */
DROP FUNCTION IF EXISTS `get_WRA_FAMLI_PTID`;
DELIMITER $$
CREATE FUNCTION get_WRA_FAMLI_PTID(p_wra_ptid VARCHAR(6))
    RETURNS VARCHAR(15)
    NOT DETERMINISTIC
BEGIN
    DECLARE v_wra_famli_ptid VARCHAR(15);

    SELECT wl.famli_id_scorres
    INTO v_wra_famli_ptid
    FROM wra_locator wl
    WHERE wl.wra_ptid = p_wra_ptid;
    -- return the FAMLI PTID
    RETURN v_wra_famli_ptid;
END $$

DELIMITER ;
