DROP TABLE IF EXISTS arch_etl_db.crt_wra_pending_visit_4_overview;
CREATE TABLE arch_etl_db.crt_wra_pending_visit_4_overview
(
    record_id                        BIGINT      NOT NULL,
    screening_id                     VARCHAR(14) NOT NULL,
    wra_ptid                         VARCHAR(6)  NOT NULL,
    last_visit_date                  DATE,
    follow_up_3_visit_date           DATE,
    follow_up_3_last_visit_date      DATE,
    follow_up_3_visit_date_days_late SMALLINT,
    PRIMARY KEY (record_id)
);
CREATE UNIQUE INDEX v4_pending_record_id_idx ON arch_etl_db.crt_wra_pending_visit_4_overview (record_id);
CREATE INDEX v4_pending_screening_id_idx ON arch_etl_db.crt_wra_pending_visit_4_overview (screening_id);
CREATE INDEX v4_pending_wra_ptid_idx ON arch_etl_db.crt_wra_pending_visit_4_overview (wra_ptid);
CREATE INDEX v4_pending_last_visit_date_idx ON arch_etl_db.crt_wra_pending_visit_4_overview (last_visit_date);
CREATE INDEX v4_pending_follow_up_3_visit_date_idx ON arch_etl_db.crt_wra_pending_visit_4_overview (follow_up_3_visit_date);
CREATE INDEX v4_pending_follow_up_3_last_visit_date_idx ON arch_etl_db.crt_wra_pending_visit_4_overview (follow_up_3_last_visit_date);
CREATE INDEX v4_pending_follow_up_3_visit_date_days_late_idx ON arch_etl_db.crt_wra_pending_visit_4_overview (follow_up_3_visit_date_days_late);
