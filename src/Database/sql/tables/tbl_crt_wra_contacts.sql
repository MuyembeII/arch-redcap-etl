DROP TABLE IF EXISTS arch_etl_db.crt_wra_contacts;
CREATE TABLE arch_etl_db.crt_wra_contacts
(
    id                    int        NOT NULL primary key AUTO_INCREMENT,
    record_id             INTEGER    NOT NULL,
    wra_ptid              VARCHAR(6) NOT NULL,
    wra_first_contact_v1  TEXT       NOT NULL,
    wra_second_contact_v1 TEXT       NULL,
    wra_first_contact_v2  TEXT       NULL,
    wra_second_contact_v2 TEXT       NULL,
    wra_first_contact_v3  TEXT       NULL,
    wra_second_contact_v3 TEXT       NULL,
    wra_first_contact_v4  TEXT       NULL,
    wra_second_contact_v4 TEXT       NULL
);
