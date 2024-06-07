/**
 * Returns WRA visit status
 *
 * @author Gift Jr <muyembegift@gmail.com> | 27.09.23
 * @since 0.0.1
 * @alias Get Case Status
 * @param varchar p_screening_id - Household Screening ID
 * @param int     p_hh_member_id - Household Member ID
 * @return varchar WRA Visit Status
 */
DROP FUNCTION IF EXISTS `getCaseStatus`;
DELIMITER $$
CREATE FUNCTION getCaseStatus(p_screening_id varchar(14), p_hh_member_id int)
    RETURNS VARCHAR(32)
    NOT DETERMINISTIC
BEGIN
    DECLARE v_case_status VARCHAR(32);

    DECLARE v_vc_consent_status INT;
    DECLARE v_con_assnt_status INT;
    DECLARE v_nok_consent_status INT;
    DECLARE v_is_nok_available INT;
    DECLARE v_is_wra_available INT;
    DECLARE v_nok_dnu_enb INT;
    DECLARE v_estimated_age INT;
    DECLARE v_visit_count INT;
    DECLARE v_visit_return_date DATE;
    DECLARE v_wra_ptid VARCHAR(6);

    -- STEP 1: Check HH Enumeration completion status.
    SELECT hhe.hhe_member_eligibility
    INTO @v_status
    FROM hh_enumeration hhe
    WHERE hhe.hh_scrn_num_obsloc = p_screening_id
      AND hhe.hhe_hh_member_id = p_hh_member_id;

    -- STEP 2: Check WRA Enrollment status.
    WITH currentWraVisitCte
             AS (SELECT ROW_NUMBER() OVER (
            PARTITION BY wra_enr.redcap_repeat_instrument
            ORDER BY wra_enr.redcap_repeat_instance DESC ) as visit_number,
                        wra_enr.wra_enrollment_id,
                        wra_enr.wra_ptid,
                        wra_enr.redcap_repeat_instance     as instance_id,
                        wra_enr.wra_enr_visit_count        as visit_count,
                        wra_enr.hh_scrn_num_obsloc         as screening_id,
                        wra_enr.scrn_obsstdat              as screening_date,
                        wra_enr.wra_enr_hhh_pvc            as vc_consent_status,
                        wra_enr.wra_enr_pp_avail           as is_wra_available,
                        wra_enr.wra_enr_pdrv               as return_date,
                        wra_enr.hhe_hh_member_id           as member_id,
                        wra_enr.con_lar_yn_dsdecod         as nok_consent_status,
                        wra_enr.con_yn_dsdecod             as con_assnt_status,
                        wra_enr.wra_enr_nok_avail          as is_nok_available,
                        wra_enr.kin_lang_scorres           as nok_dnu_enb,
                        wra_enr.estimated_age
                 FROM wra_enrollment wra_enr
                 WHERE wra_enr.hh_scrn_num_obsloc = p_screening_id
                   AND wra_enr.hhe_hh_member_id = p_hh_member_id)

         -- Select Latest WRA Visit --
    SELECT wra.visit_count,
           wra.vc_consent_status,
           wra.is_wra_available,
           wra.return_date,
           wra.wra_ptid,
           wra.nok_consent_status,
           wra.con_assnt_status,
           wra.is_nok_available,
           wra.nok_dnu_enb,
           wra.estimated_age
    INTO v_visit_count, v_vc_consent_status, v_is_wra_available, v_visit_return_date, v_wra_ptid, v_nok_consent_status,
        v_con_assnt_status, v_is_nok_available, v_nok_dnu_enb, v_estimated_age
    FROM currentWraVisitCte wra
    WHERE visit_number = 1
      AND visit_number BETWEEN 1 AND 3
    ORDER BY wra.visit_count, wra.screening_date;

    IF @v_status = 'ELIGIBLE' THEN
        SELECT hhe.hhe_part_available
        INTO @v_availability
        FROM hh_enumeration hhe
        WHERE hhe.hh_scrn_num_obsloc = p_screening_id
          AND hhe.hhe_hh_member_id = p_hh_member_id;

        IF @v_availability = 0 THEN
            SET v_case_status = 'Pre-Screened in Absentia';
        ELSEIF @v_availability = 1 THEN
            SET v_case_status = 'Pre-Screened';
        END IF;

        /*---------------------------------------| Visit Status and Outcomes |---------------------------------------------*/
        IF v_visit_return_date IS NOT NULL AND
           (v_is_wra_available = 2 OR v_is_nok_available = 0 OR v_con_assnt_status = 3 OR v_nok_consent_status = 4) THEN
            SET @v_visit_status = 'Deferred';
        ELSEIF v_visit_return_date IS NOT NULL AND v_visit_count = 3 AND v_is_wra_available = 2 THEN
            SET @v_visit_status = 'Untraceable';
        ELSEIF v_visit_count <= 3 AND v_is_wra_available = 3 THEN
            SET @v_visit_status = 'Extended Absence';
        ELSEIF v_visit_count <= 3 AND
               (v_is_wra_available = 4 OR v_con_assnt_status = 4 OR v_nok_consent_status = 3) THEN
            SET @v_visit_status = 'Ineligible';
        ELSEIF v_is_wra_available = 1 AND (v_estimated_age <= 15 OR v_estimated_age >= 50) THEN
            SET @v_visit_status = 'Ineligible due to age';
        ELSEIF v_is_nok_available = 1 AND v_nok_dnu_enb = 4 THEN
            SET @v_visit_status = 'NOK does not understand ENB';
        ELSEIF v_nok_consent_status = 2 OR v_con_assnt_status = 2 THEN
            SET @v_visit_status = 'Declined';
        ELSEIF v_visit_count <= 3 AND v_is_wra_available = 1 AND v_wra_ptid IS NOT NULL THEN
            SET @v_visit_status = 'Enrolled';
        ELSEIF v_visit_count <= 3 AND v_is_wra_available = 1 AND v_wra_ptid IS NULL THEN
            SET @v_visit_status = 'Enrollment Incomplete';
        ELSEIF v_visit_count <= 3 AND v_vc_consent_status = 0 THEN
            SET @v_visit_status = 'No HH Verbal Consent';
        ELSE
            SET @v_visit_status = 'Screening';
        END IF;
    ELSEIF @v_status = 'NOT ELIGIBLE' THEN
        SELECT IF(hhe.age_scorres <= 15 OR hhe.age_scorres >= 50, 'Excluded', 'Included')
        INTO @v_status
        FROM hh_enumeration hhe
        WHERE hhe.hh_scrn_num_obsloc = p_screening_id
          AND hhe.hhe_hh_member_id = p_hh_member_id;

        IF @v_status = 'Excluded' THEN
            SET v_case_status = 'Age Exclusion';
        END IF;
    END IF;

    RETURN v_case_status;
END;
