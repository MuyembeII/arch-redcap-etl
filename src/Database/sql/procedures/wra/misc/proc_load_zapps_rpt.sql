DROP PROCEDURE IF EXISTS `Load_ZAPPS_Data`;

DELIMITER $$
CREATE PROCEDURE Load_ZAPPS_Data()
BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                CONCAT_WS(' ', 'ERROR - Failed to load ZAPPS Data;', @errno, '(',
                          @sqlstate, '):', @text);
            SELECT @full_error;
            RESIGNAL;
        END;


    START TRANSACTION;
    -- Fetch from pregnancy assessment instruments
    INSERT INTO crt_zapps_participants(id, wra_enrollment_id, household_member_id, wra_ptid, wra_name, screening_id,
                                       date_of_birth, date_of_arch_enrollment, date_of_zapps_referral,
                                       date_of_lmp, date_of_fp_upt_test, date_of_appointment, referred_by)
    SELECT wra_pa.record_id                                                           as id,
           e.wra_enrollment_id,
           e.household_member_id,
           e.wra_ptid,
           CONCAT_WS(' ', e.first_name, e.middle_name, e.last_name)                   as wra_name,
           e.screening_id,
           enr.brthdat                                                                as date_of_birth,
           e.date_of_enrollment                                                       as date_of_arch_enrollment,
           COALESCE(wra_pa.zr_visit_date, wra_pa.pa_visit_date, e.date_of_enrollment) as date_of_zapps_referral,
           pos.lmp_scdat                                                              as date_of_lmp,
           COALESCE(pos.np_date_of_test, pos.np_date_of_test_2)                       as date_of_fp_upt_test,
           wra_pa.apnt_dat_scorres                                                    as date_of_appointment,
           enr.wra_ra_name                                                            as referred_by
    FROM wra_pregnancy_assessments wra_pa
             LEFT JOIN wra_preg_overview_surveillance pos ON wra_pa.record_id = pos.record_id
             LEFT JOIN wra_enrollment enr ON wra_pa.record_id = enr.record_id
             LEFT JOIN crt_enrollments e ON enr.wra_enrollment_id = e.wra_enrollment_id;
    COMMIT;

    SELECT 1 as `status`;

END $$

DELIMITER ;
