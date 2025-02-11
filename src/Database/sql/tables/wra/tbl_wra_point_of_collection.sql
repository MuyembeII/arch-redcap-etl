DROP TABLE IF EXISTS arch_etl_db.crt_wra_point_of_collection_overview;
CREATE TABLE IF NOT EXISTS arch_etl_db.crt_wra_point_of_collection_overview
(
    poc_id                  BIGINT UNSIGNED NOT NULL PRIMARY KEY,
    record_id               BIGINT UNSIGNED NOT NULL,
    wra_ptid                VARCHAR(6)      NOT NULL,
    member_id               SMALLINT        NOT NULL,
    screening_id            VARCHAR(14)     NOT NULL,
    visit_number            DECIMAL(10, 1)  NOT NULL,
    visit_name              VARCHAR(255)    NOT NULL,
    visit_date              DATE,
    hx_of_hypertension      ENUM ('No', 'Yes'),
    bp_systolic             MEDIUMINT,
    bp_diastolic            MEDIUMINT,
    pulse_rate              SMALLINT,
    vaginal_swabs_collected SMALLINT DEFAULT 0,
    upt_result              VARCHAR(8),
    pregnancy_id            VARCHAR(14),
    weight                  NUMERIC(4, 1),
    height                  NUMERIC(4, 1),
    bmi                     TEXT,
    bmi_result              TINYTEXT
);
CREATE INDEX poc_record_id_idx ON arch_etl_db.crt_wra_point_of_collection_overview (record_id);
CREATE INDEX poc_wra_ptid_idx ON arch_etl_db.crt_wra_point_of_collection_overview (wra_ptid);
CREATE UNIQUE INDEX poc_pregnancy_id_idx ON arch_etl_db.crt_wra_point_of_collection_overview (pregnancy_id);
CREATE INDEX poc_upt_result_idx ON arch_etl_db.crt_wra_point_of_collection_overview (upt_result);
CREATE INDEX poc_visit_number_idx ON arch_etl_db.crt_wra_point_of_collection_overview (visit_number);
CREATE INDEX poc_visit_name_idx ON arch_etl_db.crt_wra_point_of_collection_overview (visit_name);