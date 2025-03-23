DROP TABLE IF EXISTS arch_etl_db.crt_wra_visit_2_food_security_overview;
CREATE TABLE arch_etl_db.crt_wra_visit_2_food_security_overview
(
    record_id                                         INT            NOT NULL PRIMARY KEY,
    alternate_id                                      INT            NOT NULL,
    wra_ptid                                          VARCHAR(6)     NOT NULL,
    member_id                                         SMALLINT       NOT NULL,
    screening_id                                      VARCHAR(14)    NOT NULL,
    age                                               SMALLINT       NOT NULL,
    ra                                                VARCHAR(32)    NOT NULL,
    visit_number                                      DECIMAL(10, 1) NOT NULL,
    visit_name                                        VARCHAR(64)    NOT NULL,
    visit_date                                        DATE           NOT NULL,
    no_food_to_eat_last_30_days                       ENUM ('Yes', 'No'),
    no_food_to_eat_last_30_days_freq                  TINYTEXT,
    hh_member_slept_hungry_at_night_last_30_days      ENUM ('Yes', 'No'),
    hh_member_slept_hungry_at_night_last_30_days_freq TINYTEXT,
    hh_member_hungry_day_night_last_30_days           ENUM ('Yes', 'No'),
    hh_member_hungry_day_night_last_30_days_freq      TINYTEXT
);
CREATE UNIQUE INDEX visit_2_fs_alternate_id_idx ON arch_etl_db.crt_wra_visit_2_food_security_overview (alternate_id);
CREATE UNIQUE INDEX visit_2_fs_wra_ptid_idx ON arch_etl_db.crt_wra_visit_2_food_security_overview (wra_ptid);
CREATE INDEX visit_2_no_food_to_eat_last_30_days_idx ON arch_etl_db.crt_wra_visit_2_food_security_overview (no_food_to_eat_last_30_days);
CREATE INDEX visit_2_hh_member_slept_hungry_at_night_last_30_days_idx ON arch_etl_db.crt_wra_visit_2_food_security_overview (hh_member_slept_hungry_at_night_last_30_days);
CREATE INDEX visit_2_hh_member_hungry_day_night_last_30_days_idx ON arch_etl_db.crt_wra_visit_2_food_security_overview (hh_member_hungry_day_night_last_30_days);
CREATE FULLTEXT INDEX fs_ft_idx ON arch_etl_db.crt_wra_visit_2_food_security_overview (no_food_to_eat_last_30_days_freq,
                                                                                       hh_member_slept_hungry_at_night_last_30_days_freq,
                                                                                       hh_member_hungry_day_night_last_30_days_freq);