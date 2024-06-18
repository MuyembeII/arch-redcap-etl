/**
 * ZAPPS Contact Tracker.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 24.09.24
 * @since 0.0.1
 * @alias Contact Tracker
 */
CREATE OR REPLACE ALGORITHM = MERGE VIEW vw_zapps_encounters
AS
SELECT e.id,
       e.wra_ptid,
       e.present,
       e.prescreening_date,
       e.zapps_ptid,
       e.iup,
       e.screen_proceed,
       e.prescreening_outcome,
       e.date_of_outcome
FROM (SELECT ze.id,
             SUBSTRING(ze.arch_ptid, 1, 6)                                                           as wra_ptid,
             ROW_NUMBER() OVER (
                 PARTITION BY SUBSTRING(ze.arch_ptid, 1, 6) ORDER BY ze.redcap_repeat_instance DESC) as visit_id,
             ze.redcap_repeat_instance,
             ze.present,
             ze.ps_date as prescreening_date,
             ze.zapps_ptid,
             ze.iup,
             ze.screen_proceed,
             ze.ps_outcome                                                                         as prescreening_outcome,
             ze.outcome_date                                                                         as date_of_outcome
      FROM zapps_encounters ze) e
WHERE e.visit_id = 1
ORDER BY e.prescreening_date DESC;

