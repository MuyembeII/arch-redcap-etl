DROP TABLE IF EXISTS arch_db.crt_households;
CREATE TABLE IF NOT EXISTS arch_db.crt_households
(
    id                         int auto_increment primary key,
    hh_id                      mediumint   not null,
    screening_id               varchar(14) not null,
    date_of_screening          date        not null,
    screened_by                varchar(36) not null,
    screening_status           varchar(36) null,
    screened_household_members int         null,
    expected_household_members int         null,
    current_head_of_household  varchar(36) null,
    expected_head_of_household varchar(36) null,
    hh_verbal_consent          varchar(16) null,
    hhe_status                 varchar(32) null,
    number_of_females          int         null,
    number_of_eligible_wra     int         null,
    expected_number_of_wra     int         null,
    visit_status               varchar(32) null,
    constraint hh_id
        unique (hh_id),
    constraint screening_id
        unique (screening_id)
);

