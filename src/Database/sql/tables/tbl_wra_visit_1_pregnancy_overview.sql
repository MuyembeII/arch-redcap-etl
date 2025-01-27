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
    visit_name                     VARCHAR(255)   NOT NULL,
    visit_date                     DATE           NOT NULL,
    has_pregnancy_hx               TINYTEXT,
    pregnancy_count                SMALLINT,
    live_birth_count               SMALLINT,
    loss_count                     SMALLINT,
    spontaneous_miscarriages_count SMALLINT,
    still_birth_count              SMALLINT,
    has_menstruals                 TINYTEXT,
    no_menstruals_reason           TINYTEXT,
    currently_pregnant             TINYTEXT,
    pregnancy_identifier           TINYTEXT
);
CREATE UNIQUE INDEX visit_1_pregnancy_wra_ptid_idx ON arch_etl_db.crt_wra_visit_1_pregnancy_overview (wra_ptid);
CREATE UNIQUE INDEX visit_1_visit_number_idx ON arch_etl_db.crt_wra_visit_1_pregnancy_overview (visit_number);
CREATE UNIQUE INDEX visit_1_visit_name_idx ON arch_etl_db.crt_wra_visit_1_pregnancy_overview (visit_name);