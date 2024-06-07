/**
 * Populates household staging data into the custom reporting table
 *
 * @author Gift Jr <muyembegift@gmail.com> | 11.09.23
 * @since 0.0.1
 * @alias Get Household Data
 */
DROP PROCEDURE IF EXISTS `GetHouseholdData`;
DELIMITER $$
CREATE PROCEDURE GetHouseholdData()
BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
        BEGIN
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error = CONCAT_WS(' ', 'HH PRE-SCREENING DATA OPS ERROR; ', @errno, '(', @sqlstate, '):', @text);
            SELECT @full_error;
            RESIGNAL;
        END;

    START TRANSACTION;
    -- Refresh reporting table
    TRUNCATE TABLE crt_households;

    -- Insert base data
    INSERT INTO crt_households (hh_id, screening_id, date_of_screening, screened_by)
    SELECT DISTINCT hss.record_id          as hh_id,
           hss.hh_scrn_num_obsloc as screening_d,
           hss.interview_date_scorres         as date_of_screening,
           hss.hhsidv_n_o_i         as screened_by
    FROM hh_screening hss
    WHERE hss.hh_scrn_num_obsloc NOT IN ('013-001-001-01', '016-013-004-01');

    -- Screening Status
    UPDATE crt_households hh
        LEFT JOIN hh_screening hhs ON hh.screening_id = hhs.hh_scrn_num_obsloc
    SET hh.screening_status = getHouseholdScreeningStatus(hh.screening_id)
    WHERE hh.screening_id = hhs.hh_scrn_num_obsloc;

    -- Screened HH Members Count
    UPDATE crt_households hh
        LEFT JOIN hh_enumeration hhe ON hh.screening_id = hhe.hh_scrn_num_obsloc
    SET hh.screened_household_members = getScreenedHouseholdMembers(hh.screening_id)
    WHERE hh.screening_id = hhe.hh_scrn_num_obsloc;

    -- populate M & L data
    UPDATE crt_households hh
        LEFT JOIN
        map_and_list ml ON hh.screening_id = ml.screenid
    SET hh.expected_head_of_household = ml.hh_name,
        hh.expected_household_members = ml.hh_total_m,
        hh.expected_number_of_wra     = ml.hh_wra
    WHERE hh.screening_id = ml.screenid;

    -- Current Head of HH
    UPDATE crt_households hh
        LEFT JOIN hh_enumeration hhe ON hh.screening_id = hhe.hh_scrn_num_obsloc
    SET hh.current_head_of_household = CONCAT_WS(' ', hhe.fname_scorres, hhe.lname_scorres)
    WHERE hhe.redcap_repeat_instance = 1;

    -- Is Verbal Consent Given?
    UPDATE crt_households hh
        LEFT JOIN hh_verbal_consent hhvc ON hh.screening_id = hhvc.hh_scrn_num_obsloc
    SET hh.hh_verbal_consent = isHouseholdVerbalConsentGiven(hh.screening_id)
    WHERE hh.screening_id = hhvc.hh_scrn_num_obsloc;

    -- Member enumerations status
    UPDATE crt_households hh
        LEFT JOIN hh_enumeration hhe ON hh.screening_id = hhe.hh_scrn_num_obsloc
    SET hh.hhe_status = isHouseholdEnumerationCompleted(hh.screening_id)
    WHERE hh.screening_id = hhe.hh_scrn_num_obsloc;

    -- Females found
    UPDATE crt_households hh
        LEFT JOIN hh_enumeration hhe ON hh.screening_id = hhe.hh_scrn_num_obsloc
    SET hh.number_of_females = hhe.female_count
    WHERE hhe.redcap_repeat_instance = 1;

    -- Eligible Participants
    UPDATE crt_households hh
        LEFT JOIN hh_enumeration hhe ON hh.screening_id = hhe.hh_scrn_num_obsloc
    SET hh.number_of_eligible_wra = countHHEligibleWRAByScreeningID(hh.screening_id)
    WHERE hh.screening_id = hhe.hh_scrn_num_obsloc;

    -- Status of the Pre-screening visit
    UPDATE crt_households hh
        LEFT JOIN hh_enumeration hhe ON hh.screening_id = hhe.hh_scrn_num_obsloc
    SET hh.visit_status = isHouseholdVisitCompleted(hh.screening_id)
    WHERE hh.screening_id = hhe.hh_scrn_num_obsloc;
    COMMIT;

END $$

DELIMITER ;
