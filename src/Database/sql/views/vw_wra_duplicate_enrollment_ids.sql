CREATE OR REPLACE ALGORITHM = MERGE VIEW wra_duplicate_enrollment_ids
AS
SELECT enr.id,
       enr.wra_enrollment_id,
       enr.record_id,
       enr.hh_scrn_num_obsloc         as screening_id,
       enr.hhe_hh_member_id           as member_id,
       enr.scrn_obsstdat              as screening_date,
       CONCAT_WS(' ',
                 enr.fname_scorres,
                 enr.mname_scorres,
                 enr.lname_scorres)   as wra_name,
       enr.wra_ptid,
       enr.wra_enr_interviewer_obsloc as wra_ra_username,
       COALESCE(enr.wra_ra_name,
                enr.wra_enr_nok_ra_name,
                enr.wra_enr_nok_lts_ra_name,
                enr.wra_lts_ra_name)  as wra_ra_name,
       enr_dup.enrollment_id_count       dup_enr_id_count
FROM wra_enrollment enr
         INNER JOIN (SELECT wra_enr.wra_enrollment_id,
                            COUNT(wra_enr.wra_enrollment_id) as enrollment_id_count
                     FROM wra_enrollment wra_enr
                     GROUP BY wra_enr.wra_enrollment_id
                     HAVING COUNT(wra_enr.wra_enrollment_id) > 1) as enr_dup
                    ON enr.wra_enrollment_id = enr_dup.wra_enrollment_id
GROUP BY enr.wra_enrollment_id, enr.hh_scrn_num_obsloc
ORDER BY enr.wra_enrollment_id, enr.hh_scrn_num_obsloc;
