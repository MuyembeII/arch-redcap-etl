/**
 * List of WRA POC.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 04.09.24
 * @since 0.0.1
 * @alias WRA POC List
 */
CREATE OR REPLACE ALGORITHM = MERGE VIEW vw_wra_zapps_outcomes
AS
SELECT zr.*, vzct.contact_count, vzct.contact_outcome, vzct.new_appointment_date
FROM vw_wra_zapps_referrals zr
LEFT JOIN vw_zapps_contact_tracker vzct on zr.wra_ptid = vzct.wra_ptid

