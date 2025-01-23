DROP TABLE IF EXISTS arch_etl_db.crt_wra_visit_1_overview;
CREATE TABLE arch_etl_db.crt_wra_visit_1_overview
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
CREATE UNIQUE INDEX visit_1_wra_ptid_idx ON arch_etl_db.crt_wra_visit_1_overview (wra_ptid);

INSERT INTO arch_etl_db.crt_wra_visit_1_overview(record_id,
                                                 wra_ptid,
                                                 member_id,
                                                 screening_id,
                                                 age,
                                                 ra,
                                                 visit_number,
                                                 visit_name,
                                                 visit_date,
                                                 visit_outcome)
SELECT v1.record_id,
       v1.wra_ptid,
       v1.member_id,
       v1.screening_id,
       v1.age,
       v1.ra,
       v.visit_number,
       v.visit_name,
       v1.screening_date as visit_date,
       'Enrolled'
FROM (SELECT wra_enr.record_id,
             ROW_NUMBER() OVER (
                 PARTITION BY wra_enr.record_id
                 ORDER BY wra_enr.redcap_repeat_instance DESC ) as visit_id,
             wra_enr.redcap_event_name                          as visit_name,
             TRIM(wra_enr.wra_ptid)                             as wra_ptid,
             wra_enr.hhe_hh_member_id                           as member_id,
             TRIM(wra_enr.hh_scrn_num_obsloc)                   as screening_id,
             wra_enr.scrn_obsstdat                              as screening_date,
             TRIM(wra_enr.wra_ra_name)                          as ra,
             wra_enr.wra_age                                    as age
      FROM wra_forms_repeating_instruments wra_enr
      WHERE wra_enr.wra_age > 0) v1
         LEFT JOIN visit v ON v1.visit_name = v.visit_name
WHERE v1.visit_id = 1
ORDER BY v1.screening_date
        DESC;

