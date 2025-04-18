/**
 * WRA enrollment by latest visit
 *
 * @author Gift Jr <muyembegift@gmail.com> | 17.10.23
 * @since 0.0.1
 * @alias Get WRA Enrollment Status
 * @param p_enrollment_id VARCHAR(6) WRA PTID
 * @return TEXT status
 */
DROP FUNCTION IF EXISTS `get_WRA_EnrollmentStatus`;
DELIMITER $$
CREATE FUNCTION get_WRA_EnrollmentStatus(p_enrollment_id BIGINT, p_id MEDIUMINT)
    RETURNS TINYTEXT
    NOT DETERMINISTIC
BEGIN
    SET @v_visit_status = 'Screening';
    -- Status Indicators
    SET @v_vc_consent_status := 0;
    SET @v_con_assnt_status := 0;
    SET @v_nok_consent_status := 0; -- (1. Yes, 2. Refused, 3. Physical or mental impairment, 4. Consent deferred/postponed)
    SET @v_is_nok_available := 0;
    SET @v_is_wra_available := 0; -- (1. Available, 2. Not available ,3. Extended Absence ,4. Physical or mental impairment ,5. Declined ,6. Other)
    SET @v_wra_nok_dnu_enb := 0;
    SET @v_icf_quiz_score := 0;
    SET @v_visit_count := 0;
    SET @v_visit_return_date := NULL;
    SET @v_wra_ptid := NULL;
    SET @v_age := 0;
    SET @v_wra_forms_complete := 0;

    -- Readable WBE Overview to provide key indicator variables for reporting purposes
    DROP TEMPORARY TABLE IF EXISTS wra_enr_overview;
    CREATE TEMPORARY TABLE wra_enr_overview
    (
        wra_id             MEDIUMINT PRIMARY KEY,
        visit_type         VARCHAR(64) NOT NULL,
        wra_enrollment_id  BIGINT,
        wra_ptid           VARCHAR(6),
        member_id          SMALLINT,
        visit_count        INT1,
        instance_id        SMALLINT,
        screening_id       VARCHAR(14),
        screening_date     DATE,
        vc_consent_status  SMALLINT,
        is_wra_available   SMALLINT,
        return_date        DATE,
        nok_consent_status SMALLINT,
        con_assnt_status   SMALLINT,
        is_nok_available   SMALLINT,
        wra_nok_dnu_enb    SMALLINT,
        icf_quiz_score     INT1,
        age                SMALLINT,
        wbe_form_status    TINYINT
    );

    -- ENROLLMENT-STATUS-OPERATION-1: Collect WBE status indicators and traverses multi point variables.
    INSERT INTO wra_enr_overview(wra_id, visit_type, wra_enrollment_id, wra_ptid, member_id, visit_count, instance_id,
                                 screening_id, screening_date, vc_consent_status, is_wra_available, return_date,
                                 nok_consent_status, con_assnt_status, is_nok_available, wra_nok_dnu_enb,
                                 icf_quiz_score, age, wbe_form_status)
    SELECT wra_enr.id                                                    as wra_id,
           wra_enr.redcap_event_name                                     as visit_type,
           wra_enr.wra_enrollment_id,
           wra_enr.wra_ptid,
           wra_enr.hhe_hh_member_id                                      as member_id,
           wra_enr.wra_enr_visit_count                                   as visit_count,
           wra_enr.redcap_repeat_instance                                as instance_id,
           wra_enr.hh_scrn_num_obsloc                                    as screening_id,
           wra_enr.scrn_obsstdat                                         as screening_date,
           wra_enr.wra_enr_hhh_pvc                                       as vc_consent_status,
           wra_enr.wra_enr_pp_avail                                      as is_wra_available,
           wra_enr.wra_enr_pdrv                                          as return_date,
           wra_enr.con_lar_yn_dsdecod                                    as nok_consent_status,
           wra_enr.con_yn_dsdecod                                        as con_assnt_status,
           wra_enr.wra_enr_nok_avail                                     as is_nok_available,
           COALESCE(wra_enr.wra_enr_part_lang, wra_enr.kin_lang_scorres) as wra_nok_dnu_enb,
           COALESCE(wra_enr.icf_score, wra_enr.icf_nok_score)            as icf_quiz_score,
           COALESCE(wra_enr.wra_age, wra_enr.estimated_age)              as age,
           wra_enr.wra_forms_complete                                    as wbe_form_status
    FROM wra_enrollment wra_enr
    WHERE wra_enr.id = p_id;

    -- Staging WRA overview
    SELECT wo.instance_id,
           wo.vc_consent_status,
           wo.is_wra_available,
           wo.return_date,
           wo.wra_ptid,
           wo.nok_consent_status,
           wo.con_assnt_status,
           wo.is_nok_available,
           wo.wra_nok_dnu_enb,
           wo.icf_quiz_score,
           wo.age,
           wo.wbe_form_status
    INTO @v_visit_count, @v_vc_consent_status, @v_is_wra_available, @v_visit_return_date, @v_wra_ptid, @v_nok_consent_status,
        @v_con_assnt_status, @v_is_nok_available, @v_wra_nok_dnu_enb, @v_icf_quiz_score, @v_age, @v_wra_forms_complete
    FROM wra_enr_overview wo;

    /*---------------------------------------| Visit Status and Outcomes |---------------------------------------------*/
    IF @v_vc_consent_status = 0 THEN
        SET @v_visit_status = 'Declined Verbal-Consent';
    ELSEIF @v_is_wra_available = 2 OR @v_is_nok_available = 0 OR @v_con_assnt_status = 3 OR
           @v_nok_consent_status = 4 THEN
        SET @v_visit_status = 'Deferred';
    ELSEIF @v_visit_count = 3 AND @v_is_wra_available = 2 THEN
        SET @v_visit_status = 'Untraceable';
    ELSEIF @v_visit_count <= 3 AND @v_is_wra_available = 3 THEN
        SET @v_visit_status = 'Extended-Absence';
    ELSEIF @v_visit_count <= 3 AND @v_is_wra_available = 4 THEN
        IF @v_nok_consent_status = 3 THEN
            SET @v_visit_status = 'NOK Physical/Mental-Impairment';
        ELSE
            SET @v_visit_status = 'Physical/Mental-Impairment';
        END IF;
    ELSEIF @v_visit_count <= 3 AND @v_is_wra_available = 5 THEN
        SET @v_visit_status = 'Declined';
    ELSEIF @v_visit_count <= 3 AND @v_is_wra_available = 6 THEN
        SET @v_visit_status = 'Other';
    ELSEIF @v_visit_count <= 3 AND @v_nok_consent_status = 6 THEN
        SET @v_visit_status = 'Other';
    ELSEIF @v_visit_count <= 3 AND
           (@v_is_wra_available = 4 OR @v_con_assnt_status = 4 OR @v_nok_consent_status = 3) THEN
        SET @v_visit_status = 'Ineligible';
    ELSEIF @v_is_wra_available = 1 AND (@v_age <= 14 OR @v_age >= 50) THEN
        SET @v_visit_status = 'Ineligible Due To Age';
    ELSEIF @v_is_nok_available = 1 AND @v_wra_nok_dnu_enb = 4 THEN
        SET @v_visit_status = 'WRA/NOK Does Not Understand E_N_B';
    ELSEIF @v_nok_consent_status = 2 OR @v_con_assnt_status = 2 THEN
        SET @v_visit_status = 'Declined';
    ELSEIF @v_visit_count <= 3 AND @v_is_wra_available = 1 AND LENGTH(@v_wra_ptid) = 6 THEN
        SET @v_visit_status = 'Enrolled';
    ELSEIF @v_visit_count <= 3 AND (@v_icf_quiz_score > 0 AND @v_icf_quiz_score < 6) THEN
        SET @v_visit_status = 'ICF-Quiz-Failed';
    ELSE
        SET @v_visit_status = 'Screened';
    END IF;

    -- WRA Forms Status
    IF @v_wra_forms_complete = 0 OR @v_wra_forms_complete = 1 THEN
        SET @v_visit_status = CONCAT_WS('|', @v_visit_status, 'Incomplete');
    ELSEIF @v_wra_forms_complete = 2 THEN
        SET @v_visit_status = CONCAT_WS('|', @v_visit_status, 'Complete');
    END IF;
    RETURN @v_visit_status;

END $$

DELIMITER ;
