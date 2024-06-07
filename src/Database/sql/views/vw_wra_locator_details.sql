/**
 * List of completed WRA first follow up visits.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 19.03.24
 * @since 0.0.1
 * @alias WRA Follow Up Visit 1
 */
CREATE OR REPLACE ALGORITHM = MERGE VIEW vw_wra_locator_details
AS
SELECT DISTINCT loc.record_id,
                TRIM(loc.hh_scrn_num_obsloc)                                                              as screening_id,
                loc.hhe_hh_member_id                                                                      as member_id,
                loc.scrn_obsstdat                                                                         as date_of_enrollment,
                TRIM(loc.wra_ptid) as wra_ptid,
                CONCAT_WS(' ', TRIM(enr.fname_scorres), TRIM(enr.mname_scorres), TRIM(enr.lname_scorres)) as name,
                enr.wra_age,
                get_WRA_FirstContactNumber(loc.record_id) as first_contact_number,
                get_WRA_FirstContactOwner(loc.wra_ptid) as first_contact_number_owner,
                loc.loc_who_is_caller as first_contact_number_caller_id,
                get_WRA_SecondContactNumber(loc.record_id) as second_contact_number,
                get_WRA_SecondContactOwner(loc.wra_ptid) as second_contact_number_owner,
                loc.loc_who_is_caller_2 as second_contact_number_caller_id
FROM wra_locator loc
         JOIN wra_enrollment enr ON loc.wra_ptid = enr.wra_ptid
ORDER BY loc.hh_scrn_num_obsloc

