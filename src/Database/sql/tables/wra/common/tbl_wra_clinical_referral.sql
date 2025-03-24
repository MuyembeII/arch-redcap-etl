DROP TABLE IF EXISTS arch_etl_db.crt_wra_clinical_referral_overview;
CREATE TABLE IF NOT EXISTS arch_etl_db.crt_wra_clinical_referral_overview
(
    referral_id                BIGINT UNSIGNED NOT NULL PRIMARY KEY,
    record_id                  BIGINT UNSIGNED NOT NULL,
    wra_ptid                   VARCHAR(6)      NOT NULL,
    member_id                  SMALLINT        NOT NULL,
    screening_id               VARCHAR(14)     NOT NULL,
    visit_number               DECIMAL(10, 1)  NOT NULL,
    visit_name                 VARCHAR(64)     NOT NULL,
    visit_date                 DATE,
    referral_destination       TINYTEXT,
    other_referral_destination MEDIUMTEXT,
    reason_for_referral        TINYTEXT,
    other_reason_for_referral  MEDIUMTEXT,
    comments                   TEXT
);
CREATE UNIQUE INDEX c_ref_referral_id_idx ON arch_etl_db.crt_wra_clinical_referral_overview (referral_id);
CREATE UNIQUE INDEX c_ref_wra_ptid_idx ON arch_etl_db.crt_wra_clinical_referral_overview (wra_ptid);
CREATE UNIQUE INDEX c_ref_referral_destination_idx ON arch_etl_db.crt_wra_clinical_referral_overview (referral_destination);
CREATE INDEX c_ref_reason_for_referral_idx ON arch_etl_db.crt_wra_clinical_referral_overview (reason_for_referral);
CREATE FULLTEXT INDEX c_ref_ft_idx ON arch_etl_db.crt_wra_clinical_referral_overview (other_referral_destination,
                                                                                      other_reason_for_referral);