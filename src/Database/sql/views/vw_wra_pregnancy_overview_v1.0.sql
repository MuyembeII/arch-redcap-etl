/**
 * List of WRA Pregnancy Details for Visit 1.0.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 26.01.25
 * @since 0.0.1
 * @alias WRA Pregnancy Details 1.0
 */
CREATE OR REPLACE ALGORITHM = MERGE VIEW vw_wra_pregnancy_overview_v1
AS
SELECT po_v1.*, poc.upt_result, poc.pregnancy_id, poc.bmi_result
FROM crt_wra_visit_1_pregnancy_overview po_v1
         LEFT JOIN crt_wra_point_of_collection_overview poc ON po_v1.record_id = poc.record_id
WHERE po_v1.visit_number = poc.visit_number;