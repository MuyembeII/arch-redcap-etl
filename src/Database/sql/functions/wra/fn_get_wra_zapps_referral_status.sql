/**
 * Returns WRA ZAPPS referral status
 *
 * @author Gift Jr <muyembegift@gmail.com> | 22.10.23
 * @since 0.0.1
 * @alias Get WRA ZAPPS Referral Status.
 * @param varchar Record ID
 * @return Referral Status
 */
DROP FUNCTION IF EXISTS `get_WRA_ZAPPS_ReferralStatus`;
DELIMITER $$
CREATE FUNCTION get_WRA_ZAPPS_ReferralStatus(p_record_id MEDIUMINT)
    RETURNS VARCHAR(16)
    NOT DETERMINISTIC
BEGIN
    DECLARE v_status VARCHAR(16);
    -- Get pregnancy test result
    SELECT pec.upt_lborres
    INTO @v_upt_result
    FROM wra_point_of_collection pec
    WHERE pec.record_id = p_record_id AND pec.redcap_event_name = 'wra_baseline_arm_1';
    -- Retrieve referral likeliness
    SELECT pa.ref_likely_scorres
    INTO @v_referral_status
    FROM wra_pregnancy_assessments pa
    WHERE pa.record_id = p_record_id;

    -- UPT triggered ZAPPS referral
    IF @v_upt_result = 1 THEN
        IF @v_referral_status = 1 THEN
            SET v_status = 'Yes';
        ELSEIF @v_referral_status = 0 THEN
            SET v_status = 'Declined';
        ELSE
            SET v_status = 'Unknown';
        END IF;
    ELSE
        SET v_status = 'N/A';
    END IF;
    -- return the ZAPPS referral status
    RETURN v_status;
END $$

DELIMITER ;
