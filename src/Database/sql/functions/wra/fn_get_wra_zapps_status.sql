/**
 * Returns WRA ZAPPS enrollment status
 *
 * @author Gift Jr <muyembegift@gmail.com> | 22.10.23
 * @since 0.0.1
 * @alias Get WRA ZAPPS Enrollment Status.
 * @param varchar WRA PTID
 * @return Enrollment Status
 */
DROP FUNCTION IF EXISTS `get_WRA_ZAPPS_EnrollmentStatus`;
DELIMITER $$
CREATE FUNCTION get_WRA_ZAPPS_EnrollmentStatus(p_wra_ptid VARCHAR(6))
    RETURNS VARCHAR(3)
    NOT DETERMINISTIC
BEGIN

    DECLARE v_status VARCHAR(3);

    SELECT wl.loc_enrolled_zapps
    INTO @v_enrollment_status
    FROM wra_locator wl
    WHERE wl.wra_ptid = p_wra_ptid;

    /*----------------------------------------------------------------------------------------------------------------*/
    IF @v_enrollment_status = 1 THEN
        SET v_status = 'Yes';
    ELSE
        SET v_status = 'No';
    END IF;

    -- return the ZAPPS enrollment status
    RETURN v_status;

END $$

DELIMITER ;
