/**
 * WRA's Follow-Up visit master overview.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 09.01.25
 * @since 0.0.1
 * @alias WRA FU Visit Overview
 */
CREATE OR REPLACE ALGORITHM = MERGE VIEW vw_wra_fu_visit_overview
AS
SELECT *
FROM (SELECT o.record_id,
             o.visit_number,
             v.visit_alias as visit_name,
             o.screening_id,
             o.wra_ptid,
             o.ra,
             o.visit_date,
             o.attempt_number,
             o.visit_status,
             o.enrolled_in_zapps,
             o.zapps_ptid
      FROM vw_wra_first_fu_visit_overview o
               JOIN visit v ON v.visit_number = o.visit_number
      UNION
      SELECT o.record_id,
             o.visit_number,
             v.visit_alias as visit_name,
             o.screening_id,
             o.wra_ptid,
             o.ra,
             o.visit_date,
             o.attempt_number,
             o.visit_status,
             o.enrolled_in_zapps,
             o.zapps_ptid
      FROM vw_wra_second_fu_visit_overview o
               JOIN visit v ON v.visit_number = o.visit_number
      UNION
      SELECT o.record_id,
             o.visit_number,
             v.visit_alias as visit_name,
             o.screening_id,
             o.wra_ptid,
             o.ra,
             o.visit_date,
             o.attempt_number,
             o.visit_status,
             o.enrolled_in_zapps,
             o.zapps_ptid
      FROM vw_wra_third_fu_visit_overview o
               JOIN visit v ON v.visit_number = o.visit_number
      UNION
      SELECT o.record_id,
             o.visit_number,
             v.visit_alias as visit_name,
             o.screening_id,
             o.wra_ptid,
             o.ra,
             o.visit_date,
             o.attempt_number,
             o.visit_status,
             o.enrolled_in_zapps,
             o.zapps_ptid
      FROM vw_wra_fourth_fu_visit_overview o
               JOIN visit v ON v.visit_number = o.visit_number) v
ORDER BY v.visit_date DESC;

