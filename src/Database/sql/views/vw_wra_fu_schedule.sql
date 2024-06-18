/**
 * /----------------+___| List of WRA's Follow-Up Schedules |___+-----------------\
 *  The baseline visit date is the entry point for all subsequent visits.                               |*
 *                                                                                                      ^
 * @author : Gift Jr | Dowc | <muyembegift@gmail.com> | 01.10.24                                        |*
 * @since  : 0.0.1                                                                                      ):
 * @alias  : WRA FU Schedule                                                            (;
  \_______---______/--------------------------------------------------------------------\______---______/
 */
CREATE OR REPLACE ALGORITHM = MERGE VIEW vw_wra_fu_schedule
AS
SELECT
       enr.record_id,
       enr.wra_ptid,
       enr.screening_id,
       enr.screening_date,
       DATE_ADD(enr.screening_date, INTERVAL 90 DAY) as fu_1_visit_date,
       DATE_ADD(enr.screening_date, INTERVAL (90 + (90 + 21)) DAY) as fu_2_visit_date,
       DATE_ADD(enr.screening_date, INTERVAL (90 + (90 + 21) + 90) DAY) as fu_3_visit_date,
       DATE_ADD(enr.screening_date, INTERVAL (90 + (90 + 21) + (90 + 21) + 90) DAY) as fu_4_visit_date,
       DATE_ADD(enr.screening_date, INTERVAL (90 + (90 + 21) + (90 + 21) + (90 + 21) + 90) DAY) as fu_5_visit_date,
       DATE_ADD(enr.screening_date, INTERVAL (90 + (90 + 21) + (90 + 21) + (90 + 21) + (90 + 21) + 90) DAY) as fu_6_visit_date
FROM vw_wra_baseline_visit_overview enr
ORDER BY enr.screening_date

