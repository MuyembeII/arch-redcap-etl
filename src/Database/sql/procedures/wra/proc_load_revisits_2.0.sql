DROP PROCEDURE IF EXISTS `Load_WRA_Revisit_2`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_Revisit_2(IN p_record_id INT)
BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                CONCAT_WS(' ', 'ERROR - Failed to load 2.0 Revisit; RECORD_ID=', p_record_id, @errno, '(',
                          @sqlstate, '):', @text);
            SELECT @full_error as ErrorLog;
            RESIGNAL;
        END;

    DROP TEMPORARY TABLE IF EXISTS wra_overview;
    CREATE TEMPORARY TABLE wra_overview
    (
        visit_id       int,
        availability   int,
        record_id      int,
        ra_name        VARCHAR(32) NOT NULL,
        member_id      int,
        last_attempt   int         not null,
        screening_id   varchar(14),
        screening_date date,
        return_date    date,
        return_time    varchar(16),
        days_due       int         not null
    );
    SET @v_status = 0;
    START TRANSACTION;
    -- Insert base data, fetch latest record by selecting max instance/visit number
    INSERT INTO wra_overview(visit_id, record_id, availability, ra_name, member_id, last_attempt,
                             screening_date, return_date, return_time, days_due)
    SELECT ROW_NUMBER() OVER (
        PARTITION BY wf.redcap_repeat_instrument
        ORDER BY wf.redcap_repeat_instance DESC ) as visit_id,
           wf.record_id,
           wf.wra_fu_pp_avail,
           wf.wra_fu_interviewer_obsloc           as ra_name,
           wf.fu_hhe_hh_member_id                 as member_id,
           wf.redcap_repeat_instance              as last_attempt,
           wf.wra_fu_visit_date                   as screening_date,
           wf.wra_fu_pdrv                         as return_date,
           CASE
               WHEN wf.wra_fu_ptrv = 1 THEN 'None'
               WHEN wf.wra_fu_ptrv = 2 THEN 'Morning'
               WHEN wf.wra_fu_ptrv = 3 THEN 'Midday'
               WHEN wf.wra_fu_ptrv = 4 THEN 'Afternoon'
               ELSE 'Unknown'
               END                                AS return_time,
           DATEDIFF(wf.wra_fu_pdrv, CURRENT_DATE) as days_due
    FROM wra_follow_up_visit_1 wf
    WHERE wf.record_id = p_record_id
      AND wf.wra_fu_pp_avail = 2
    LIMIT 1;

    SET @v_is_participant_available = (SELECT availability FROM wra_overview);
    SET @v_instance_id = (SELECT last_attempt FROM wra_overview);
    SET @v_screening_id = (SELECT hh_scrn_num_obsloc
                           FROM wra_enrollment
                           WHERE record_id = p_record_id
                           ORDER BY scrn_obsstdat DESC
                           LIMIT 1);
    SET @v_wra_ptid =
        (SELECT wra_ptid FROM wra_enrollment WHERE record_id = p_record_id ORDER BY scrn_obsstdat DESC LIMIT 1);
    SET @v_member_id =
        (SELECT hhe_hh_member_id FROM wra_enrollment WHERE record_id = p_record_id ORDER BY scrn_obsstdat DESC LIMIT 1);
    SET @v_age = (SELECT wra_age FROM wra_enrollment WHERE record_id = p_record_id ORDER BY scrn_obsstdat DESC LIMIT 1);
    -- remove double whitespaces for WRAs without maiden names
    SET @v_wra = (SELECT REPLACE(CONCAT_WS(' ', fname_scorres, mname_scorres, lname_scorres), '  ', '')
                  FROM wra_enrollment
                  WHERE record_id = p_record_id
                  ORDER BY scrn_obsstdat DESC
                  LIMIT 1);

    IF @v_is_participant_available = 2 AND @v_instance_id <> 3 THEN
        INSERT INTO crt_revisits_2(id, record_id, screening_id, wra_ptid, member_id, interviewer, wra, age,
                                   last_attempt, last_attempt_date, return_date, return_time, days_due)
        SELECT o.visit_id       as id,
               o.record_id,
               @v_screening_id  as screening_id,
               @v_wra_ptid      as wra_ptid,
               @v_member_id     as member_id,
               o.ra_name        as interviewer,
               @v_wra           as wra,
               @v_age           as age,
               o.last_attempt,
               o.screening_date as last_attempt_date,
               o.return_date,
               o.return_time,
               o.days_due
        FROM wra_overview o;
        SET @v_status = 1;
    ELSE
        SET @v_status = -1;
    END IF;
    COMMIT;

    -- Return status as result
    SELECT @v_status as OperationStatus;

END $$

DELIMITER ;
