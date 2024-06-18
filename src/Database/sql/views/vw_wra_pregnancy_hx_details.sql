/**
 * List of WRA Pregnancy Details.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 19.03.24
 * @since 0.0.1
 * @alias WRA Pregnancy Details
 */
CREATE OR REPLACE ALGORITHM = MERGE VIEW vw_wra_pregnancy_hx_details_v1
AS
SELECT DISTINCT loc.record_id,
                TRIM(loc.screening_id)                as screening_id,
                loc.member_id,
                loc.screening_date                    as date_of_enrollment,
                TRIM(loc.wra_ptid)                    as wra_ptid,
                REPLACE(CONCAT_WS(' ', TRIM(loc.first_name), TRIM(loc.middle_name), TRIM(loc.last_name)), '  ',
                        ' ')                          as wra_name,
                loc.age                               as age,
                (IFNULL(pos.pho_num_preg_rporres, 0)) as pregnancy_count,
                (IFNULL(pos.ph_live_rporres, 0))      as past_live_birth_count,
                (IFNULL(pos.ph_loss_rporres, 0))      as past_loss_count,
                (IFNULL(pos.ph_bs_rporres, 0))        as past_miscarraige_count,
                (IFNULL(pos.stlb_num_rporres, 0))     as past_still_birth_count
FROM vw_wra_enrolled loc
         LEFT JOIN wra_pregnancy_overview_and_surveillance pos on loc.record_id = pos.record_id
WHERE loc.age > 0
  AND pos.ph_prev_rporres IS NOT NULL
ORDER BY loc.screening_id;

