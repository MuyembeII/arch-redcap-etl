/**
 * Returns WRA FAMLI enrollment status
 *
 * @author Gift Jr <muyembegift@gmail.com> | 22.10.23
 * @since 0.0.1
 * @alias Get WRA FAMLI Enrollment Status.
 * @param varchar WRA PTID
 * @return FAMLI Enrollment Status
 */
DROP FUNCTION IF EXISTS `get_WRA_FAMLI_EnrollmentStatus`;
DELIMITER $$
CREATE FUNCTION get_WRA_FAMLI_EnrollmentStatus(p_wra_ptid VARCHAR(6))
    RETURNS VARCHAR(3)
    NOT DETERMINISTIC
BEGIN
    DECLARE v_status VARCHAR(3);

    SELECT wl.famliid_yn
    INTO @v_enrollment_status
    FROM wra_locator wl
    WHERE wl.wra_ptid = p_wra_ptid;

    IF @v_enrollment_status = 1 THEN
        SET v_status = 'Yes';
    ELSE
        SET v_status = 'No';
    END IF;
    -- return the FAMLI enrollment status
    RETURN v_status;
END $$

DELIMITER ;
