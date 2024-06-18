/**
 * /----------------+___| List of WRA's due for the third follow-up visit (FU 3) |___+-----------------\
 *  Due to visits that are lost to follow-up(LTFU), a combined dataset of appointments from all
 *  previous visit will be of inclusion for scheduling.                                                 |*
 *                                                                                                      ^
 * @author : Gift Jr | Dowc | <muyembegift@gmail.com> | 11.09.24                                        |*
 * @since  : 0.0.1                                                                                      ):
 * @alias  : WRA Third FU Visit Due Schedule                                                            (;
  \_______---______/--------------------------------------------------------------------\______---______/
 */
CREATE OR REPLACE ALGORITHM = MERGE VIEW vw_wra_third_fu_schedule
AS
-- Dateset 1: Baseline visit without any recorded appointment for 1st and 2nd FU's.
SELECT v1.record_id,
       v1.screening_id,
       v1.wra_ptid,
       v1.screening_date                                                             as last_visit_date,
       DATE_ADD(v1.screening_date, INTERVAL ((90) + (90 + 21) + (90)) DAY)           as follow_up_3_visit_date,
       DATE_ADD(v1.screening_date, INTERVAL ((90) + (90 + 21) + (90 + 21)) DAY)      as follow_up_3_last_visit_date,
       DATEDIFF(CURRENT_DATE,
                DATE_ADD(v1.screening_date, INTERVAL ((90) + (90 + 21) + (90)) DAY)) as follow_up_3_visit_date_days_late
FROM vw_wra_baseline_visit_overview v1
WHERE v1.record_id NOT IN (SELECT f1.record_id FROM vw_wra_first_fu_visit_overview f1)
  AND v1.record_id NOT IN (SELECT f2.record_id FROM vw_wra_second_fu_visit_overview f2)
  AND v1.record_id NOT IN ((SELECT v4.record_id FROM vw_wra_third_fu_visit_overview v4))
  AND DATEDIFF(CURRENT_DATE, DATE_ADD(v1.screening_date, INTERVAL ((90) + (90 + 21) + (90)) DAY)) > -21
  AND DATEDIFF(CURRENT_DATE, DATE_ADD(v1.screening_date, INTERVAL ((90) + (90 + 21) + (90)) DAY)) <= 21
UNION
-- Dateset 2: 1st FU visits due for 3rd FU appointment.
SELECT v2.record_id,
       v2.screening_id,
       v2.wra_ptid,
       v2.visit_date                                                                            as last_visit_date,
       DATE_ADD(v2.visit_date, INTERVAL ((90 + 21) + (90)) DAY)                                 as follow_up_3_visit_date,
       DATE_ADD(v2.visit_date, INTERVAL ((90 + 21) + (90 + 21)) DAY)                            as follow_up_3_last_visit_date,
       DATEDIFF(CURRENT_DATE,
                DATE_ADD(v2.visit_date, INTERVAL ((90 + 21) + (90)) DAY))               as follow_up_3_visit_date_days_late
FROM vw_wra_first_fu_visit_overview v2
WHERE v2.record_id NOT IN (SELECT f2.record_id FROM vw_wra_second_fu_visit_overview f2)
  AND v2.record_id NOT IN ((SELECT v4.record_id FROM vw_wra_third_fu_visit_overview v4))
  AND DATEDIFF(CURRENT_DATE, DATE_ADD(v2.visit_date, INTERVAL ((90 + 21) + (90)) DAY)) > -21
  AND DATEDIFF(CURRENT_DATE, DATE_ADD(v2.visit_date, INTERVAL ((90 + 21) + (90)) DAY)) <= 21
UNION
-- Dateset 3: 2nd FU visits due for 3rd FU appointment.
SELECT v3.record_id,
       v3.screening_id,
       v3.wra_ptid,
       v3.visit_date                                                                as last_visit_date,
       DATE_ADD(v3.visit_date, INTERVAL ((90)) DAY)      as follow_up_3_visit_date,
       DATE_ADD(v3.visit_date, INTERVAL ((90 + 21)) DAY) as follow_up_3_last_visit_date,
       DATEDIFF(CURRENT_DATE,
                DATE_ADD(v3.visit_date, INTERVAL ((90))
                         DAY))                                                      as follow_up_3_visit_date_days_late
FROM vw_wra_second_fu_visit_overview v3
WHERE v3.record_id NOT IN (SELECT v4.record_id FROM vw_wra_third_fu_visit_overview v4)
  AND DATEDIFF(CURRENT_DATE, DATE_ADD(v3.visit_date, INTERVAL ((90)) DAY)) > -21
  AND DATEDIFF(CURRENT_DATE, DATE_ADD(v3.visit_date, INTERVAL ((90 + 21)) DAY)) <= 21


