/**
 * List of WRA's due for Second Follow-Up Visit.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 09.09.24
 * @since 0.0.1
 * @alias WRA Second FU 2 Visit Due Schedule
 */
CREATE OR REPLACE ALGORITHM = MERGE VIEW vw_wra_second_fu_schedule
AS
-- WRA who missed first and second follow-up, using baseline enrollment date to calculate next followup visit date
SELECT v1.record_id,
       v1.screening_id,
       v1.wra_ptid,
       v1.screening_date                                             as last_visit_date,
       DATE_ADD(v1.screening_date, INTERVAL (90 + 90) DAY)           as follow_up_2_visit_date,
       DATE_ADD(v1.screening_date, INTERVAL (90 + (90 + 21)) DAY)    as follow_up_2_last_visit_date,
       DATEDIFF(CURRENT_DATE,
                DATE_ADD(v1.screening_date, INTERVAL (90 + 90) DAY)) as follow_up_2_visit_date_days_late
FROM vw_wra_baseline_visit_overview v1
WHERE v1.record_id NOT IN (SELECT v2.record_id FROM vw_wra_first_fu_visit_overview v2)
  AND v1.record_id NOT IN (SELECT v3.record_id FROM vw_wra_second_fu_visit_overview v3)
  AND DATEDIFF(CURRENT_DATE, DATE_ADD(v1.screening_date, INTERVAL (90 + 90) DAY)) < 21
  AND DATEDIFF(CURRENT_DATE, DATE_ADD(v1.screening_date, INTERVAL (90 + 90) DAY)) > -21
UNION
SELECT v2.record_id,
       v2.screening_id,
       v2.wra_ptid,
       v2.visit_date                                          as last_visit_date,
       DATE_ADD(v2.visit_date, INTERVAL ((90)) DAY)           as follow_up_2_visit_date,
       DATE_ADD(v2.visit_date, INTERVAL ((90 + 21)) DAY)      as follow_up_2_last_visit_date,
       DATEDIFF(CURRENT_DATE,
                DATE_ADD(v2.visit_date, INTERVAL ((90)) DAY)) as follow_up_2_visit_date_days_late
FROM vw_wra_first_fu_visit_overview v2
WHERE v2.record_id NOT IN (SELECT v3.record_id FROM vw_wra_second_fu_visit_overview v3)
  AND DATEDIFF(CURRENT_DATE, DATE_ADD(v2.visit_date, INTERVAL (90) DAY)) > -21
  AND DATEDIFF(CURRENT_DATE, DATE_ADD(v2.visit_date, INTERVAL (90) DAY)) <= 21;