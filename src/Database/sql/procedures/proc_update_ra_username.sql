DROP PROCEDURE IF EXISTS `UpdateRaUsername`;
DELIMITER $$
CREATE PROCEDURE UpdateRaUsername()
BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
        BEGIN
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                CONCAT_WS(' ', ' Update RA Username anomalies NOT resolved!; ', @errno, '(', @sqlstate, '):', @text);
            SELECT @full_error;
            RESIGNAL;
        END;

    START TRANSACTION;

    UPDATE wra_enrollment e
    SET e.wra_enr_interviewer_obsloc = 'aaposamweo'
    WHERE e.wra_enr_interviewer_obsloc = 'pkantumoya'
      AND COALESCE(e.wra_ra_name,
                   e.wra_enr_nok_ra_name,
                   e.wra_enr_nok_lts_ra_name,
                   e.wra_lts_ra_name) LIKE '%Aaron%';
    -- Update imported WRA enrollments user to RA
    UPDATE wra_enrollment e
    SET e.wra_enr_interviewer_obsloc = 'aaposamweo'
    WHERE e.wra_enr_interviewer_obsloc = 'gmuyembe'
      AND COALESCE(e.wra_ra_name,
                   e.wra_enr_nok_ra_name,
                   e.wra_enr_nok_lts_ra_name,
                   e.wra_lts_ra_name) LIKE '%Aaron%';

    UPDATE wra_enrollment e
    SET e.wra_enr_interviewer_obsloc = 'cmbulo'
    WHERE e.wra_enr_interviewer_obsloc = 'pkantumoya'
      AND COALESCE(e.wra_ra_name,
                   e.wra_enr_nok_ra_name,
                   e.wra_enr_nok_lts_ra_name,
                   e.wra_lts_ra_name) LIKE '%Chiluba%';

    -- Update imported WRA enrollments user to RA
    UPDATE wra_enrollment e
    SET e.wra_enr_interviewer_obsloc = 'cmbulo'
    WHERE e.wra_enr_interviewer_obsloc = 'gmuyembe'
      AND COALESCE(e.wra_ra_name,
                   e.wra_enr_nok_ra_name,
                   e.wra_enr_nok_lts_ra_name,
                   e.wra_lts_ra_name) LIKE '%Chiluba%';

    UPDATE wra_enrollment e
    SET e.wra_enr_interviewer_obsloc = 'cmusanide'
    WHERE e.wra_enr_interviewer_obsloc = 'pkantumoya'
      AND COALESCE(e.wra_ra_name,
                   e.wra_enr_nok_ra_name,
                   e.wra_enr_nok_lts_ra_name,
                   e.wra_lts_ra_name) LIKE '%Musanide%';
    UPDATE wra_enrollment e
    -- Update imported WRA enrollments user to RA
    SET e.wra_enr_interviewer_obsloc = 'cmusanide'
    WHERE e.wra_enr_interviewer_obsloc = 'gmuyembe'
      AND COALESCE(e.wra_ra_name,
                   e.wra_enr_nok_ra_name,
                   e.wra_enr_nok_lts_ra_name,
                   e.wra_lts_ra_name) LIKE '%Musanide%';

    UPDATE wra_enrollment e
    SET e.wra_enr_interviewer_obsloc = 'cmutale'
    WHERE e.wra_enr_interviewer_obsloc = 'pkantumoya'
      AND COALESCE(e.wra_ra_name,
                   e.wra_enr_nok_ra_name,
                   e.wra_enr_nok_lts_ra_name,
                   e.wra_lts_ra_name) LIKE '%Mutale%';
    UPDATE wra_enrollment e
    -- Update imported WRA enrollments user to RA
    SET e.wra_enr_interviewer_obsloc = 'cmutale'
    WHERE e.wra_enr_interviewer_obsloc = 'gmuyembe'
      AND COALESCE(e.wra_ra_name,
                   e.wra_enr_nok_ra_name,
                   e.wra_enr_nok_lts_ra_name,
                   e.wra_lts_ra_name) LIKE '%Mutale%';

    UPDATE wra_enrollment e
    SET e.wra_enr_interviewer_obsloc = 'gmiyombo'
    WHERE e.wra_enr_interviewer_obsloc = 'pkantumoya'
      AND COALESCE(e.wra_ra_name,
                   e.wra_enr_nok_ra_name,
                   e.wra_enr_nok_lts_ra_name,
                   e.wra_lts_ra_name) LIKE '%Gift%';
    UPDATE wra_enrollment e
    SET e.wra_enr_interviewer_obsloc = 'gmiyombo'
    WHERE e.wra_enr_interviewer_obsloc = 'gmuyembe'
      AND COALESCE(e.wra_ra_name,
                   e.wra_enr_nok_ra_name,
                   e.wra_enr_nok_lts_ra_name,
                   e.wra_lts_ra_name) LIKE '%Gift%';

    UPDATE wra_enrollment e
    SET e.wra_enr_interviewer_obsloc = 'gmuzyamba'
    WHERE e.wra_enr_interviewer_obsloc = 'pkantumoya'
      AND COALESCE(e.wra_ra_name,
                   e.wra_enr_nok_ra_name,
                   e.wra_enr_nok_lts_ra_name,
                   e.wra_lts_ra_name) LIKE '%George%';
    UPDATE wra_enrollment e
    SET e.wra_enr_interviewer_obsloc = 'gmuzyamba'
    WHERE e.wra_enr_interviewer_obsloc = 'gmuyembe'
      AND COALESCE(e.wra_ra_name,
                   e.wra_enr_nok_ra_name,
                   e.wra_enr_nok_lts_ra_name,
                   e.wra_lts_ra_name) LIKE '%George%';

    UPDATE wra_enrollment e
    SET e.wra_enr_interviewer_obsloc = 'ilikomba'
    WHERE e.wra_enr_interviewer_obsloc = 'pkantumoya'
      AND COALESCE(e.wra_ra_name,
                   e.wra_enr_nok_ra_name,
                   e.wra_enr_nok_lts_ra_name,
                   e.wra_lts_ra_name) LIKE '%Likomba%';
    UPDATE wra_enrollment e
    SET e.wra_enr_interviewer_obsloc = 'ilikomba'
    WHERE e.wra_enr_interviewer_obsloc = 'gmuyembe'
      AND COALESCE(e.wra_ra_name,
                   e.wra_enr_nok_ra_name,
                   e.wra_enr_nok_lts_ra_name,
                   e.wra_lts_ra_name) LIKE '%Likomba%';

    UPDATE wra_enrollment e
    SET e.wra_enr_interviewer_obsloc = 'jdaka'
    WHERE e.wra_enr_interviewer_obsloc = 'pkantumoya'
      AND COALESCE(e.wra_ra_name,
                   e.wra_enr_nok_ra_name,
                   e.wra_enr_nok_lts_ra_name,
                   e.wra_lts_ra_name) LIKE '%Josephine%';
    UPDATE wra_enrollment e
    SET e.wra_enr_interviewer_obsloc = 'jdaka'
    WHERE e.wra_enr_interviewer_obsloc = 'gmuyembe'
      AND COALESCE(e.wra_ra_name,
                   e.wra_enr_nok_ra_name,
                   e.wra_enr_nok_lts_ra_name,
                   e.wra_lts_ra_name) LIKE '%Josephine%';

    UPDATE wra_enrollment e
    SET e.wra_enr_interviewer_obsloc = 'lmulenga'
    WHERE e.wra_enr_interviewer_obsloc = 'pkantumoya'
      AND COALESCE(e.wra_ra_name,
                   e.wra_enr_nok_ra_name,
                   e.wra_enr_nok_lts_ra_name,
                   e.wra_lts_ra_name) LIKE '%Laetitia%';
    UPDATE wra_enrollment e
    SET e.wra_enr_interviewer_obsloc = 'lmulenga'
    WHERE e.wra_enr_interviewer_obsloc = 'gmuyembe'
      AND COALESCE(e.wra_ra_name,
                   e.wra_enr_nok_ra_name,
                   e.wra_enr_nok_lts_ra_name,
                   e.wra_lts_ra_name) LIKE '%Laetitia%';

    UPDATE wra_enrollment e
    SET e.wra_enr_interviewer_obsloc = 'mkoni'
    WHERE e.wra_enr_interviewer_obsloc = 'pkantumoya'
      AND COALESCE(e.wra_ra_name,
                   e.wra_enr_nok_ra_name,
                   e.wra_enr_nok_lts_ra_name,
                   e.wra_lts_ra_name) LIKE '%Milner%';
    UPDATE wra_enrollment e
    SET e.wra_enr_interviewer_obsloc = 'mkoni'
    WHERE e.wra_enr_interviewer_obsloc = 'gmuyembe'
      AND COALESCE(e.wra_ra_name,
                   e.wra_enr_nok_ra_name,
                   e.wra_enr_nok_lts_ra_name,
                   e.wra_lts_ra_name) LIKE '%Milner%';

    UPDATE wra_enrollment e
    SET e.wra_enr_interviewer_obsloc = 'msiame'
    WHERE e.wra_enr_interviewer_obsloc = 'pkantumoya'
      AND COALESCE(e.wra_ra_name,
                   e.wra_enr_nok_ra_name,
                   e.wra_enr_nok_lts_ra_name,
                   e.wra_lts_ra_name) LIKE '%Siame%';
    UPDATE wra_enrollment e
    SET e.wra_enr_interviewer_obsloc = 'msiame'
    WHERE e.wra_enr_interviewer_obsloc = 'gmuyembe'
      AND COALESCE(e.wra_ra_name,
                   e.wra_enr_nok_ra_name,
                   e.wra_enr_nok_lts_ra_name,
                   e.wra_lts_ra_name) LIKE '%Siame%';

    UPDATE wra_enrollment e
    SET e.wra_enr_interviewer_obsloc = 'njacobs'
    WHERE e.wra_enr_interviewer_obsloc = 'pkantumoya'
      AND COALESCE(e.wra_ra_name,
                   e.wra_enr_nok_ra_name,
                   e.wra_enr_nok_lts_ra_name,
                   e.wra_lts_ra_name) LIKE '%Nico%';
    UPDATE wra_enrollment e
    SET e.wra_enr_interviewer_obsloc = 'njacobs'
    WHERE e.wra_enr_interviewer_obsloc = 'gmuyembe'
      AND COALESCE(e.wra_ra_name,
                   e.wra_enr_nok_ra_name,
                   e.wra_enr_nok_lts_ra_name,
                   e.wra_lts_ra_name) LIKE '%Nico%';

    UPDATE wra_enrollment e
    SET e.wra_enr_interviewer_obsloc = 'nkangwa'
    WHERE e.wra_enr_interviewer_obsloc = 'pkantumoya'
      AND COALESCE(e.wra_ra_name,
                   e.wra_enr_nok_ra_name,
                   e.wra_enr_nok_lts_ra_name,
                   e.wra_lts_ra_name) LIKE '%Norah%';
    UPDATE wra_enrollment e
    SET e.wra_enr_interviewer_obsloc = 'nkangwa'
    WHERE e.wra_enr_interviewer_obsloc = 'gmuyembe'
      AND COALESCE(e.wra_ra_name,
                   e.wra_enr_nok_ra_name,
                   e.wra_enr_nok_lts_ra_name,
                   e.wra_lts_ra_name) LIKE '%Norah%';

    UPDATE wra_enrollment e
    SET e.wra_enr_interviewer_obsloc = 'rkangwa'
    WHERE e.wra_enr_interviewer_obsloc = 'pkantumoya'
      AND COALESCE(e.wra_ra_name,
                   e.wra_enr_nok_ra_name,
                   e.wra_enr_nok_lts_ra_name,
                   e.wra_lts_ra_name) LIKE '%Regina%';
    UPDATE wra_enrollment e
    SET e.wra_enr_interviewer_obsloc = 'rkangwa'
    WHERE e.wra_enr_interviewer_obsloc = 'gmuyembe'
      AND COALESCE(e.wra_ra_name,
                   e.wra_enr_nok_ra_name,
                   e.wra_enr_nok_lts_ra_name,
                   e.wra_lts_ra_name) LIKE '%Regina%';

    UPDATE wra_enrollment e
    SET e.wra_enr_interviewer_obsloc = 'schanda'
    WHERE e.wra_enr_interviewer_obsloc = 'pkantumoya'
      AND COALESCE(e.wra_ra_name,
                   e.wra_enr_nok_ra_name,
                   e.wra_enr_nok_lts_ra_name,
                   e.wra_lts_ra_name) LIKE '%Sithembile%';
    UPDATE wra_enrollment e
    SET e.wra_enr_interviewer_obsloc = 'schanda'
    WHERE e.wra_enr_interviewer_obsloc = 'gmuyembe'
      AND COALESCE(e.wra_ra_name,
                   e.wra_enr_nok_ra_name,
                   e.wra_enr_nok_lts_ra_name,
                   e.wra_lts_ra_name) LIKE '%Sithembile%';
    COMMIT;

    -- flag completion
    SELECT 1 as `status`;

END $$

DELIMITER ;
