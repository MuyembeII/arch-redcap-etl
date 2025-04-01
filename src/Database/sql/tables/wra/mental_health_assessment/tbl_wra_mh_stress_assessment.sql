DROP TABLE IF EXISTS arch_etl_db.crt_wra_mh_stress_assessment_overview;
CREATE TABLE IF NOT EXISTS arch_etl_db.crt_wra_mh_stress_assessment_overview
(
    mh_pss_id           BIGINT UNSIGNED NOT NULL,
    record_id           BIGINT UNSIGNED NOT NULL,
    wra_ptid            VARCHAR(6)      NOT NULL,
    member_id           SMALLINT        NOT NULL,
    screening_id        VARCHAR(14)     NOT NULL,
    ra                  TINYTEXT        NOT NULL,
    age                 SMALLINT        NOT NULL,
    visit_number        DECIMAL(10, 1)  NOT NULL,
    visit_name          VARCHAR(64)     NOT NULL,
    visit_date          DATE            NOT NULL,
    days_since_baseline MEDIUMINT       NOT NULL,
    stress_problem_1    ENUM ( 'Never', 'Almost never', 'Sometimes', 'Fairly Often', 'Very Often', ''),
    stress_problem_2    ENUM ('Never', 'Almost never', 'Sometimes', 'Fairly Often', 'Very Often', ''),
    stress_problem_3    ENUM ('Never', 'Almost never', 'Sometimes', 'Fairly Often', 'Very Often', ''),
    stress_problem_4    ENUM ('Never', 'Almost never', 'Sometimes', 'Fairly Often', 'Very Often', ''),
    stress_problem_5    ENUM ('Never', 'Almost never', 'Sometimes', 'Fairly Often', 'Very Often', ''),
    stress_problem_6    ENUM ('Never', 'Almost never', 'Sometimes', 'Fairly Often', 'Very Often', ''),
    stress_problem_7    ENUM ('Never', 'Almost never', 'Sometimes', 'Fairly Often', 'Very Often', ''),
    stress_problem_8    ENUM ('Never', 'Almost never', 'Sometimes', 'Fairly Often', 'Very Often', ''),
    stress_problem_9    ENUM ('Never', 'Almost never', 'Sometimes', 'Fairly Often', 'Very Often', ''),
    stress_problem_10   ENUM ('Never', 'Almost never', 'Sometimes', 'Fairly Often', 'Very Often', ''),
    pss_10_tx_score     SMALLINT,
    pss10_severity      ENUM ('None', 'Low Stress', 'Moderate Stress', 'High Perceived Stress', ''),
    comments            TEXT,
    PRIMARY KEY (mh_pss_id, record_id)
);
CREATE UNIQUE INDEX pss_mh_anxiety_severity_id_idx ON arch_etl_db.crt_wra_mh_stress_assessment_overview (mh_pss_id);
CREATE INDEX pss_record_id_idx ON arch_etl_db.crt_wra_mh_stress_assessment_overview (record_id);
CREATE INDEX pss_wra_ptid_idx ON arch_etl_db.crt_wra_mh_stress_assessment_overview (wra_ptid);
CREATE INDEX pss_10_tx_score_idx ON arch_etl_db.crt_wra_mh_stress_assessment_overview (pss_10_tx_score);
CREATE INDEX pss10_severity_idx ON arch_etl_db.crt_wra_mh_stress_assessment_overview (pss10_severity);