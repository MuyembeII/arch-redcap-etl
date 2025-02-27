DROP TABLE IF EXISTS arch_etl_db.crt_wra_missed_visit_5_overview;
CREATE TABLE arch_etl_db.crt_wra_missed_visit_5_overview
(
    record_id                        BIGINT      NOT NULL,
    screening_id                     VARCHAR(14) NOT NULL,
    wra_ptid                         VARCHAR(6)  NOT NULL,
    last_visit_date                  DATE,
    follow_up_4_visit_date           DATE,
    follow_up_4_last_visit_date      DATE,
    follow_up_4_visit_date_days_late SMALLINT,
    PRIMARY KEY (record_id)
);
CREATE UNIQUE INDEX v5_missed_record_id_idx ON arch_etl_db.crt_wra_missed_visit_5_overview (record_id);
CREATE INDEX v5_missed_screening_id_idx ON arch_etl_db.crt_wra_missed_visit_5_overview (screening_id);
CREATE INDEX v5_missed_wra_ptid_idx ON arch_etl_db.crt_wra_missed_visit_5_overview (wra_ptid);
CREATE INDEX v5_missed_last_visit_date_idx ON arch_etl_db.crt_wra_missed_visit_5_overview (last_visit_date);
CREATE INDEX v5_missed_follow_up_4_visit_date_idx ON arch_etl_db.crt_wra_missed_visit_5_overview (follow_up_4_visit_date);
CREATE INDEX v5_missed_follow_up_4_last_visit_date_idx ON arch_etl_db.crt_wra_missed_visit_5_overview (follow_up_4_last_visit_date);
CREATE INDEX v5_missed_follow_up_4_visit_date_days_late_idx ON arch_etl_db.crt_wra_missed_visit_5_overview (follow_up_4_visit_date_days_late);
