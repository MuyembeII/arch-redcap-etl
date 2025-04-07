DROP TABLE IF EXISTS arch_etl_db.crt_wra_visit_5_zapps_co_enrollment_overview;
CREATE TABLE arch_etl_db.crt_wra_visit_5_zapps_co_enrollment_overview
(
    record_id                    INT            NOT NULL PRIMARY KEY,
    alternate_id                 INT            NOT NULL,
    wra_ptid                     VARCHAR(6)     NOT NULL,
    member_id                    SMALLINT       NOT NULL,
    screening_id                 VARCHAR(14)    NOT NULL,
    age                          SMALLINT       NOT NULL,
    ra                           VARCHAR(32)    NOT NULL,
    visit_number                 DECIMAL(10, 1) NOT NULL,
    visit_name                   VARCHAR(64)    NOT NULL,
    visit_date                   DATE           NOT NULL,
    is_wra_enrolled_in_zapps     TINYTEXT,
    zapps_ptid                   TINYTEXT,
    zapps_ptid_source            TINYTEXT,
    is_wra_enrolled_in_famli_dxa TINYTEXT,
    famli_dxa_ptid               TINYTEXT,
    famli_dxa_id_source          TINYTEXT
);
CREATE UNIQUE INDEX visit_5_loc_alternate_id_idx ON arch_etl_db.crt_wra_visit_5_zapps_co_enrollment_overview (alternate_id);
CREATE UNIQUE INDEX visit_5_loc_wra_ptid_idx ON arch_etl_db.crt_wra_visit_5_zapps_co_enrollment_overview (wra_ptid);
CREATE INDEX visit_5_wra_enrolled_in_zapps_idx ON arch_etl_db.crt_wra_visit_5_zapps_co_enrollment_overview (is_wra_enrolled_in_zapps);
CREATE INDEX visit_5_zapps_ptid_idx ON arch_etl_db.crt_wra_visit_5_zapps_co_enrollment_overview (zapps_ptid);
CREATE INDEX visit_5_zapps_ptid_source_idx ON arch_etl_db.crt_wra_visit_5_zapps_co_enrollment_overview (zapps_ptid_source);
CREATE INDEX visit_5_is_wra_enrolled_in_famli_dxa_idx ON arch_etl_db.crt_wra_visit_5_zapps_co_enrollment_overview (is_wra_enrolled_in_famli_dxa);