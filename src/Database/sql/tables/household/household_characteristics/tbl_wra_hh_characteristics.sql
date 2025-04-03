DROP TABLE IF EXISTS arch_etl_db.crt_wra_household_characteristics_overview;
CREATE TABLE IF NOT EXISTS arch_etl_db.crt_wra_household_characteristics_overview
(
    alternate_id                            BIGINT UNSIGNED NOT NULL,
    record_id                               BIGINT UNSIGNED NOT NULL,
    wra_ptid                                VARCHAR(6)      NOT NULL,
    member_id                               SMALLINT        NOT NULL,
    screening_id                            VARCHAR(14)     NOT NULL,
    ra                                      TINYTEXT        NOT NULL,
    age                                     SMALLINT        NOT NULL,
    visit_number                            DECIMAL(10, 1)  NOT NULL,
    visit_name                              VARCHAR(64)     NOT NULL,
    visit_date                              DATE            NOT NULL,
    days_since_baseline                     MEDIUMINT       NOT NULL,
    house_ownership                         TINYTEXT,
    head_of_household                       TINYTEXT,
    hh_tx_people                            SMALLINT,
    hh_tx_rooms                             SMALLINT,
    hh_tx_rooms_for_sleeping                SMALLINT,
    hh_assets                               MEDIUMTEXT,
    hh_member_assets                        MEDIUMTEXT,
    hh_owns_livestock_herds_poultry         ENUM ('No', 'Yes'),
    hh_owns_agriculture_land                ENUM ('No', 'Yes'),
    hh_exterior_wall_building_material      TINYTEXT,
    hh_floor_building_material              TINYTEXT,
    hh_roof_building_material               TINYTEXT,
    hh_place_for_hand_wash                  TINYTEXT,
    hh_place_for_hand_wash_observation      TINYTEXT,
    hh_handwash_cleansing_agent_observation TINYTEXT,
    PRIMARY KEY (alternate_id, record_id)
);
CREATE UNIQUE INDEX hhc_alternate_id_idx ON arch_etl_db.crt_wra_household_characteristics_overview (alternate_id);
CREATE INDEX hhc_record_id_idx ON arch_etl_db.crt_wra_household_characteristics_overview (record_id);
CREATE INDEX hhc_wra_ptid_idx ON arch_etl_db.crt_wra_household_characteristics_overview (wra_ptid);
CREATE INDEX hhc_house_ownership_idx ON arch_etl_db.crt_wra_household_characteristics_overview (house_ownership);
CREATE INDEX hhc_head_of_household_idx ON arch_etl_db.crt_wra_household_characteristics_overview (head_of_household);
CREATE INDEX hhc_owns_livestock_herds_poultry_idx ON arch_etl_db.crt_wra_household_characteristics_overview (hh_owns_livestock_herds_poultry);
CREATE INDEX hhc_owns_agric_land_idx ON arch_etl_db.crt_wra_household_characteristics_overview (hh_owns_agriculture_land);
CREATE INDEX hhc_place_for_hand_wash_observ_idx ON arch_etl_db.crt_wra_household_characteristics_overview (hh_place_for_hand_wash_observation);
CREATE FULLTEXT INDEX hhc_ft_idx ON arch_etl_db.crt_wra_household_characteristics_overview (hh_assets,
                                                                                            hh_member_assets,
                                                                                            hh_exterior_wall_building_material,
                                                                                            hh_floor_building_material,
                                                                                            hh_roof_building_material,
                                                                                            hh_place_for_hand_wash,
                                                                                            hh_handwash_cleansing_agent_observation);