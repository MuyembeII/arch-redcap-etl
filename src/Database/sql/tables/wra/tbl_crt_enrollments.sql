DROP TABLE IF EXISTS arch_db.crt_enrollments;
CREATE TABLE arch_db.crt_enrollments
(
    id                             int,
    wra_enrollment_id              bigint      null,
    household_member_id            int         not null,
    wra_ptid                       varchar(6)  null,
    screening_id                   varchar(14) not null,
    date_of_enrollment             date        null,
    ra_name                        varchar(36) null,
    enrolled_by                    varchar(36) null,
    first_name                     varchar(36) not null,
    middle_name                    varchar(36) null,
    last_name                      varchar(36) not null,
    sex                            varchar(6)  not null,
    age                            int         not null,
    case_status                    varchar(36) not null,
    case_next_visit_date           varchar(36) not null,
    case_completion_date           varchar(36) null,
    enrolled_in_zapps              varchar(16) null,
    referred_to_zapps              varchar(16) null,
    zapps_ptid                     varchar(11) null,
    enrolled_in_famli              varchar(16) null,
    famli_ptid                     varchar(12) null,
    is_currently_pregnant          varchar(16) null,
    has_adverse_event              varchar(3)  null,
    has_withdrawn                  varchar(3)  null,
    number_of_visits               int         null,
    number_of_pregnancies          int         null,
    number_of_infants              int         null,
    number_of_deliveries           int         null,
    number_of_spontaneous_abortion int         null,
    number_of_induced_abortions    int         null,
    number_of_ectopic_pregnancy    int         null,
    number_of_zapps_ref            int         null,
    visit_status                   mediumtext  null
);
CREATE INDEX crt_wra_enrollment_id_idx ON arch_db.crt_enrollments (wra_enrollment_id);
CREATE INDEX crt_wra_ptid_idx ON arch_db.crt_enrollments (wra_ptid);
