/**
 * Returns WRA Visit status
 *
 * @author Gift Jr <muyembegift@gmail.com> | 22.10.23
 * @since 0.0.1
 * @alias Get WRA visit status.
 * @param varchar Record ID
 * @return Visit Status
 */
DROP FUNCTION IF EXISTS `get_WRA_VisitStatus`;
DELIMITER $$
CREATE FUNCTION get_WRA_VisitStatus(p_record_id int)
    RETURNS VARCHAR(32)
    NOT DETERMINISTIC
BEGIN

    DECLARE v_visit_id INT;
    DECLARE v_is_wra_enrolled BIT;
    DECLARE v_is_forms_completed BIT;
    DECLARE v_wra_forms_complete BIT;
    DECLARE v_wra_mental_health_assessment_complete BIT;
    DECLARE v_wra_pregnancy_overview_and_surveillance_complete BIT;
    DECLARE v_wra_physical_exam_and_collection_complete SMALLINT;
    DECLARE v_wra_pregnancy_assessments_complete BIT;
    DECLARE v_pa_visit_date DATE;

    SELECT ROW_NUMBER() OVER (
        PARTITION BY wra_enr.redcap_repeat_instrument
        ORDER BY wra_enr.redcap_repeat_instance DESC ) as visit_id,
           wra_enr.is_wra_enrolled,
           wra_enr.is_forms_completed,
           wra_enr.wra_forms_complete
    INTO v_visit_id, v_is_wra_enrolled, v_is_forms_completed, v_wra_forms_complete
    FROM wra_enrollment wra_enr
    WHERE wra_enr.record_id = p_record_id
    LIMIT 1;

    SELECT mha.wra_mental_health_assessment_complete
    INTO v_wra_mental_health_assessment_complete
    FROM wra_mental_health_assessment mha
    WHERE mha.record_id = p_record_id;

    SELECT pos.wra_pregnancy_overview_and_surveillance_complete
    INTO v_wra_pregnancy_overview_and_surveillance_complete
    FROM wra_preg_overview_surveillance pos
    WHERE pos.record_id = p_record_id;

    SELECT pec.wra_physical_exam_and_collection_complete
    INTO v_wra_physical_exam_and_collection_complete
    FROM wra_point_of_collection pec
    WHERE pec.record_id = p_record_id AND pec.redcap_event_name = 'wra_baseline_arm_1';

    SELECT pa.pa_visit_date
    INTO v_pa_visit_date
    FROM wra_pregnancy_assessments pa
    WHERE pa.record_id = p_record_id;

    SELECT pa.wra_pregnancy_assessments_complete
    INTO v_wra_pregnancy_assessments_complete
    FROM wra_pregnancy_assessments pa
    WHERE pa.record_id = p_record_id;

    /*----------------------------------------------------------------------------------------------------------------*/
    SET @v_visit_status = 'Incomplete';
    IF v_is_forms_completed = 1 AND v_is_wra_enrolled = 1 AND v_wra_forms_complete = 1 THEN
        SET @v_visit_status = 'Complete';
    ELSEIF v_wra_mental_health_assessment_complete <> 2 THEN
        SET @v_visit_status = 'Incomplete';
    ELSEIF v_wra_pregnancy_overview_and_surveillance_complete <> 2 THEN
        SET @v_visit_status = 'Incomplete';
    ELSEIF v_wra_physical_exam_and_collection_complete <> 2 THEN
        SET @v_visit_status = 'Incomplete';
    ELSEIF v_pa_visit_date <> '' OR v_pa_visit_date IS NOT NULL THEN
        IF v_wra_pregnancy_assessments_complete <> 2 THEN
            SET @v_visit_status = 'Incomplete';
        END IF;
    ELSE
        SET @v_visit_status = 'Complete';
    END IF;

    -- return the screening status
    RETURN @v_visit_status;

END $$

DELIMITER ;
