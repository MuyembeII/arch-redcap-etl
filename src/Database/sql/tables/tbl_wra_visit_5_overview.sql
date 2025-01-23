DROP TABLE IF EXISTS arch_etl_db.crt_wra_visit_5_overview;
CREATE TABLE arch_etl_db.crt_wra_visit_5_overview
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
CREATE INDEX visit_5_wra_ptid_idx ON arch_etl_db.crt_wra_visit_5_overview (wra_ptid);

INSERT INTO arch_etl_db.crt_wra_visit_5_overview(record_id,
                                                 wra_ptid,
                                                 member_id,
                                                 screening_id,
                                                 age,
                                                 ra,
                                                 visit_number,
                                                 visit_name,
                                                 visit_date,
                                                 visit_outcome)
SELECT v5.record_id,
       v5.wra_ptid,
       v5.member_id,
       v5.screening_id,
       v1.age,
       v5.ra,
       v.visit_number,
       v.visit_alias,
       v5.visit_date,
       CASE
           WHEN v5.is_wra_available = 1 AND v5.attempt_number <= 3 THEN 'Completed'
           WHEN v5.is_wra_available = 2 AND v5.attempt_number < 3 THEN 'Incomplete'
           WHEN v5.is_wra_available = 2 AND v5.attempt_number = 3 THEN 'Untraceable'
           WHEN v5.is_wra_available = 3 AND v5.attempt_number <= 3 THEN 'Extended-Absence'
           WHEN v5.is_wra_available = 4 AND v5.attempt_number < 3 THEN 'Physical/Mental-Impairment'
           WHEN v5.is_wra_available = 6 AND v5.attempt_number <= 3
               THEN CONCAT_WS(' - ', 'Other', v5.is_wra_available_oth_label)
           WHEN v5.is_wra_available = 7 AND v5.attempt_number <= 3 THEN 'Migrated'
           WHEN v5.is_wra_available = 8 THEN 'Untraceable'
           ELSE v5.is_wra_available_label
           END as visit_outcome
FROM (SELECT fu5.root_id                                                              as id,
             fu5.record_id,
             ROW_NUMBER() OVER (
                 PARTITION BY fu5.record_id ORDER BY fu5.redcap_repeat_instance DESC) as visit_id,
             fu5.wra_fu_visit_date_f4                                                 as visit_date,
             fu5.hhe_hh_member_id_f4                                                  as member_id,
             fu5.redcap_repeat_instance                                               as attempt_number,
             fu5.redcap_event_name                                                    as visit_name,
             fu5.wra_fu_interviewer_obsloc_f4                                         as ra,
             fu5.wra_fu_wra_ptid_f4                                                   as wra_ptid,
             fu5.hh_scrn_num_obsloc_f4                                                as screening_id,
             fu5.wra_fu_pp_avail_f4                                                   as is_wra_available,
             fu5.wra_fu_pp_avail_f4_label                                             as is_wra_available_label,
             fu5.wra_fu_is_wra_avail_other_f4                                         as is_wra_available_oth_label
      FROM wra_follow_up_visit_4_repeating_instruments fu5) v5
         LEFT JOIN visit v ON v5.visit_name = v.visit_name
         JOIN crt_wra_visit_1_overview v1 ON v5.wra_ptid = v1.wra_ptid
WHERE v5.visit_id = 1
ORDER BY v5.visit_date DESC;
