DROP TABLE IF EXISTS arch_etl_db.crt_wra_visit_2_overview;
CREATE TABLE arch_etl_db.crt_wra_visit_2_overview
(
    record_id     BIGINT         NOT NULL,
    alternate_id  BIGINT         NOT NULL,
    wra_ptid      VARCHAR(6)     NULL,
    member_id     SMALLINT       NOT NULL,
    screening_id  VARCHAR(14)    NOT NULL,
    age           SMALLINT       NOT NULL,
    ra            VARCHAR(32)    NOT NULL,
    visit_number  DECIMAL(10, 1) NOT NULL,
    visit_name    VARCHAR(255)   NOT NULL,
    visit_date    DATE           NOT NULL,
    visit_outcome TINYTEXT,
    PRIMARY KEY (record_id, alternate_id)
);
CREATE UNIQUE INDEX visit_2_alternate_id_idx ON arch_etl_db.crt_wra_visit_2_overview (alternate_id);
CREATE INDEX visit_2_wra_ptid_idx ON arch_etl_db.crt_wra_visit_2_overview (wra_ptid);
CREATE INDEX visit_2_screening_id_idx ON arch_etl_db.crt_wra_visit_2_overview (screening_id);
CREATE INDEX visit_2_age_idx ON arch_etl_db.crt_wra_visit_2_overview (age);
CREATE INDEX visit_2_visit_number_idx ON arch_etl_db.crt_wra_visit_2_overview (visit_number);
CREATE INDEX visit_2_visit_name_idx ON arch_etl_db.crt_wra_visit_2_overview (visit_name);
CREATE INDEX visit_2_visit_date_idx ON arch_etl_db.crt_wra_visit_2_overview (visit_date);
CREATE INDEX visit_2_visit_outcome_idx ON arch_etl_db.crt_wra_visit_2_overview (visit_outcome);