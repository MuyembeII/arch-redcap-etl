DROP PROCEDURE IF EXISTS `Resolve_WRA_MemberId`;
DELIMITER $$

CREATE PROCEDURE Resolve_WRA_MemberId(IN p_id int)
BEGIN

    DECLARE v_record_id MEDIUMINT;
    DECLARE v_screening_id MEDIUMINT;
    DECLARE v_instance_id TINYINT;
    DECLARE v_current_member_id INT2;
    DECLARE v_wra_first_name MEDIUMINT;
    DECLARE v_wra_last_name MEDIUMINT;
    DECLARE v_wra_age TINYINT;

    -- Readable stack trace exception handler
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
        BEGIN
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                CONCAT_WS(' ', 'ERROR - Failed to resolve HH-WRA Member IDs; REC_INT_ID=', v_record_id, @errno, '(',
                          @sqlstate,
                          '):', @text);
            SELECT @full_error;
            RESIGNAL;
        END;

    START TRANSACTION;
    -- WRA latest attempt instance age, first and last name.
    SET v_record_id = (SELECT w.record_id FROM wra_enrollment w WHERE w.id = p_id);
    SET @v_last_attempt_id = get_WRA_LastVisitAttemptId(v_record_id);
    SELECT wla.hh_scrn_num_obsloc,
           wla.hhe_hh_member_id,
           wla.redcap_repeat_instance,
           wla.fname_scorres,
           wla.lname_scorres,
           wla.wra_age
    INTO v_screening_id, v_current_member_id, v_instance_id,v_wra_first_name, v_wra_last_name, v_wra_age
    FROM wra_enrollment wla
    WHERE wla.record_id = v_record_id AND wla.redcap_repeat_instance = @v_last_attempt_id;

    /*
     Let's update the WRA Enrollment table based on their Screening and Member ID specified in the HH Enumeration.
     We'll use a left join since the foreign key is not defined in the WRA Enrollment entity. That means you can not
     use th
     e inner join here.
     */
    UPDATE wra_enrollment we
        LEFT JOIN (SELECT hhe.hhe_id,
                          hhe.hh_scrn_num_obsloc,
                          hhe.hhe_hh_member_id,
                          hhe.fname_scorres,
                          hhe.lname_scorres,
                          hhe.age_scorres
                   FROM hh_enumeration hhe
                   ORDER BY hhe.hhe_interview_date) he ON we.hh_scrn_num_obsloc = he.hh_scrn_num_obsloc
    SET we.hhe_hh_member_id = he.hhe_hh_member_id
    WHERE we.id = p_id
      AND (he.fname_scorres LIKE CONCAT(v_wra_first_name, '%')
        AND he.lname_scorres LIKE CONCAT(v_wra_last_name, '%'))
      AND he.age_scorres = v_wra_age
      AND he.hhe_hh_member_id <> v_current_member_id;

    -- Update enrollment ID
    SET @v_wra_member_id = (SELECT e.hhe_hh_member_id
                            FROM wra_enrollment e
                            WHERE e.id = p_id
                              AND e.record_id = v_record_id
                              AND e.redcap_repeat_instance = v_instance_id);
    SET @v_wra_enrollment_id = CONCAT(REPLACE(v_screening_id, '-', ''), v_instance_id, @v_wra_member_id);
    UPDATE wra_enrollment we
    SET we.wra_enrollment_id = @v_wra_enrollment_id
    WHERE we.id = p_id;
    COMMIT;
    -- flag completion
    SELECT 1 as `status`;

END $$

DELIMITER ;
