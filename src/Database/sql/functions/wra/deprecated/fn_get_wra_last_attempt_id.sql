/**
 * Returns WRA latest attempt identifier since this instrument is defined as
 * a repeating instrument in REDCap.
 *
 *
 * @author Gift Jr <muyembegift@gmail.com> | 26.10.23
 * @since 0.0.1
 * @alias Get WRA last visit ID.
 * @param varchar Record ID
 * @return Last Attempt ID
 */
DROP FUNCTION IF EXISTS `get_WRA_LastVisitAttemptId`;
DELIMITER $$
CREATE FUNCTION get_WRA_LastVisitAttemptId(p_record_id MEDIUMINT)
    RETURNS TINYINT
    NOT DETERMINISTIC
BEGIN
    DECLARE v_visit_id INT;
    SET v_visit_id =
        (SELECT MAX(we.redcap_repeat_instance) FROM wra_enrollment we WHERE we.record_id = p_record_id);
    -- return the screening status
    RETURN @v_visit_status;
END $$
DELIMITER ;
