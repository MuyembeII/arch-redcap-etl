DROP TABLE IF EXISTS arch_etl_db.crt_wra_missed_visit_2_overview;
CREATE TABLE arch_etl_db.crt_wra_missed_visit_2_overview
(
    record_id                        BIGINT      NOT NULL,
    screening_id                     VARCHAR(14) NOT NULL,
    wra_ptid                         VARCHAR(6)  NOT NULL,
    last_visit_date                  DATE,
    PRIMARY KEY (record_id)
);
CREATE UNIQUE INDEX v2_missed_record_id_idx ON arch_etl_db.crt_wra_missed_visit_2_overview (record_id);
CREATE INDEX v2_missed_screening_id_idx ON arch_etl_db.crt_wra_missed_visit_2_overview (screening_id);
CREATE INDEX v2_missed_wra_ptid_idx ON arch_etl_db.crt_wra_missed_visit_2_overview (wra_ptid);
CREATE INDEX v2_missed_last_visit_date_idx ON arch_etl_db.crt_wra_missed_visit_2_overview (last_visit_date);
