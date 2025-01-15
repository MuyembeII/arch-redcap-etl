/**
 * /----------------+___| List of WRA's due for the fourth follow-up visit (FU 4) |___+-----------------\
 *  Due to visits that are lost to follow-up(LTFU), a combined dataset of appointments from all
 *  previous visit will be of inclusion for scheduling.                                                 |*
 *                                                                                                      ^
 * @author : Gift Jr | Dowc | <muyembegift@gmail.com> | 12.11.24                                        |*
 * @since  : 0.0.1                                                                                      ):
 * @alias  : WRA Fourth FU Visit Due Schedule                                                            (;
  \_______---______/--------------------------------------------------------------------\______---______/
 */
CREATE OR REPLACE ALGORITHM = MERGE VIEW vw_wra_fourth_fu_schedule
AS
-- Dateset 1: Baseline visit without any recorded appointment for 1st, 2nd and 3rd FU's.
SELECT *
FROM (SELECT v1.record_id,
             v1.screening_id,
             v1.wra_ptid,
             COALESCE(v5.visit_date, v1.screening_date)                                    as last_visit_date,
             IF(v5.attempt_number IS NULL OR v5.attempt_number = '', 0, v5.attempt_number) as attempt_number,
             DATE_ADD(v1.screening_date, INTERVAL (90 + 90 + 90 + 90) DAY)                 as follow_up_4_visit_date,
             DATE_ADD(v1.screening_date, INTERVAL ((90 + 90 + 90 + 90) + 21)
                      DAY)                                                                 as follow_up_4_last_visit_date,
             DATEDIFF(CURRENT_DATE,
                      DATE_ADD(v1.screening_date, INTERVAL (90 + 90 + 90 + 90) DAY))       as follow_up_4_visit_date_days_late
      FROM vw_wra_baseline_visit_overview v1
               LEFT JOIN vw_wra_fourth_fu_visit_overview v5 ON v1.record_id = v5.record_id
      WHERE v1.record_id NOT IN (SELECT f1.record_id FROM vw_wra_first_fu_visit_overview f1)
        AND v1.record_id NOT IN (SELECT f2.record_id FROM vw_wra_second_fu_visit_overview f2)
        AND v1.record_id NOT IN (SELECT f3.record_id FROM vw_wra_third_fu_visit_overview f3)
        AND v1.record_id NOT IN ((SELECT v5.record_id
                                  FROM vw_wra_fourth_fu_visit_overview v5
                                  WHERE v5.visit_status IN (
                                                            'Yes', 'Available', 'Migrated', 'Extended-Absence',
                                                            'No, Extended Absence', 'Physical/Mental-Impairment',
                                                            'No, has migrated', 'Untraceable',
                                                            'Other {wra_fu_is_wra_avail_other_f4}'
                                      )))
        AND DATEDIFF(CURRENT_DATE, DATE_ADD(v1.screening_date, INTERVAL (90 + 90 + 90 + 90) DAY)) > -21
        AND DATEDIFF(CURRENT_DATE, DATE_ADD(v1.screening_date, INTERVAL (90 + 90 + 90 + 90) DAY)) <= 21
      UNION
-- Dateset 2: 1st FU visits due for 4th FU appointment.
      SELECT v2.record_id,
             v2.screening_id,
             v2.wra_ptid,
             COALESCE(v5.visit_date, v2.visit_date)                                        as last_visit_date,
             IF(v5.attempt_number IS NULL OR v5.attempt_number = '', 0, v5.attempt_number) as attempt_number,
             DATE_ADD(v2.visit_date, INTERVAL (90 + 90 + 90) DAY)                          as follow_up_4_visit_date,
             DATE_ADD(v2.visit_date, INTERVAL ((90) + (90) + (90 + 21))
                      DAY)                                                                 as follow_up_4_last_visit_date,
             DATEDIFF(CURRENT_DATE,
                      DATE_ADD(v2.visit_date, INTERVAL ((90) + (90) + 90) DAY))            as follow_up_4_visit_date_days_late
      FROM vw_wra_first_fu_visit_overview v2
               LEFT JOIN vw_wra_fourth_fu_visit_overview v5 ON v2.record_id = v5.record_id
      WHERE v2.record_id NOT IN (SELECT f2.record_id FROM vw_wra_second_fu_visit_overview f2)
        AND v2.record_id NOT IN (SELECT f3.record_id FROM vw_wra_third_fu_visit_overview f3)
        AND v2.record_id NOT IN ((SELECT v5.record_id
                                  FROM vw_wra_fourth_fu_visit_overview v5
                                  WHERE v5.visit_status IN (
                                                            'Yes', 'Available', 'Migrated', 'Extended-Absence',
                                                            'No, Extended Absence', 'Physical/Mental-Impairment',
                                                            'No, has migrated', 'Untraceable',
                                                            'Other {wra_fu_is_wra_avail_other_f4}'
                                      )))
        AND DATEDIFF(CURRENT_DATE, DATE_ADD(v2.visit_date, INTERVAL ((90) + (90) + 90) DAY)) > -21
        AND DATEDIFF(CURRENT_DATE, DATE_ADD(v2.visit_date, INTERVAL ((90) + (90) + 90) DAY)) <= 21
      UNION
-- Dateset 3: 2nd FU visits due for 4th FU appointment.
      SELECT v3.record_id,
             v3.screening_id,
             v3.wra_ptid,
             COALESCE(v5.visit_date, v3.visit_date)                                        as last_visit_date,
             IF(v5.attempt_number IS NULL OR v5.attempt_number = '', 0, v5.attempt_number) as attempt_number,
             DATE_ADD(v3.visit_date, INTERVAL (90 + 90) DAY)                               as follow_up_4_visit_date,
             DATE_ADD(v3.visit_date, INTERVAL (90 + (90 + 21)) DAY)                        as follow_up_4_last_visit_date,
             DATEDIFF(CURRENT_DATE,
                      DATE_ADD(v3.visit_date, INTERVAL (90 + 90)
                               DAY))                                                       as follow_up_4_visit_date_days_late
      FROM vw_wra_second_fu_visit_overview v3
               LEFT JOIN vw_wra_fourth_fu_visit_overview v5 ON v3.record_id = v5.record_id
      WHERE v3.record_id NOT IN (SELECT f3.record_id FROM vw_wra_third_fu_visit_overview f3)
        AND v3.record_id NOT IN (SELECT v5.record_id
                                 FROM vw_wra_fourth_fu_visit_overview v5
                                 WHERE v5.visit_status IN (
                                                           'Yes', 'Available', 'Migrated', 'Extended-Absence',
                                                           'No, Extended Absence', 'Physical/Mental-Impairment',
                                                           'No, has migrated', 'Untraceable',
                                                           'Other {wra_fu_is_wra_avail_other_f4}'
                                     ))
        AND DATEDIFF(CURRENT_DATE, DATE_ADD(v3.visit_date, INTERVAL (90 + 90) DAY)) > -21
        AND DATEDIFF(CURRENT_DATE, DATE_ADD(v3.visit_date, INTERVAL (90 + 90) DAY)) <= 21
      UNION
-- Dateset 4: 3rd FU visits due for 4th FU appointment.
      SELECT v4.record_id,
             v4.screening_id,
             v4.wra_ptid,
             COALESCE(v5.visit_date, v4.visit_date)                                        as last_visit_date,
             IF(v5.attempt_number IS NULL OR v5.attempt_number = '', 0, v5.attempt_number) as attempt_number,
             DATE_ADD(v4.visit_date, INTERVAL ((90)) DAY)                                  as follow_up_4_visit_date,
             DATE_ADD(v4.visit_date, INTERVAL ((90 + 21)) DAY)                             as follow_up_4_last_visit_date,
             DATEDIFF(CURRENT_DATE,
                      DATE_ADD(v4.visit_date, INTERVAL ((90)) DAY))                        as follow_up_4_visit_date_days_late
      FROM vw_wra_third_fu_visit_overview v4
               LEFT JOIN vw_wra_fourth_fu_visit_overview v5 ON v4.record_id = v5.record_id
      WHERE v4.record_id NOT IN (SELECT v5.record_id
                                 FROM vw_wra_fourth_fu_visit_overview v5
                                 WHERE v5.visit_status IN (
                                                           'Yes', 'Available', 'Migrated', 'Extended-Absence',
                                                           'No, Extended Absence', 'Physical/Mental-Impairment',
                                                           'No, has migrated', 'Untraceable',
                                                           'Other {wra_fu_is_wra_avail_other_f4}'
                                     ))
        AND DATEDIFF(CURRENT_DATE, DATE_ADD(v4.visit_date, INTERVAL ((90)) DAY)) > -21
        AND DATEDIFF(CURRENT_DATE, DATE_ADD(v4.visit_date, INTERVAL ((90)) DAY)) <= 21) fu3
ORDER BY fu3.follow_up_4_visit_date_days_late DESC;


