/**
 * List of completed WRA first follow up visits.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 19.03.24
 * @since 0.0.1
 * @alias WRA Follow Up Visit 1
 */
CREATE OR REPLACE ALGORITHM = MERGE VIEW vw_wra_follow_visit_1
AS
SELECT enr.record_id,
       enr.hh_scrn_num_obsloc as screening_id,
       enr.scrn_obsstdat as date_of_enrollment,
       enr.wra_ptid,
       enr.wra_ra_name enrolled_by,
       fu1.wra_fu_visit_date as follow_up_visit_date,
       DATE_ADD(enr.scrn_obsstdat, INTERVAL 90 DAY) AS next_visit_date,
       fu1.wra_fu_interviewer_obsloc as followed_up_by
FROM wra_enrollment enr
         JOIN wra_follow_up_visit_1 fu1 ON enr.record_id = fu1.record_id
WHERE enr.wra_age > 0;

