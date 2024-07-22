DROP TABLE IF EXISTS arch_etl_db.crt_wra_locator;
CREATE TABLE IF NOT EXISTS arch_etl_db.crt_wra_locator
(
    record_id                       BIGINT UNSIGNED NOT NULL PRIMARY KEY,
    screening_id                    MEDIUMTEXT      NOT NULL,
    member_id                       BIGINT        NOT NULL,
    screening_date                  DATE            NULL,
    wra_ptid                        MEDIUMTEXT      NOT NULL,
    wra_name                        MEDIUMTEXT      NOT NULL,
    age                             BIGINT         NOT NULL,
    first_contact_number            VARCHAR(11)     NULL,
    first_contact_number_owner      VARCHAR(64)     NULL,
    first_contact_number_caller_id  VARCHAR(64)     NULL,
    second_contact_number           VARCHAR(11)     NULL,
    second_contact_number_owner     VARCHAR(64)     NULL,
    second_contact_number_caller_id VARCHAR(64)     NULL
);

CREATE UNIQUE INDEX loc_wra_ptid_idx ON arch_etl_db.crt_wra_locator (wra_ptid);
CREATE INDEX loc_hh_scrn_num_obsloc_idx ON arch_etl_db.crt_wra_locator (screening_id);

