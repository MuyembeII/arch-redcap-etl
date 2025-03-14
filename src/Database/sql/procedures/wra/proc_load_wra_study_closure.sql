/**
 * Load WRA Study Closure.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 26.02.25
 * @since 0.0.1
 * @alias WRA Study Closure
 */
DROP PROCEDURE IF EXISTS `Load_WRA_Study_Closure`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_Study_Closure()
BEGIN
    -- Smart-Simple safe-guard procedure for logging.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW WARNINGS;
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS('\n', 'OPERATION ERROR - Failed to load-CRT WRA Study Closure;', @errno, '(',
                              @sqlstate, '):',
                              @text);
            SELECT @full_error as Operation_Error_Details;
            RESIGNAL;
        END;
    -- Op matrices
    SET @v_tx_pre_sc := 0; -- Initial count
    SET @v_tx_pro_sc := 0; -- After count

    START TRANSACTION;
    SET @v_tx_pre_sc = (SELECT COUNT(sc.wra_study_closure_id) FROM wra_study_closure sc);
    TRUNCATE arch_etl_db.crt_wra_study_closure;
    INSERT INTO arch_etl_db.crt_wra_study_closure(record_id,
                                                  alternate_id,
                                                  wra_ptid,
                                                  member_id,
                                                  screening_id,
                                                  age,
                                                  dob,
                                                  visit_number,
                                                  visit_name,
                                                  visit_date,
                                                  is_serious_adverse_event,
                                                  serious_adverse_event_code,
                                                  study_termination_reason,
                                                  date_of_death,
                                                  cause_of_death,
                                                  reason_for_withdraw)
    SELECT DISTINCT sc.record_id,
                    sc.alternate_id,
                    sc.wra_ptid,
                    sc.member_id,
                    sc.screening_id,
                    sc.age,
                    sc.dob,
                    v.visit_number,
                    v.visit_alias                                     as visit_name,
                    sc.visit_date,
                    get_YN_Label(sc.sc_5)                             as is_serious_adverse_event,
                    sc.sc_6_label                                     as serious_adverse_event_code,
                    IF(sc.sc_7 = 9, sc.sc_7_other, sc.sc_7_label)     as study_termination_reason,
                    sc.sc_8                                           as date_of_death,
                    sc.sc_9                                           as cause_of_death,
                    IF(sc.sc_10 = 96, sc.sc_10_other, sc.sc_10_label) as reason_for_withdraw
    FROM (SELECT sc.wra_study_closure_id                             as alternate_id,
                 sc.record_id,
                 sc.sc_dt_of_visit                                   as visit_date,
                 v1.member_id                                        as member_id,
                 sc.redcap_event_name                                as visit_name,
                 v1.wra_ptid,
                 v1.screening_id                                     as screening_id,
                 get_WRA_Age(sc.sc_dt_of_visit, sc.record_id)        as age,
                 v1.dob,
                 sc.sc_5,
                 sc.sc_6_label,
                 sc.sc_7,
                 sc.sc_7_label,
                 REGEXP_REPLACE(sc.sc_7_other, '[[:space:]]+', ' ')  as sc_7_other,
                 sc.sc_8,
                 sc.sc_9,
                 sc.sc_10,
                 sc.sc_10_label,
                 REGEXP_REPLACE(sc.sc_10_other, '[[:space:]]+', ' ') as sc_10_other
          FROM wra_study_closure sc
                   JOIN crt_wra_visit_1_overview v1 ON (
              v1.record_id = sc.record_id AND sc.sc_2 REGEXP '^[0-9]*$'
              )) sc
             LEFT JOIN visit v ON sc.visit_name = v.visit_name
    ORDER BY sc.visit_date DESC;
    COMMIT;

    -- Process Metrics
    SET @v_tx_pro_sc = (SELECT COUNT(sc.record_id) FROM crt_wra_study_closure sc);
    SET @v_load_metrics = CONCAT_WS(' of ', @v_tx_pro_sc, @v_tx_pre_sc);
    SET @v_load_info = CONCAT('WRA-Study-Closure-Data: LOADING COMPLETE. ', @v_load_metrics);
    SELECT @v_load_info as `|_________________| Operation_Summary |_________________|`;

END $$

DELIMITER ;
