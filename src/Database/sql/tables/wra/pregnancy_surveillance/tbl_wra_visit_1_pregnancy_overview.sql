DROP TABLE IF EXISTS arch_etl_db.crt_wra_visit_1_pregnancy_overview;
CREATE TABLE arch_etl_db.crt_wra_visit_1_pregnancy_overview
(
    record_id                      INT            NOT NULL PRIMARY KEY,
    wra_ptid                       VARCHAR(6)     NOT NULL,
    member_id                      SMALLINT       NOT NULL,
    screening_id                   VARCHAR(14)    NOT NULL,
    age                            SMALLINT       NOT NULL,
    ra                             VARCHAR(32)    NOT NULL,
    visit_number                   DECIMAL(10, 1) NOT NULL,
    visit_name                     VARCHAR(64)    NOT NULL,
    visit_date                     DATE           NOT NULL,
    has_pregnancy_hx               TINYTEXT,
    pregnancy_count                SMALLINT,
    live_birth_count               SMALLINT,
    loss_count                     SMALLINT,
    spontaneous_miscarriages_count SMALLINT,
    still_birth_count              SMALLINT,
    menstruation_outcome           TINYTEXT,
    no_menstruals_reason           TINYTEXT,
    lmp_date                       DATE,
    estimated_lmp                  TINYINT,
    estimated_lmp_flag             TINYTEXT,
    currently_pregnant             TINYTEXT,
    pregnancy_identifier           TINYTEXT
);
CREATE UNIQUE INDEX visit_1_pregnancy_wra_ptid_idx ON arch_etl_db.crt_wra_visit_1_pregnancy_overview (wra_ptid);
CREATE INDEX visit_1_has_pregnancy_hx_idx ON arch_etl_db.crt_wra_visit_1_pregnancy_overview (has_pregnancy_hx);
CREATE INDEX visit_1_menstruation_outcome_idx ON arch_etl_db.crt_wra_visit_1_pregnancy_overview (menstruation_outcome);
CREATE INDEX visit_1_currently_pregnant_idx ON arch_etl_db.crt_wra_visit_1_pregnancy_overview (currently_pregnant);
CREATE INDEX visit_1_pregnancy_identifier_idx ON arch_etl_db.crt_wra_visit_1_pregnancy_overview (pregnancy_identifier);