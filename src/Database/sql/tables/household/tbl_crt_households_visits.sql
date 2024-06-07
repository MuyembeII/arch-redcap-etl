DROP TABLE if EXISTS arch_db.crt_household_visits;
CREATE TABLE if NOT EXISTS arch_db.crt_household_visits
(
    hh_id                  mediumint     NOT NULL PRIMARY KEY,
    screening_id           varchar(14)   NOT NULL,
    family_id              varchar(18)   NOT NULL,
    date_of_screening      date          NOT NULL,
    date_of_last_visit     date          NULL,
    date_of_next_visit     date          NULL,
    total_visits           smallint      NULL,
    current_visit_number   decimal(2, 1) NULL,
    total_attempts         smallint      NULL,
    current_attempt_number decimal(2, 1) NULL,
    household_visit_number decimal(2, 1) NULL
);
CREATE unique INDEX crt_household_visits_hh_id_idx ON arch_db.crt_household_visits (hh_id);
CREATE INDEX crt_household_visits_sid_idx ON arch_db.crt_household_visits (screening_id);
CREATE INDEX crt_household_visits_family_id_idx ON arch_db.crt_household_visits (family_id);
