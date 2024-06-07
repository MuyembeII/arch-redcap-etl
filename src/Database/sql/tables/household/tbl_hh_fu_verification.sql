DROP TABLE IF EXISTS arch_db.hh_fu_verification;
CREATE TABLE arch_db.hh_fu_verification
(
    record_id                                       INTEGER        NOT NULL PRIMARY KEY,
    redcap_event_name                               VARCHAR(24)    NOT NULL,
    redcap_repeat_instrument                        VARCHAR(36),
    redcap_repeat_instance                          SMALLINT,
    hhv_hh_head                                     VARCHAR(36),
    interview_date_scorres_fu                       DATE           NOT NULL,
    hhsidv_n_o_i_fu                                 VARCHAR(32)    NOT NULL,
    hhv_hh_screening_id                             VARCHAR(25)    NOT NULL,
    hhv_screening_id_veri                           BIT            NOT NULL,
    hhv_fu_same_fam_lv                              BIT            NOT NULL,
    hhv_fam_enr_arch                                BIT,
    hhv_new_head_hh                                 VARCHAR(19),
    hhv_fu_pwra_count                               SMALLINT,
    hhv_hh_head_veri                                BIT,
    hhv_new_head_hh_2                               VARCHAR(36),
    hhv_arch_enrollment                             BIT,
    hhv_longitude                                   NUMERIC(10, 7) NOT NULL,
    hhv_latitude                                    NUMERIC(11, 7) NOT NULL,
    hhsidv_any_comments_v2                          BIT            NOT NULL,
    hhsidv_comments_v2                              MEDIUMTEXT,
    household_screening_id_verification_fu_complete INTEGER        NOT NULL
);
CREATE INDEX hh_hh_fu_verification_record_id_idx ON arch_db.hh_fu_verification (record_id);
CREATE INDEX hh_hh_fu_verification_screening_id_idx ON arch_db.hh_fu_verification (hhv_hh_screening_id);
