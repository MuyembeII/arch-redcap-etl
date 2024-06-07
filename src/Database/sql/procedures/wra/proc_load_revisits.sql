DROP PROCEDURE IF EXISTS `Load_WRA_Revisit`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_Revisit(IN p_record_id INT)
BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                CONCAT_WS(' ', 'ERROR - Failed to load Revisit; RECORD_ID=', p_record_id, @errno, '(',
                          @sqlstate, '):', @text);
            SELECT @full_error;
            RESIGNAL;
        END;

    DROP TEMPORARY TABLE IF EXISTS wra_overview;
    CREATE TEMPORARY TABLE wra_overview
    (
        id             int,
        visit_id       int,
        availability   int,
        record_id      int,
        ra_name        VARCHAR(32) NOT NULL,
        cluster        VARCHAR(3),
        member_id      int         not null,
        last_attempt   int         not null,
        screening_id   varchar(14),
        screening_date date,
        return_date    date,
        days_due       int         not null
    );
    SET @v_status = 0;
    START TRANSACTION;
    -- Insert base data, fetch latest record by selecting max instance/visit number
    INSERT INTO wra_overview(visit_id, id, record_id, availability, ra_name, cluster, member_id, last_attempt,
                             screening_id, screening_date, return_date, days_due)
    SELECT ROW_NUMBER() OVER (
        PARTITION BY wra_enr.redcap_repeat_instrument
        ORDER BY wra_enr.redcap_repeat_instance DESC ) as visit_id,
           wra_enr.id,
           wra_enr.record_id,
           wra_enr.wra_enr_pp_avail,
           wra_enr.wra_enr_interviewer_obsloc          as ra_name,
           SUBSTR(wra_enr.hh_scrn_num_obsloc, 1, 3)    as cluster,
           wra_enr.hhe_hh_member_id                    as member_id,
           wra_enr.redcap_repeat_instance              as last_attempt,
           wra_enr.hh_scrn_num_obsloc                  as screening_id,
           wra_enr.scrn_obsstdat                       as screening_date,
           wra_enr.wra_enr_pdrv                        as return_date,
           DATEDIFF( CURRENT_DATE, wra_enr.wra_enr_pdrv)   as days_due
    FROM wra_enrollment wra_enr
    WHERE wra_enr.record_id = p_record_id
    LIMIT 1;

    SET @v_is_participant_available = (SELECT availability FROM wra_overview);
    SET @v_instance_id = (SELECT last_attempt FROM wra_overview);

    IF @v_is_participant_available = 2 AND @v_instance_id <> 3 THEN
        INSERT INTO crt_revisits(id, record_id, ra_name, cluster, member_id, last_attempt, screening_id,
                                 return_date, screening_date, days_due)
        SELECT o.id,
               o.record_id,
               o.ra_name,
               o.cluster,
               o.member_id,
               o.last_attempt,
               o.screening_id,
               o.screening_date,
               o.return_date,
               o.days_due
        FROM wra_overview o;
        SET @v_status = 1;
    ELSE
        SET @v_status = -1;
    END IF;
    COMMIT;

    -- Return status as result
    SELECT @v_status;

END $$

DELIMITER ;
