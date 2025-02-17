DROP TABLE IF EXISTS arch_etl_db.crt_wra_visit_2_infant_outcome_overview;
CREATE TABLE arch_etl_db.crt_wra_visit_2_infant_outcome_overview
(
    alternate_id               INT            NOT NULL,
    record_id                  INT            NOT NULL,
    wra_ptid                   VARCHAR(6)     NOT NULL,
    infant_id                  SMALLINT       NOT NULL,
    member_id                  SMALLINT       NOT NULL,
    screening_id               VARCHAR(14)    NOT NULL,
    age                        SMALLINT       NOT NULL,
    ra                         VARCHAR(32)    NOT NULL,
    visit_number               DECIMAL(10, 1) NOT NULL,
    visit_name                 VARCHAR(255)   NOT NULL,
    visit_date                 DATE           NOT NULL,
    last_upt_result            VARCHAR(8),
    last_pregnancy_id          VARCHAR(14),
    infant_name                VARCHAR(32),
    infant_ptid                VARCHAR(32),
    infant_gender              VARCHAR(16),
    infant_mortality_outcome   ENUM ('Deceased', 'Living'),
    infant_living_age_days     SMALLINT,
    infant_living_age_months   SMALLINT,
    infant_deceased_age_days   SMALLINT,
    infant_deceased_age_months SMALLINT,
    PRIMARY KEY (record_id, alternate_id)
);
CREATE INDEX io_2_wra_ptid_idx ON arch_etl_db.crt_wra_visit_2_infant_outcome_overview (wra_ptid);
CREATE INDEX io_2_visit_number_idx ON arch_etl_db.crt_wra_visit_2_infant_outcome_overview (visit_number);
CREATE INDEX io_2_visit_name_idx ON arch_etl_db.crt_wra_visit_2_infant_outcome_overview (visit_name);
CREATE INDEX io_2_last_upt_result_idx ON arch_etl_db.crt_wra_visit_2_infant_outcome_overview (last_upt_result);
CREATE INDEX io_2_last_pregnancy_id_idx ON arch_etl_db.crt_wra_visit_2_infant_outcome_overview (last_pregnancy_id);
CREATE INDEX io_2_infant_name_idx ON arch_etl_db.crt_wra_visit_2_infant_outcome_overview (infant_name);
CREATE INDEX io_2_infant_id_idx ON arch_etl_db.crt_wra_visit_2_infant_outcome_overview (infant_id);
CREATE INDEX io_2_infant_ptid_idx ON arch_etl_db.crt_wra_visit_2_infant_outcome_overview (infant_ptid);
CREATE INDEX io_2_infant_gender_idx ON arch_etl_db.crt_wra_visit_2_infant_outcome_overview (infant_gender);
CREATE INDEX io_2_infant_mortality_outcome_idx ON arch_etl_db.crt_wra_visit_2_infant_outcome_overview (infant_mortality_outcome);