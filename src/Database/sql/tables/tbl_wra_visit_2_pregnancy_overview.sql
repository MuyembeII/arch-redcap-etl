DROP TABLE IF EXISTS arch_etl_db.crt_wra_visit_2_pregnancy_overview;
CREATE TABLE arch_etl_db.crt_wra_visit_2_pregnancy_overview
(
    record_id                        INT            NOT NULL PRIMARY KEY,
    wra_ptid                         VARCHAR(6)     NOT NULL,
    member_id                        SMALLINT       NOT NULL,
    screening_id                     VARCHAR(14)    NOT NULL,
    age                              SMALLINT       NOT NULL,
    ra                               VARCHAR(32)    NOT NULL,
    visit_number                     DECIMAL(10, 1) NOT NULL,
    visit_name                       VARCHAR(255)   NOT NULL,
    visit_date                       DATE           NOT NULL,
    has_menstruals                   ENUM ('No', 'Yes'),
    no_menstruals_reason             TINYTEXT,
    currently_pregnant               VARCHAR(8),
    pregnancy_identifier             TINYTEXT,
    previous_upt_result              VARCHAR(8),
    previous_pregnancy_id            VARCHAR(14),
    pregnant_since_last_visit        ENUM ('No', 'Yes'),
    same_pregnancy_since_last_visit  ENUM ('No', 'Yes'),
    pregnancy_count_since_last_visit SMALLINT,
    zapps_enrollment_status          VARCHAR(16)
);
CREATE UNIQUE INDEX visit_2_wra_ptid_idx ON arch_etl_db.crt_wra_visit_2_pregnancy_overview (wra_ptid);
CREATE UNIQUE INDEX visit_2_visit_number_idx ON arch_etl_db.crt_wra_visit_2_pregnancy_overview (visit_number);
CREATE UNIQUE INDEX visit_2_visit_name_idx ON arch_etl_db.crt_wra_visit_2_pregnancy_overview (visit_name);
CREATE UNIQUE INDEX visit_2_previous_upt_result_idx ON arch_etl_db.crt_wra_visit_2_pregnancy_overview (previous_upt_result);
CREATE UNIQUE INDEX visit_2_previous_pregnancy_id_idx ON arch_etl_db.crt_wra_visit_2_pregnancy_overview (previous_pregnancy_id);