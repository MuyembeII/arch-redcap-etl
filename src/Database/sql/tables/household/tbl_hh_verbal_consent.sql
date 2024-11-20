DROP TABLE IF EXISTS arch_db.hh_verbal_consent;
CREATE TABLE IF NOT EXISTS arch_db.hh_verbal_consent
(
    vc_id                    bigint(12) unsigned                   not null
        primary key,
    record_id                int                                   not null,
    redcap_event_name        tinytext                              not null,
    redcap_repeat_instrument tinytext                              null,
    redcap_repeat_instance   tinytext                              null,
    hh_scrn_num_obsloc       varchar(14)                           null,
    vc_visit_date            date                                  null,
    vc_interviewer           tinytext                              null,
    attempt_count            tinyint                               null,
    vc_outcome1              tinytext                              null,
    vc_outcome2              tinytext                              null,
    vc_outcome3              tinytext                              null,
    vc_hh_available          tinyint                               null,
    vc_hhm_ebn               bit                                   null,
    vc_vc_given_by_adult     tinyint                               null,
    vc_vc_given_flag         tinytext                              null,
    vc_vc_declined           tinytext                              null,
    vc_reas_decline          tinyint                               null,
    vc_oth_reas_dec          tinytext                              null,
    vc_hh_res_1_unit         bit                                   null,
    vc_main_house_unit       bit                                   null,
    vc_sid_main_house        varchar(14)                           null,
    vc_linked_hssn           varchar(14)                           null,
    vc_comments_yn           bit                                   null,
    vc_comments              text                                  null,
    verbal_consent_complete  tinyint                               null,
    created_at               timestamp default current_timestamp() not null,
    created_by               tinytext                              null,
    updated_at               timestamp default current_timestamp() not null on update current_timestamp(),
    updated_by               tinytext                              null
);