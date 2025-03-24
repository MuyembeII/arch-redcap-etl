/**
 * Participants registry data entry point
 *
 * @author Gift Jr <muyembegift@gmail.com> | 11.09.23
 * @since 0.0.1
 * @alias Get Participant Data
 */
DROP PROCEDURE IF EXISTS `GetParticipantsData`;
DELIMITER $$
CREATE PROCEDURE GetParticipantsData()
BEGIN
    DECLARE v_participant_count INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
        BEGIN
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error = CONCAT_WS(' ', 'PARTICIPANT DATA OPS ERROR; ', @errno, '(', @sqlstate, '):', @text);
            SELECT @full_error;
            RESIGNAL;
        END;


    START TRANSACTION;
    -- Insert base data
    TRUNCATE TABLE crt_participants;
    INSERT INTO crt_participants (hhe_id, household_member_id, date_of_enumeration, enumerated_by, screening_id,
                                  first_name, middle_name, last_name, sex, age, wra_eligibility, relationship_type,
                                  marital_status, case_status)
    SELECT he.hhe_id,
           he.hhe_hh_member_id                                       as household_member_id,
           he.hhe_interview_date                                     as date_of_enumeration,
           he.hhe_interviewer                                        as enumerated_by,
           he.hh_scrn_num_obsloc                                     as screening_id,
           he.fname_scorres                                          as first_name,
           he.mname_scorres                                          as middle_name,
           he.lname_scorres                                          as last_name,
           he.hhe_sex_txt                                            as sex,
           he.age_scorres                                            as age,
           he.hhe_member_eligibility                                 as wra_elgibility,
           CASE he.hh_rel_scorres
               WHEN 1 THEN 'Wife/Husband'
               WHEN 2 THEN 'Son/ Daughter'
               WHEN 3 THEN 'Adopted/Foster/Stepchild'
               WHEN 4 THEN 'Daughter in law/son-in-law'
               WHEN 5 THEN 'Grandson/ Granddaughter'
               WHEN 6 THEN 'Father/Mother'
               WHEN 7 THEN 'Father in law/Mother in law'
               WHEN 8 THEN 'Brother/sister'
               WHEN 9 THEN 'Uncle/aunt'
               WHEN 10 THEN 'Nephew/niece'
               WHEN 11 THEN 'Other relative'
               WHEN 12 THEN 'Household staff/servant'
               WHEN 13 THEN 'Friend'
               WHEN 14 THEN 'Boarder'
               WHEN 15 THEN 'Other not related'
               WHEN 998 THEN 'Don''t know'
               ELSE 'Unknown'
               END                                                      relationship_type,
           CASE he.marital_scorres
               WHEN 1 THEN 'MARRIED'
               WHEN 2 THEN 'LIVING TOGETHER'
               WHEN 3 THEN 'DIVORCED'
               WHEN 4 THEN 'SEPARATED'
               WHEN 5 THEN 'WIDOWED'
               WHEN 6 THEN 'NEVER MARRIED'
               ELSE 'Unknown'
               END                                                      marital_status,
           getCaseStatus(he.hh_scrn_num_obsloc, he.hhe_hh_member_id) as case_status
    FROM hh_enumeration he
    WHERE he.sex = 2
      AND LENGTH(he.hh_scrn_num_obsloc) = 14
    ORDER BY he.hhe_interview_date;

    SET v_participant_count = (SELECT COUNT(*) FROM crt_participants p);
    COMMIT;

    -- Total Participants
    SELECT v_participant_count as `p_count`;

END $$

DELIMITER ;
