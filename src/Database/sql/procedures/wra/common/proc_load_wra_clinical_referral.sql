/**
 * Load WRA Clinical Referral.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 24.03.25
 * @since 0.0.1
 * @alias Load WRA CR
 */
DROP PROCEDURE IF EXISTS `Load_WRA_Clinical_Referral`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_Clinical_Referral()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'ERROR - Failed to run proc; [Load_WRA_Clinical_Referral]', @errno, '(', @sqlstate,
                              '):',
                              @text);
            SELECT @full_error;
            RESIGNAL;
        END;
    -- Op matrices
    SET @v_tx_pre_cr := 0; -- Initial count
    SET @v_tx_pro_cr := 0; -- After count

    START TRANSACTION;
    TRUNCATE arch_etl_db.crt_wra_clinical_referral_overview;
    SET @v_tx_pre_cr = (SELECT COUNT(cr.root_id) FROM clinical_referral_repeating_instruments cr);
    INSERT INTO arch_etl_db.crt_wra_clinical_referral_overview(id, referral_id, record_id, wra_ptid, member_id,
                                                               screening_id, ra, age, visit_number, visit_name,
                                                               visit_date, referral_destination,
                                                               other_referral_destination, reason_for_referral,
                                                               other_reason_for_referral, comments)
    SELECT cr.id,
           cr.referral_id,
           cr.record_id,
           cr.wra_ptid,
           cr.member_id,
           cr.screening_id,
           cr.ra,
           cr.age,
           cr.visit_number,
           cr.visit_name,
           cr.visit_date,
           cr.referral_destination,
           cr.other_referral_destination,
           cr.reason_for_referral,
           cr.other_reason_for_referral,
           cr.comments
    FROM (SELECT ref.clinical_referral_repeating_instruments_id                                           as id,
                 CAST(ref.record_id AS UNSIGNED)                                                          as record_id,
                 ROW_NUMBER() OVER (
                     PARTITION BY ref.record_id ORDER BY ref.redcap_repeat_instance DESC)                 as referral_id,
                 v1.wra_ptid,
                 v1.member_id,
                 get_WRA_HH_Screening_ID(CAST(ref.record_id AS UNSIGNED))                                 as screening_id,
                 get_WRA_Age(COALESCE(ref.cr_visit_date, v1.visit_date), CAST(ref.record_id AS UNSIGNED)) as age,
                 COALESCE(ref.cr_interviewer_obsloc, v1.ra)                                               as ra,
                 v.visit_number,
                 v.visit_alias                                                                            as visit_name,
                 COALESCE(ref.cr_visit_date, v1.visit_date)                                               as visit_date,
                 IF(ref.cr_refer_to = 4, 'Other', ref.cr_refer_to_label)                                  as referral_destination,
                 useStringCapFirst(useAutoTrimmer(ref.cr_refer_to_other))                                 as other_referral_destination,
                 get_Referral_Reasons(ref.clinical_referral_repeating_instruments_id)                     as reason_for_referral,
                 useStringCapFirst(useAutoTrimmer(ref.referral_reasons_other))                            as other_reason_for_referral,
                 useStringCapFirst(useAutoTrimmer(ref.cr_ra_comments))                                    as comments
          FROM clinical_referral_repeating_instruments ref
                   LEFT JOIN crt_wra_visit_1_overview v1 ON v1.record_id = CAST(ref.record_id AS UNSIGNED)
                   JOIN visit v ON ref.redcap_event_name = v.visit_name
          -- intentionally declaring this filter lazy to catch incomplete REDCap forms. Delete blank form from REDCap
          WHERE ref.cr_visit_date IS NOT NULL) cr
    ORDER BY cr.visit_date DESC;
    COMMIT;

    -- Operation Summary.
    SELECT COUNT(IF(ref.visit_number = 1.0, 1, NULL)) as 'TX_VISIT_1',
           COUNT(IF(ref.visit_number = 2.0, 1, NULL)) as 'TX_VISIT_2',
           COUNT(IF(ref.visit_number = 3.0, 1, NULL)) as 'TX_VISIT_3',
           COUNT(IF(ref.visit_number = 4.0, 1, NULL)) as 'TX_VISIT_4',
           COUNT(IF(ref.visit_number = 5.0, 1, NULL)) as 'TX_VISIT_5',
           COUNT(IF(ref.visit_number = 6.0, 1, NULL)) as 'TX_VISIT_6'
    FROM crt_wra_clinical_referral_overview ref;

END $$

DELIMITER ;
