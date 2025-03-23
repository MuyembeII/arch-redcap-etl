DROP TABLE IF EXISTS arch_etl_db.crt_wra_visit_1_locator_overview;
CREATE TABLE arch_etl_db.crt_wra_visit_1_locator_overview
(
    record_id                            INT            NOT NULL PRIMARY KEY,
    alternate_id                         INT            NOT NULL,
    wra_ptid                             VARCHAR(6)     NOT NULL,
    member_id                            SMALLINT       NOT NULL,
    screening_id                         VARCHAR(14)    NOT NULL,
    age                                  SMALLINT       NOT NULL,
    ra                                   VARCHAR(32)    NOT NULL,
    visit_number                         DECIMAL(10, 1) NOT NULL,
    visit_name                           VARCHAR(64)    NOT NULL,
    visit_date                           DATE           NOT NULL,
    first_contact_number                 TINYTEXT,
    first_contact_number_owner           TINYTEXT,
    first_contact_person_identification  TINYTEXT,
    second_contact_number                TINYTEXT,
    second_contact_number_owner          TINYTEXT,
    second_contact_person_identification TINYTEXT,
    third_contact_number                 TINYTEXT,
    third_contact_number_owner           TINYTEXT,
    third_contact_person_identification  TINYTEXT,
    fourth_contact_number                TINYTEXT,
    fourth_contact_number_owner          TINYTEXT,
    fourth_contact_person_identification TINYTEXT
);
CREATE UNIQUE INDEX visit_1_loc_alternate_id_idx ON arch_etl_db.crt_wra_visit_1_locator_overview (alternate_id);
CREATE UNIQUE INDEX visit_1_loc_wra_ptid_idx ON arch_etl_db.crt_wra_visit_1_locator_overview (wra_ptid);
CREATE INDEX visit_1_first_contact_number_owner_idx ON arch_etl_db.crt_wra_visit_1_locator_overview (first_contact_number_owner);
CREATE INDEX visit_1_second_contact_number_owner_idx ON arch_etl_db.crt_wra_visit_1_locator_overview (second_contact_number_owner);
CREATE INDEX visit_1_third_contact_number_owner_idx ON arch_etl_db.crt_wra_visit_1_locator_overview (third_contact_number_owner);
CREATE INDEX visit_1_fourth_contact_number_owner_idx ON arch_etl_db.crt_wra_visit_1_locator_overview (fourth_contact_number_owner);
CREATE FULLTEXT INDEX loc_ft_idx ON arch_etl_db.crt_wra_visit_1_locator_overview (first_contact_number,
                                                                                  first_contact_person_identification,
                                                                                  second_contact_number,
                                                                                  second_contact_person_identification,
                                                                                  third_contact_number,
                                                                                  third_contact_person_identification,
                                                                                  fourth_contact_number,
                                                                                  fourth_contact_person_identification);