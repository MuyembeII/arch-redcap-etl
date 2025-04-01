/**
 * Returns HH visit status of a household
 *
 * @author Gift Jr <muyembegift@gmail.com> | 16.09.23
 * @since 0.0.1
 * @alias Is household visit completed?
 * @param varchar Household Screening ID
 * @return varchar Household Visit Status
 */
DROP FUNCTION IF EXISTS `isHouseholdVisitCompleted`;
DELIMITER $$
CREATE FUNCTION isHouseholdVisitCompleted(p_screening_id varchar(14))
    RETURNS VARCHAR(32)
    NOT DETERMINISTIC
BEGIN

    -- Visit Status temp table
    DROP TEMPORARY TABLE IF EXISTS hh_screening_temp;
    CREATE TEMPORARY TABLE hh_screening_temp
    (
        id                     INT PRIMARY KEY,
        hh_verification_status TINYTEXT,
        hh_vc_status           TINYTEXT,
        hh_enum_status         TINYTEXT
    );
    -- Defaults
    INSERT INTO hh_screening_temp(id, hh_verification_status, hh_vc_status, hh_enum_status)
    VALUES (1, 'Un-verified', 'Un-consented', 'Un-enumerated');
    -- Verification Status
    UPDATE hh_screening_temp hhsv
    SET hhsv.hh_verification_status = getHouseholdVerificationStatus(p_screening_id)
    WHERE hhsv.id = 1;
    -- Verbal Consent Status
    UPDATE hh_screening_temp hhsv
    SET hhsv.hh_vc_status = isHouseholdVerbalConsentGiven(p_screening_id)
    WHERE hhsv.id = 1;
    -- Member Enumeration Status
    UPDATE hh_screening_temp hhsv
    SET hhsv.hh_enum_status = isHouseholdEnumerationCompleted(p_screening_id)
    WHERE hhsv.id = 1;

    SELECT st.hh_verification_status INTO @v_is_hh_verified FROM hh_screening_temp st;
    SELECT st.hh_vc_status INTO @v_hh_consented FROM hh_screening_temp st;
    SELECT st.hh_enum_status INTO @v_hh_enumerated FROM hh_screening_temp st;


    IF @v_is_hh_verified = 'Verified' AND @v_hh_consented = 'Consented' AND (@v_hh_enumerated = 'Completed' OR @v_hh_enumerated = 'Completed|Outliers') THEN
        SET @v_is_visit_completed = 'Completed';
    ELSE
        SET @v_is_visit_completed = 'In-complete';
    END IF;

    RETURN (@v_is_visit_completed);

END $$

DELIMITER ;
