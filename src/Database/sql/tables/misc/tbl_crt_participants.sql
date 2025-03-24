DROP TABLE IF EXISTS arch_db.crt_participants;
CREATE TABLE IF NOT EXISTS arch_db.crt_participants
(
    id                             int auto_increment
        primary key,
    hhe_id                         bigint      not null,
    household_member_id            int         not null,
    date_of_enumeration            date        not null,
    enumerated_by                  varchar(36) not null,
    screening_id                   varchar(14) not null,
    first_name                     varchar(36) not null,
    middle_name                    varchar(36) not null,
    last_name                      varchar(36) not null,
    sex                            varchar(6)  not null,
    age                            int         not null,
    wra_eligibility                varchar(16)  not null,
    relationship_type              varchar(36) null,
    marital_status                 varchar(36) null,
    case_status                    varchar(36) null
    -- constraint hhe_id
       -- unique (hhe_id)
);

