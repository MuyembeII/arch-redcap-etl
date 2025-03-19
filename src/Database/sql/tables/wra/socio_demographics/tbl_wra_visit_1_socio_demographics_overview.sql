DROP TABLE IF EXISTS arch_etl_db.crt_wra_visit_1_socio_demographics_overview;
CREATE TABLE arch_etl_db.crt_wra_visit_1_socio_demographics_overview
(
    record_id                        INT            NOT NULL PRIMARY KEY,
    alternate_id                     INT            NOT NULL,
    wra_ptid                         VARCHAR(6)     NOT NULL,
    member_id                        SMALLINT       NOT NULL,
    screening_id                     VARCHAR(14)    NOT NULL,
    age                              SMALLINT       NOT NULL,
    ra                               VARCHAR(32)    NOT NULL,
    visit_number                     DECIMAL(10, 1) NOT NULL,
    visit_name                       VARCHAR(64)    NOT NULL,
    visit_date                       DATE           NOT NULL,
    marital_status                   TINYTEXT,
    marriage_age                     SMALLINT,
    attended_school                  ENUM ('Yes', 'No'),
    highest_education_level          TINYTEXT,
    tx_school_years_attended         SMALLINT,
    has_occupation_income            ENUM ('Yes', 'No'),
    approx_income_pay                TINYTEXT,
    mobile_phone_accessibility       TINYTEXT,
    smoke_cigarettes_cigar_pipe      ENUM ('Yes', 'No'),
    smoke_cigarettes_cigar_pipe_freq TINYTEXT,
    chewed_tobacco_last_month        ENUM ('Yes', 'No'),
    consumed_alcohol_last_month      ENUM ('Yes', 'No')
);
CREATE UNIQUE INDEX visit_1_alternate_id_idx ON arch_etl_db.crt_wra_visit_1_socio_demographics_overview (alternate_id);
CREATE UNIQUE INDEX visit_1_sd_wra_ptid_idx ON arch_etl_db.crt_wra_visit_1_socio_demographics_overview (wra_ptid);
CREATE INDEX visit_1_marital_status_idx ON arch_etl_db.crt_wra_visit_1_socio_demographics_overview (marital_status);
CREATE INDEX visit_1_marriage_age_idx ON arch_etl_db.crt_wra_visit_1_socio_demographics_overview (marriage_age);
CREATE INDEX visit_1_attended_school_idx ON arch_etl_db.crt_wra_visit_1_socio_demographics_overview (attended_school);
CREATE INDEX visit_1_highest_education_level_idx ON arch_etl_db.crt_wra_visit_1_socio_demographics_overview (highest_education_level);
CREATE INDEX visit_1_tx_school_years_attended_idx ON arch_etl_db.crt_wra_visit_1_socio_demographics_overview (tx_school_years_attended);
CREATE INDEX visit_1_has_occupation_income_idx ON arch_etl_db.crt_wra_visit_1_socio_demographics_overview (has_occupation_income);
CREATE INDEX visit_1_smoke_cigarettes_cigar_pipe_freq_idx ON arch_etl_db.crt_wra_visit_1_socio_demographics_overview (smoke_cigarettes_cigar_pipe_freq);
CREATE FULLTEXT INDEX sd_ft_idx ON crt_wra_visit_1_socio_demographics_overview (approx_income_pay);