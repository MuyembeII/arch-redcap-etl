DROP TABLE IF EXISTS arch_etl_db.crt_wra_visit_3_overview;
CREATE TABLE arch_etl_db.crt_wra_visit_3_overview
(
    record_id     INT            NOT NULL PRIMARY KEY,
    wra_ptid      VARCHAR(6)     NOT NULL,
    member_id     SMALLINT       NOT NULL,
    screening_id  VARCHAR(14)    NOT NULL,
    age           SMALLINT       NOT NULL,
    ra            VARCHAR(32)    NOT NULL,
    visit_number  DECIMAL(10, 1) NOT NULL,
    visit_name    VARCHAR(255)   NOT NULL,
    visit_date    DATE           NOT NULL,
    visit_outcome TINYTEXT
);
CREATE INDEX visit_3_wra_ptid_idx ON arch_etl_db.crt_wra_visit_3_overview (wra_ptid);

INSERT INTO arch_etl_db.crt_wra_visit_3_overview(record_id,
                                                 wra_ptid,
                                                 member_id,
                                                 screening_id,
                                                 age,
                                                 ra,
                                                 visit_number,
                                                 visit_name,
                                                 visit_date,
                                                 visit_outcome)
SELECT v2.record_id,
       v2.wra_ptid,
       v2.member_id,
       v2.screening_id,
       v1.age,
       v2.ra,
       v.visit_number,
       v.visit_alias,
       v2.visit_date,
       CASE
           WHEN v2.is_wra_available = 1 AND v2.attempt_number <= 3 THEN 'Completed'
           WHEN v2.is_wra_available = 2 AND v2.attempt_number < 3 THEN 'Incomplete'
           WHEN v2.is_wra_available = 2 AND v2.attempt_number = 3 THEN 'Untraceable'
           WHEN v2.is_wra_available = 3 AND v2.attempt_number <= 3 THEN 'Extended-Absence'
           WHEN v2.is_wra_available = 4 AND v2.attempt_number < 3 THEN 'Physical/Mental-Impairment'
           WHEN v2.is_wra_available = 6 AND v2.attempt_number <= 3
               THEN CONCAT_WS(' - ', 'Other', v2.is_wra_available_oth_label)
           WHEN v2.is_wra_available = 7 AND v2.attempt_number <= 3 THEN 'Migrated'
           WHEN v2.is_wra_available = 8 THEN 'Untraceable'
           ELSE v2.is_wra_available_label
           END as visit_outcome
FROM (SELECT fu3.root_id                                                              as id,
             fu3.record_id,
             ROW_NUMBER() OVER (
                 PARTITION BY fu3.record_id ORDER BY fu3.redcap_repeat_instance DESC) as visit_id,
             fu3.scrn_obsstdat_f2                                                     as visit_date,
             fu3.hhe_hh_member_id_f2                                                  as member_id,
             fu3.redcap_repeat_instance                                               as attempt_number,
             fu3.redcap_event_name                                                    as visit_name,
             fu3.wra_enr_interviewer_obsloc_f2                                        as ra,
             fu3.wra_fu_wra_ptid_f2                                                   as wra_ptid,
             fu3.hh_scrn_num_obsloc_f2                                                as screening_id,
             fu3.wra_enr_pp_avail_f2                                                  as is_wra_available,
             fu3.wra_enr_pp_avail_f2_label                                            as is_wra_available_label,
             fu3.wra_fu_is_wra_avail_other_f2                                         as is_wra_available_oth_label
      FROM wra_follow_up_visit_2_repeating_instruments fu3) v2
         LEFT JOIN visit v ON v2.visit_name = v.visit_name
         JOIN crt_wra_visit_1_overview v1 ON v2.wra_ptid = v1.wra_ptid
WHERE v2.visit_id = 1
ORDER BY v2.visit_date DESC;
