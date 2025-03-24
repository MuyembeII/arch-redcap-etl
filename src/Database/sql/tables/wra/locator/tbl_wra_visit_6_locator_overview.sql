DROP TABLE IF EXISTS arch_etl_db.crt_wra_visit_6_locator_overview;
CREATE TABLE arch_etl_db.crt_wra_visit_6_locator_overview
(
    record_id                               BIGINT UNSIGNED   NOT NULL PRIMARY KEY,
    alternate_id                            BIGINT UNSIGNED   NOT NULL,
    wra_ptid                                VARCHAR(6)        NOT NULL,
    member_id                               SMALLINT UNSIGNED NOT NULL,
    screening_id                            VARCHAR(14)       NOT NULL,
    age                                     SMALLINT UNSIGNED NOT NULL,
    ra                                      VARCHAR(32)       NOT NULL,
    visit_number                            DECIMAL(10, 1)    NOT NULL,
    visit_name                              VARCHAR(64)       NOT NULL,
    visit_date                              DATE              NOT NULL,
    is_same_sbn_from_last_visit             TINYTEXT,
    new_cluster_number                      SMALLINT UNSIGNED,
    new_structural_building_number          SMALLINT UNSIGNED,
    new_household_unit_number               SMALLINT UNSIGNED,
    new_household_number                    SMALLINT UNSIGNED,
    new_hh_screening_id                     VARCHAR(14),
    new_migration_location                  TINYTEXT,
    is_locality_name_known                  ENUM ('No', 'Yes'),
    locality_name                           MEDIUMTEXT,
    is_location_address_known               ENUM ('No', 'Yes'),
    address_plot_number                     MEDIUMTEXT,
    is_visible_landmark_near_location_known ENUM ('No', 'Yes'),
    landmarks                               MEDIUMTEXT,
    directions_known                        ENUM ('No', 'Yes'),
    location_directions                     TINYTEXT,
    date_of_migration                       DATE,
    is_first_contact_details_valid          TINYTEXT,
    first_contact_number                    TINYTEXT,
    first_contact_number_owner              TINYTEXT,
    first_contact_person_identification     TINYTEXT,
    is_second_contact_details_valid         TINYTEXT,
    second_contact_number                   TINYTEXT,
    second_contact_number_owner             TINYTEXT,
    second_contact_person_identification    TINYTEXT
);
CREATE UNIQUE INDEX visit_6_loc_alternate_id_idx ON arch_etl_db.crt_wra_visit_6_locator_overview (alternate_id);
CREATE UNIQUE INDEX visit_6_loc_wra_ptid_idx ON arch_etl_db.crt_wra_visit_6_locator_overview (wra_ptid);
CREATE INDEX visit_6_sbn_from_last_visit_known_idx ON arch_etl_db.crt_wra_visit_6_locator_overview (is_same_sbn_from_last_visit);
CREATE INDEX visit_6_locality_name_known_idx ON arch_etl_db.crt_wra_visit_6_locator_overview (is_locality_name_known);
CREATE INDEX visit_6_location_address_known_idx ON arch_etl_db.crt_wra_visit_6_locator_overview (is_location_address_known);
CREATE INDEX visit_6_visible_landmark_near_location_known_idx ON arch_etl_db.crt_wra_visit_6_locator_overview (is_visible_landmark_near_location_known);
CREATE INDEX visit_6_directions_known_idx ON arch_etl_db.crt_wra_visit_6_locator_overview (directions_known);
CREATE INDEX visit_6_date_of_migration_idx ON arch_etl_db.crt_wra_visit_6_locator_overview (date_of_migration);
CREATE INDEX visit_6_first_contact_details_valid_idx ON arch_etl_db.crt_wra_visit_6_locator_overview (is_first_contact_details_valid);
CREATE INDEX visit_6_first_contact_number_owner_idx ON arch_etl_db.crt_wra_visit_6_locator_overview (first_contact_number_owner);
CREATE INDEX visit_6_second_contact_details_valid_idx ON arch_etl_db.crt_wra_visit_6_locator_overview (is_second_contact_details_valid);
CREATE INDEX visit_6_second_contact_number_owner_idx ON arch_etl_db.crt_wra_visit_6_locator_overview (second_contact_number_owner);
CREATE FULLTEXT INDEX visit_6_loc_ft_idx ON arch_etl_db.crt_wra_visit_6_locator_overview (new_hh_screening_id,
                                                                                          new_migration_location,
                                                                                          locality_name,
                                                                                          address_plot_number,
                                                                                          landmarks,
                                                                                          location_directions,
                                                                                          first_contact_number,
                                                                                          first_contact_person_identification,
                                                                                          second_contact_number,
                                                                                          second_contact_person_identification);