/**
 * Returns WRA Pregnancy status
 *
 * @author Gift Jr <muyembegift@gmail.com> | 22.10.23
 * @since 0.0.1
 * @alias Get WRA Pregnancy Status.
 * @param varchar Record ID
 * @return Pregnancy Status
 */
DROP FUNCTION IF EXISTS `get_WRA_PregnancyStatus`;
DELIMITER $$
CREATE FUNCTION get_WRA_PregnancyStatus(p_record_id MEDIUMINT)
    RETURNS VARCHAR(16)
    NOT DETERMINISTIC
BEGIN
    DECLARE v_status VARCHAR(16);

    -- Retrieve surveillance pregnancy status
    SELECT pos.lmp_kd_scorres
    INTO @v_pos_pregnancy_status
    FROM wra_preg_overview_surveillance pos
    WHERE pos.record_id = p_record_id;

    -- Retrieve surveillance pregnancy status
    SELECT pos.preg_scorres
    INTO @v_pos_preg_scorres
    FROM wra_preg_overview_surveillance pos
    WHERE pos.record_id = p_record_id;

    -- Get pregnancy test result
    SELECT pec.upt_lborres
    INTO @v_upt_result
    FROM wra_point_of_collection pec
    WHERE pec.record_id = p_record_id
    ORDER BY pec.poc_visit_date LIMIT 1;

    -- UPT triggered ZAPPS referral
    IF @v_upt_result = 1 OR @v_pos_pregnancy_status = 6 OR @v_pos_preg_scorres = 1 THEN
        SET v_status = 'Yes';
    ELSEIF (@v_pos_pregnancy_status = 6 OR @v_pos_preg_scorres = 1) AND @v_upt_result = 0 THEN
        SET v_status = 'Undetermined';
    ELSE
        SET v_status = 'No';
    END IF;
    -- return the pregnancy status
    RETURN v_status;
END $$

DELIMITER ;
