DROP TABLE IF EXISTS arch_etl_db.crt_wra_visit_5_pregnancy_outcome_overview;
CREATE TABLE arch_etl_db.crt_wra_visit_5_pregnancy_outcome_overview
(
    record_id                  INT            NOT NULL PRIMARY KEY,
    wra_ptid                   VARCHAR(6)     NOT NULL,
    member_id                  SMALLINT       NOT NULL,
    screening_id               VARCHAR(14)    NOT NULL,
    age                        SMALLINT       NOT NULL,
    ra                         VARCHAR(32)    NOT NULL,
    visit_number               DECIMAL(10, 1) NOT NULL,
    visit_name                 VARCHAR(64)    NOT NULL,
    visit_date                 DATE           NOT NULL,
    attended_anc               ENUM ('No', 'Yes'),
    tx_anc_visit               TINYINT,
    tx_fetus                   TINYINT,
    pregnancy_outcome          VARCHAR(32),
    pregnancy_delivery_outcome VARCHAR(16),
    pregnancy_end_date         VARCHAR(24),
    weeks_pregnancy_ended      SMALLINT,
    months_pregnancy_ended     SMALLINT,
    pregnancy_delivery_date    VARCHAR(24),
    weeks_pregnancy_delivered  SMALLINT,
    months_pregnancy_delivered SMALLINT
);
CREATE UNIQUE INDEX poa_5_record_id_idx ON arch_etl_db.crt_wra_visit_5_pregnancy_outcome_overview (record_id);
CREATE INDEX poa_5_wra_ptid_idx ON arch_etl_db.crt_wra_visit_5_pregnancy_outcome_overview (wra_ptid);
CREATE INDEX poa_5_visit_number_idx ON arch_etl_db.crt_wra_visit_5_pregnancy_outcome_overview (visit_number);
CREATE INDEX poa_5_visit_name_idx ON arch_etl_db.crt_wra_visit_5_pregnancy_outcome_overview (visit_name);
CREATE INDEX poa_5_attended_anc_idx ON arch_etl_db.crt_wra_visit_5_pregnancy_outcome_overview (attended_anc);
CREATE INDEX poa_5_pregnancy_outcome_idx ON arch_etl_db.crt_wra_visit_5_pregnancy_outcome_overview (pregnancy_outcome);
CREATE INDEX poa_5_pregnancy_delivery_outcome_idx ON arch_etl_db.crt_wra_visit_5_pregnancy_outcome_overview (pregnancy_delivery_outcome);