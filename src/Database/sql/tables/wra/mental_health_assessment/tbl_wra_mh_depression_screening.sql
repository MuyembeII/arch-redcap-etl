DROP TABLE IF EXISTS arch_etl_db.crt_wra_mh_depression_screening_overview;
CREATE TABLE IF NOT EXISTS arch_etl_db.crt_wra_mh_depression_screening_overview
(
    mh_depression_severity_id BIGINT UNSIGNED NOT NULL,
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
    patient_health_problem_1  ENUM ( 'Several days', 'Not at all', 'More than half the days', 'Nearly every day', ''),
    patient_health_problem_2  ENUM ('Several days', 'Not at all', 'More than half the days', 'Nearly every day', ''),
    patient_health_problem_3  ENUM ('Several days', 'Not at all', 'More than half the days', 'Nearly every day', ''),
    patient_health_problem_4  ENUM ('Several days', 'Not at all', 'More than half the days', 'Nearly every day', ''),
    patient_health_problem_5  ENUM ('Several days', 'Not at all', 'More than half the days', 'Nearly every day', ''),
    patient_health_problem_6  ENUM ('Several days', 'Not at all', 'More than half the days', 'Nearly every day', ''),
    patient_health_problem_7  ENUM ('Several days', 'Not at all', 'More than half the days', 'Nearly every day', ''),
    patient_health_problem_8  ENUM ('Several days', 'Not at all', 'More than half the days', 'Nearly every day', ''),
    patient_health_problem_9  ENUM ('Several days', 'Not at all', 'More than half the days', 'Nearly every day', ''),
    patient_health_problem_10 ENUM ('Not difficult at all', 'Somewhat difficult', 'Very difficult', 'Extremely difficult', ''),
    phq_9_tx_score            SMALLINT,
    phq_9_depression_severity ENUM (
        'None', 'Minimal Depression', 'Mild Depression', 'Moderate Depression',
        'Moderately Severe Depression', 'Severe Depression', ''),
    PRIMARY KEY (mh_depression_severity_id, record_id)
);
CREATE UNIQUE INDEX ds_mh_depression_severity_id_idx ON arch_etl_db.crt_wra_mh_depression_screening_overview (mh_depression_severity_id);
CREATE INDEX ds_record_id_idx ON arch_etl_db.crt_wra_mh_depression_screening_overview (record_id);
CREATE INDEX ds_wra_ptid_idx ON arch_etl_db.crt_wra_mh_depression_screening_overview (wra_ptid);
CREATE INDEX ds_phq_9_tx_score_idx ON arch_etl_db.crt_wra_mh_depression_screening_overview (phq_9_tx_score);
CREATE INDEX ds_phq_9_depression_severity_idx ON arch_etl_db.crt_wra_mh_depression_screening_overview (phq_9_depression_severity);
CREATE INDEX ds_phq_9_hp10_idx ON arch_etl_db.crt_wra_mh_depression_screening_overview (patient_health_problem_10);