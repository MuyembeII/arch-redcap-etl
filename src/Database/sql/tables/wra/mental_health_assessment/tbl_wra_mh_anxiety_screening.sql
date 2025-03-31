DROP TABLE IF EXISTS arch_etl_db.crt_wra_mh_anxiety_screening_overview;
CREATE TABLE IF NOT EXISTS arch_etl_db.crt_wra_mh_anxiety_screening_overview
(
    mh_anxiety_severity_id BIGINT UNSIGNED NOT NULL,
    record_id                 BIGINT UNSIGNED NOT NULL,
    wra_ptid                  VARCHAR(6)      NOT NULL,
    member_id                 SMALLINT        NOT NULL,
    screening_id              VARCHAR(14)     NOT NULL,
    ra                        TINYTEXT        NOT NULL,
    age                       SMALLINT        NOT NULL,
    visit_number              DECIMAL(10, 1)  NOT NULL,
    visit_name                VARCHAR(64)     NOT NULL,
    visit_date                DATE            NOT NULL,
    days_since_baseline       MEDIUMINT       NOT NULL,
    anxiety_problem_1  ENUM ( 'Several days', 'Not at all', 'More than half the days', 'Nearly every day', ''),
    anxiety_problem_2  ENUM ('Several days', 'Not at all', 'More than half the days', 'Nearly every day', ''),
    anxiety_problem_3  ENUM ('Several days', 'Not at all', 'More than half the days', 'Nearly every day', ''),
    anxiety_problem_4  ENUM ('Several days', 'Not at all', 'More than half the days', 'Nearly every day', ''),
    anxiety_problem_5  ENUM ('Several days', 'Not at all', 'More than half the days', 'Nearly every day', ''),
    anxiety_problem_6  ENUM ('Several days', 'Not at all', 'More than half the days', 'Nearly every day', ''),
    anxiety_problem_7  ENUM ('Several days', 'Not at all', 'More than half the days', 'Nearly every day', ''),
    gad_7_tx_score            SMALLINT,
    gad_7_anxiety_severity ENUM (
        'None', 'Minimal Anxiety', 'Mild Anxiety', 'Moderate Anxiety', 'Severe Anxiety', ''),
    PRIMARY KEY (mh_anxiety_severity_id, record_id)
);
CREATE UNIQUE INDEX ds_mh_anxiety_severity_id_idx ON arch_etl_db.crt_wra_mh_anxiety_screening_overview (mh_anxiety_severity_id);
CREATE INDEX as_record_id_idx ON arch_etl_db.crt_wra_mh_anxiety_screening_overview (record_id);
CREATE INDEX as_wra_ptid_idx ON arch_etl_db.crt_wra_mh_anxiety_screening_overview (wra_ptid);
CREATE INDEX as_gad_7_tx_score_idx ON arch_etl_db.crt_wra_mh_anxiety_screening_overview (gad_7_tx_score);
CREATE INDEX as_gad_7_anxiety_severity_idx ON arch_etl_db.crt_wra_mh_anxiety_screening_overview (gad_7_anxiety_severity);