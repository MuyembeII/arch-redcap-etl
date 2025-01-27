/**
 * /----------------+___| List of WRA's due for the fourth follow-up visit (FU 4) |___+-----------------\
 *  Due to visits that are lost to follow-up(LTFU), a combined dataset of appointments from all
 *  previous visit will be of inclusion for scheduling.                                                 |*
 *                                                                                                      ^
 * @author : Gift Jr | Dowc | <muyembegift@gmail.com> | 24.01.25                                        |*
 * @since  : 0.0.1                                                                                      ):
 * @alias  : WRA Fifth FU Visit Due Schedule                                                            (;
  \_______---______/--------------------------------------------------------------------\______---______/
 */
CREATE OR REPLACE ALGORITHM = MERGE VIEW vw_wra_fifth_fu_schedule
AS
-- Dateset 1: Baseline visit without any recorded appointment for 1st, 2nd, 3rd and 4th FU's.
SELECT *
FROM (SELECT v1.record_id,
             v1.screening_id,
             v1.wra_ptid,
             v.visit_alias                                                            as visit_name,
             v.visit_number,
             v1.visit_date                                                            as last_visit_date,
             0                                                                        as attempt_number,
             DATE_ADD(v1.visit_date, INTERVAL (90 + 90 + 90 + 90 + 90) DAY)           as first_fu_visit_date,
             DATE_ADD(v1.visit_date, INTERVAL ((90 + 90 + 90 + 90 + 90) + 21)
                      DAY)                                                            as last_fu_visit_date,
             DATEDIFF(CURRENT_DATE,
                      DATE_ADD(v1.visit_date, INTERVAL (90 + 90 + 90 + 90 + 90) DAY)) as days_late
      FROM crt_wra_visit_1_overview v1
               LEFT JOIN visit v ON v1.visit_number = v.visit_number
      WHERE v1.record_id NOT IN (SELECT f1.record_id FROM crt_wra_visit_2_overview f1)
        AND v1.record_id NOT IN (SELECT f2.record_id FROM crt_wra_visit_3_overview f2)
        AND v1.record_id NOT IN (SELECT f3.record_id FROM crt_wra_visit_4_overview f3)
        AND v1.record_id NOT IN (SELECT f4.record_id FROM crt_wra_visit_5_overview f4)
        AND DATEDIFF(CURRENT_DATE, DATE_ADD(v1.visit_date, INTERVAL (90 + 90 + 90 + 90 + 90) DAY)) >= -21
        AND DATEDIFF(CURRENT_DATE, DATE_ADD(v1.visit_date, INTERVAL (90 + 90 + 90 + 90 + 90) DAY)) <= 21
      UNION
-- Dateset 2: 1st FU visits due for 5th FU appointment.
      SELECT v2.record_id,
             v2.screening_id,
             v2.wra_ptid,
             v.visit_alias                                                           as visit_name,
             v.visit_number,
             v2.visit_date                                                           as last_visit_date,
             0                                                                       as attempt_number,
             DATE_ADD(v2.visit_date, INTERVAL (90 + 90 + 90 + 90) DAY)               as first_fu_visit_date,
             DATE_ADD(v2.visit_date, INTERVAL ((90 + 90 + 90 + 90) + (90 + 21)) DAY) as last_fu_visit_date,
             DATEDIFF(CURRENT_DATE,
                      DATE_ADD(v2.visit_date, INTERVAL (90 + 90 + 90 + 90) DAY))     as days_late
      FROM crt_wra_visit_2_overview v2
               LEFT JOIN visit v ON v2.visit_number = v.visit_number
      WHERE v2.record_id NOT IN (SELECT f2.record_id FROM crt_wra_visit_3_overview f2)
        AND v2.record_id NOT IN (SELECT f3.record_id FROM crt_wra_visit_4_overview f3)
        AND v2.record_id NOT IN (SELECT f4.record_id FROM crt_wra_visit_5_overview f4)
        AND DATEDIFF(CURRENT_DATE, DATE_ADD(v2.visit_date, INTERVAL (90 + 90 + 90 + 90) DAY)) >= -21
        AND DATEDIFF(CURRENT_DATE, DATE_ADD(v2.visit_date, INTERVAL (90 + 90 + 90 + 90) DAY)) <= 21
      UNION
-- Dateset 3: 2nd FU visits due for 5th FU appointment.
      SELECT v3.record_id,
             v3.screening_id,
             v3.wra_ptid,
             v.visit_alias                                                  as visit_name,
             v.visit_number,
             v3.visit_date                                                  as last_visit_date,
             0                                                              as attempt_number,
             DATE_ADD(v3.visit_date, INTERVAL (90 + 90 + 90) DAY)           as first_fu_visit_date,
             DATE_ADD(v3.visit_date, INTERVAL (90 + 90 + (90 + 21)) DAY)    as last_fu_visit_date,
             DATEDIFF(CURRENT_DATE,
                      DATE_ADD(v3.visit_date, INTERVAL (90 + 90 + 90) DAY)) as days_late
      FROM crt_wra_visit_3_overview v3
               LEFT JOIN visit v ON v3.visit_number = v.visit_number
      WHERE v3.record_id NOT IN (SELECT f3.record_id FROM crt_wra_visit_4_overview f3)
        AND v3.record_id NOT IN (SELECT v5.record_id FROM crt_wra_visit_5_overview v5)
        AND DATEDIFF(CURRENT_DATE, DATE_ADD(v3.visit_date, INTERVAL (90 + 90 + 90) DAY)) >= -21
        AND DATEDIFF(CURRENT_DATE, DATE_ADD(v3.visit_date, INTERVAL (90 + 90 + 90) DAY)) <= 21
      UNION
-- Dateset 4: 3rd FU visits due for 5th FU appointment.
      SELECT v4.record_id,
             v4.screening_id,
             v4.wra_ptid,
             v.visit_alias                                               as visit_name,
             v.visit_number,
             v4.visit_date                                               as last_visit_date,
             0                                                           as attempt_number,
             DATE_ADD(v4.visit_date, INTERVAL ((90 + 90)) DAY)           as first_fu_visit_date,
             DATE_ADD(v4.visit_date, INTERVAL ((90 + 90 + 21)) DAY)      as last_fu_visit_date,
             DATEDIFF(CURRENT_DATE,
                      DATE_ADD(v4.visit_date, INTERVAL ((90 + 90)) DAY)) as days_late
      FROM crt_wra_visit_4_overview v4
               LEFT JOIN visit v ON v4.visit_number = v.visit_number
      WHERE v4.record_id NOT IN (SELECT v4.record_id FROM crt_wra_visit_5_overview f4)
        AND DATEDIFF(CURRENT_DATE, DATE_ADD(v4.visit_date, INTERVAL ((90)) DAY)) >= -21
        AND DATEDIFF(CURRENT_DATE, DATE_ADD(v4.visit_date, INTERVAL ((90)) DAY)) <= 21
      UNION
      -- Dateset 4: 4th FU visits due for 5th FU appointment.
      SELECT v5.record_id,
             v5.screening_id,
             v5.wra_ptid,
             v.visit_alias                                        as visit_name,
             v.visit_number,
             v5.visit_date                                        as last_visit_date,
             0                                                    as attempt_number,
             DATE_ADD(v5.visit_date, INTERVAL (90) DAY)           as first_fu_visit_date,
             DATE_ADD(v5.visit_date, INTERVAL (90 + 21) DAY)      as last_fu_visit_date,
             DATEDIFF(CURRENT_DATE,
                      DATE_ADD(v5.visit_date, INTERVAL (90) DAY)) as days_late
      FROM crt_wra_visit_5_overview v5
               LEFT JOIN visit v ON v5.visit_number = v.visit_number
      WHERE DATEDIFF(CURRENT_DATE, DATE_ADD(v5.visit_date, INTERVAL (90) DAY)) >= -21
        AND DATEDIFF(CURRENT_DATE, DATE_ADD(v5.visit_date, INTERVAL (90) DAY)) <= 21) fu5
WHERE fu5.record_id NOT IN (SELECT sc.record_id FROM wra_study_closure sc)
ORDER BY fu5.days_late DESC;