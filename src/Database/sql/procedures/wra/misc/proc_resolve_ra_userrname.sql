/**
 * Attempts to resolve mismatching REDCap RA usernames to enable the tracking of daily accrual aggregates.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 29.10.23
 * @since 0.0.1
 * @alias Resolve RA Username
 * @param BIGINT p_id - WBE Primary ID Key
 */
DROP PROCEDURE IF EXISTS `Resolve_RA_Username`;
DELIMITER $$
CREATE PROCEDURE Resolve_RA_Username(IN p_id BIGINT)
BEGIN

    DECLARE v_new_wra_ra_name VARCHAR(32); -- Resolved RA Name
    DECLARE v_record_id MEDIUMINT;
    DECLARE v_screening_id MEDIUMINT;
    DECLARE v_wra_ra_name VARCHAR(32);
    DECLARE v_wra_interviewer TINYINT;
    DECLARE v_resolution_outcome VARCHAR(32);

    -- REDCap usernames associated with anomalies
    DECLARE v_pkantumoya_redcap_username VARCHAR(10) DEFAULT 'pkantumoya';
    DECLARE v_gmuyembe_redcap_username VARCHAR(8) DEFAULT 'gmuyembe';

    -- Readable stack trace exception handler
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
        BEGIN
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                CONCAT_WS(' ', 'ERROR - Failed to resolve RA Username; REC_INT_ID=', v_record_id, @errno, '(',
                          @sqlstate,
                          '):', @text);
            SELECT @full_error;
            RESIGNAL;
        END;

    START TRANSACTION;
    -- WRA latest attempt instance screening ID and RA name/username.
    SET v_record_id = (SELECT w.record_id FROM wra_enrollment w WHERE w.id = p_id);
    SET @v_last_attempt_id = get_WRA_LastVisitAttemptId(v_record_id);
    SELECT wla.hh_scrn_num_obsloc         as v_screening_id,
           COALESCE(wla.wra_ra_name,
                    wla.wra_enr_nok_ra_name,
                    wla.wra_enr_nok_lts_ra_name,
                    wla.wra_lts_ra_name)  as v_wra_ra_name, -- take the first non-null RA Name value from WBE name fields
           wla.wra_enr_interviewer_obsloc as v_wra_interviewer
    INTO v_screening_id, v_wra_ra_name, v_wra_interviewer
    FROM wra_enrollment wla
    WHERE wla.record_id = v_record_id AND wla.redcap_repeat_instance = @v_last_attempt_id
       OR wla.wra_enr_visit_count = @v_last_attempt_id LIMIT 1;

    -- Update when REDCap interviewer name does not match the RA names in WRA Baseline Enrollment(WBE).
    IF v_wra_interviewer IN (v_pkantumoya_redcap_username, @v_redcap_ra_username) AND
       (v_wra_ra_name <> '' OR v_wra_ra_name) IS NOT NULL THEN
        SET @v_redcap_ra_username = get_RA_Username(v_wra_ra_name); -- possible new username
        SET @v_is_ra_username_matching = STRCMP(@v_redcap_ra_username, v_wra_interviewer); -- compare usernames
        IF @v_is_ra_username_matching = 0 THEN
            -- Identical! skip username resolution,
            SET v_resolution_outcome = 'IDENTICAL-NR';
        ELSE
            -- resolve REDCap username if username are un-identical
            UPDATE wra_enrollment uwe
            SET uwe.wra_enr_interviewer_obsloc = @v_redcap_ra_username
            WHERE uwe.record_id = v_record_id
              AND STRCMP(uwe.wra_enr_interviewer_obsloc, @v_redcap_ra_username) <> 0;
            SET v_resolution_outcome = 'UN-IDENTICAL-R';
        END IF;
    ELSE
        SET v_resolution_outcome = 'NO-ANOMALY';
    END IF;
    COMMIT;
    -- flag outcome
    SELECT v_resolution_outcome as `status`;

END $$
DELIMITER ;
