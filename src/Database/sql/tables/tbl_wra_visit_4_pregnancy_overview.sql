DROP TABLE IF EXISTS arch_etl_db.crt_wra_visit_4_pregnancy_overview;
CREATE TABLE arch_etl_db.crt_wra_visit_4_pregnancy_overview
(
    record_id                        INT            NOT NULL PRIMARY KEY,
    wra_ptid                         VARCHAR(6)     NOT NULL,
    member_id                        SMALLINT       NOT NULL,
    screening_id                     VARCHAR(14)    NOT NULL,
    age                              SMALLINT       NOT NULL,
    ra                               VARCHAR(32)    NOT NULL,
    visit_number                     DECIMAL(10, 1) NOT NULL,
    visit_name                       VARCHAR(64)    NOT NULL,
    visit_date                       DATE           NOT NULL,
    menstruation_outcome             ENUM ('Menstruating', 'Not Menstruating'),
    no_menstruals_reason             TINYTEXT,
    currently_pregnant               VARCHAR(8),
    pregnancy_identifier             TINYTEXT,
    last_upt_result                  VARCHAR(8),
    last_pregnancy_id                VARCHAR(14),
    last_zapps_referral_outcome      ENUM ('Accepted', 'Not Accepted'),
    pregnant_since_last_visit        ENUM ('No', 'Yes'),
    same_pregnancy_since_last_visit  ENUM ('No', 'Yes'),
    pregnancy_count_since_last_visit SMALLINT,
    zapps_enrollment_status          VARCHAR(32),
    zapps_ptid                       VARCHAR(16)
);
CREATE INDEX visit_4_wra_ptid_idx ON arch_etl_db.crt_wra_visit_4_pregnancy_overview (wra_ptid);
CREATE INDEX visit_4_currently_pregnant_idx ON arch_etl_db.crt_wra_visit_4_pregnancy_overview (currently_pregnant);
CREATE INDEX visit_4_pregnancy_identifier_idx ON arch_etl_db.crt_wra_visit_4_pregnancy_overview (pregnancy_identifier);
CREATE INDEX visit_4_last_upt_result_idx ON arch_etl_db.crt_wra_visit_4_pregnancy_overview (last_upt_result);
CREATE UNIQUE INDEX visit_4_last_pregnancy_id_idx ON arch_etl_db.crt_wra_visit_4_pregnancy_overview (last_pregnancy_id);
CREATE INDEX visit_4_last_zapps_referral_outcome_idx ON arch_etl_db.crt_wra_visit_4_pregnancy_overview (last_zapps_referral_outcome);
CREATE INDEX visit_4_pregnant_since_last_visit_idx ON arch_etl_db.crt_wra_visit_4_pregnancy_overview (pregnant_since_last_visit);
CREATE INDEX visit_4_pregnancy_count_since_last_visit_idx ON arch_etl_db.crt_wra_visit_4_pregnancy_overview (pregnancy_count_since_last_visit);
CREATE INDEX visit_4_zapps_enrollment_status_idx ON arch_etl_db.crt_wra_visit_4_pregnancy_overview (zapps_enrollment_status);