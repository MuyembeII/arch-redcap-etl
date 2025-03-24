DROP PROCEDURE IF EXISTS `Load_WRA_Data`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_Data(IN p_screening_id VARCHAR(14), IN p_member_id INT, IN p_id INT)
BEGIN

    DECLARE v_enrolled_in_zapps VARCHAR(16) DEFAULT 'No';
    DECLARE v_zapps_ptid VARCHAR(11);
    DECLARE v_enrolled_in_famli VARCHAR(16) DEFAULT 'No';
    DECLARE v_famli_ptid VARCHAR(12);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                CONCAT_WS(' ', 'ERROR - Failed to load WRA Interaction; ENR_ID=', p_id, '|', @errno, '(', @sqlstate,
                          '):', @text);
            SELECT @full_error;
            RESIGNAL;
        END;

    -- WRA Record Overview. TODO: change this to leverage SQL Views to reduce boilerplate
    DROP TEMPORARY TABLE IF EXISTS wra_overview;
    CREATE TEMPORARY TABLE wra_overview
    (
        id                INT AUTO_INCREMENT PRIMARY KEY,
        visit_id          MEDIUMINT NOT NULL,
        record_id         MEDIUMINT NOT NULL,
        wra_enrollment_id BIGINT,
        wra_ptid          VARCHAR(6),
        member_id         SMALLINT,
        visit_count       TINYINT,
        instance_id       SMALLINT,
        screening_id      VARCHAR(14),
        screening_date    DATE,
        ra                VARCHAR(32),
        first_name        VARCHAR(32),
        middle_name       VARCHAR(32),
        last_name         VARCHAR(32),
        age               SMALLINT,
        enrollment_status VARCHAR(32),
        enrolled_by       VARCHAR(32),
        CONSTRAINT uc_record_id_wra_ptid UNIQUE (record_id, wra_ptid)
    );

    START TRANSACTION;
    -- Insert base data, fetch latest record by selecting max instance/visit number
    INSERT INTO wra_overview(visit_id, record_id, wra_enrollment_id, wra_ptid, member_id, visit_count, instance_id,
                             screening_id, screening_date, ra, first_name, middle_name, last_name, age,
                             enrollment_status, enrolled_by)
    SELECT ROW_NUMBER() OVER (
        PARTITION BY wra_enr.redcap_repeat_instrument
        ORDER BY wra_enr.redcap_repeat_instance DESC ) as visit_id,
           wra_enr.record_id,
           wra_enr.wra_enrollment_id,
           wra_enr.wra_ptid,
           wra_enr.hhe_hh_member_id                    as member_id,
           wra_enr.wra_enr_visit_count                 as visit_count,
           wra_enr.redcap_repeat_instance              as instance_id,
           wra_enr.hh_scrn_num_obsloc                  as screening_id,
           wra_enr.scrn_obsstdat                       as screening_date,
           wra_enr.wra_ra_name                         as ra,
           wra_enr.fname_scorres                       as first_name,
           wra_enr.mname_scorres                       as middle_name,
           wra_enr.lname_scorres                       as last_name,
           wra_enr.wra_age                             as age,
           'Pending'                                   as enrollment_status,
           wra_enr.wra_enr_interviewer_obsloc          as enrolled_by
    FROM wra_enrollment wra_enr
    WHERE wra_enr.id = p_id
    LIMIT 1;

    -- Load case identifiers
    SET @v_case_id = (SELECT wra_enrollment_id FROM wra_overview); -- non unique, TODO: change identifier
    SET @v_wra_ptid = (SELECT wra_ptid FROM wra_overview);
    SET @v_record_id = (SELECT record_id FROM wra_overview);

    -- Load case & visit status
    SET @v_case_status = get_WRA_EnrollmentStatus(@v_case_id, p_id);
    SET @v_visit_status = get_WRA_VisitStatus(@v_record_id);
    -- Retrieve follow-up visit date
    SET @v_screening_date = (SELECT screening_date FROM wra_overview);
    SET @v_next_fu_visit_date = DATE_ADD(@v_screening_date, INTERVAL 90 DAY);
    -- Get ZAPPS PTID, enrollment & referral status
    SET @v_referred_to_zapps = get_WRA_ZAPPS_ReferralStatus(@v_record_id);
    SET v_enrolled_in_zapps = get_WRA_ZAPPS_EnrollmentStatus(@v_wra_ptid);
    IF v_enrolled_in_zapps = 'Yes' THEN
        SET v_zapps_ptid = get_WRA_ZAPPS_PTID(@v_wra_ptid);
    END IF;
    -- Get FAMLI enrollment status and PTID
    SET v_enrolled_in_famli = get_WRA_FAMLI_EnrollmentStatus(@v_wra_ptid);
    IF v_enrolled_in_zapps = 'Yes' THEN
        SET v_famli_ptid = get_WRA_FAMLI_PTID(@v_wra_ptid);
    END IF;
    -- Get WRA pregnancy status
    SET @v_pregnancy_status = get_WRA_PregnancyStatus(@v_record_id);

    -- Populate instrumentation for WRA Baseline
    INSERT INTO crt_enrollments(id, wra_enrollment_id, household_member_id, wra_ptid, screening_id, date_of_enrollment,
                                ra_name, enrolled_by, first_name, middle_name, last_name, sex, age, case_status,
                                case_next_visit_date, enrolled_in_zapps, referred_to_zapps, zapps_ptid,
                                enrolled_in_famli, famli_ptid, is_currently_pregnant, visit_status)
    SELECT p_id                  as id,
           wo.wra_enrollment_id,
           wo.member_id          as household_member_id,
           wo.wra_ptid,
           wo.screening_id,
           wo.screening_date     as date_of_enrollment,
           wo.ra                 as ra_name,
           wo.enrolled_by,
           wo.first_name,
           wo.middle_name,
           wo.last_name,
           'Female',
           wo.age,
           @v_case_status        as case_status,
           @v_next_fu_visit_date as case_next_visit_date,
           v_enrolled_in_zapps   as enrolled_in_zapps,
           @v_referred_to_zapps  as referred_to_zapps,
           v_zapps_ptid          as zapps_ptid,
           v_enrolled_in_famli   as enrolled_in_famli,
           v_famli_ptid          as famli_ptid,
           @v_pregnancy_status   as is_currently_pregnant,
           @v_visit_status       as visit_status
    FROM wra_overview wo;
    COMMIT;

    -- Return status as result
    SELECT @v_case_status;

END $$

DELIMITER ;
