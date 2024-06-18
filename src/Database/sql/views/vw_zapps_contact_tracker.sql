/**
 * ZAPPS Contact Tracker.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 24.09.24
 * @since 0.0.1
 * @alias Contact Tracker
 */
CREATE OR REPLACE ALGORITHM = MERGE VIEW vw_zapps_contact_tracker
AS
SELECT vct.id,
       vct.wra_ptid,
       vct.contact_count,
       vct.contact_date,
       vct.contact_outcome,
       vct.new_appointment_date
FROM (SELECT ct.id,
             SUBSTRING(ct.arch_ptid, 1, 6)                                                           as wra_ptid,
             ROW_NUMBER() OVER (
                 PARTITION BY SUBSTRING(ct.arch_ptid, 1, 6) ORDER BY ct.redcap_repeat_instance DESC) as visit_id,
             ct.redcap_repeat_instance,
             ct.contact_count,
             ct.contact_date,
             ct.contact_outcome,
             ct.new_apt_date                                                                         as new_appointment_date
      FROM zapps_wra_tracker ct) vct
WHERE vct.visit_id = 1
ORDER BY vct.contact_date DESC;

