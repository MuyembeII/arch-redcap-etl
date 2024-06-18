/**
 * List of WRA Locator Details.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 19.03.24
 * @since 0.0.1
 * @alias WRA Locator Details
 */
CREATE OR REPLACE ALGORITHM = MERGE VIEW vw_wra_locator_details
AS
SELECT DISTINCT loc.record_id,
                TRIM(loc.screening_id)      as screening_id,
                loc.member_id,
                loc.screening_date          as date_of_enrollment,
                TRIM(loc.wra_ptid)          as wra_ptid,
                REPLACE(CONCAT_WS(' ', TRIM(loc.first_name), TRIM(loc.middle_name), TRIM(loc.last_name)), '  ',
                        ' ')                as wra_name,
                loc.age                     as age,
                loc_fc_num                  as first_contact_number,
                wfri.loc_pn_belongs_label   as first_contact_number_owner,
                wfri.loc_who_is_caller      as first_contact_number_caller_id,
                wfri.loc_sc_num             as second_contact_number,
                wfri.loc_pn_belongs_2_label as second_contact_number_owner,
                wfri.loc_who_is_caller_2    as second_contact_number_caller_id
FROM vw_wra_baseline_visit_overview loc
         LEFT JOIN wra_forms_repeating_instruments wfri on loc.record_id = wfri.record_id
WHERE loc.age > 0
  AND wfri.loc_fc_num IS NOT NULL
ORDER BY loc.screening_id;

