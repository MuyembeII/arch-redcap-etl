DROP TABLE IF EXISTS arch_db.wra_locator;
CREATE TABLE IF NOT EXISTS arch_db.wra_locator
(
    record_id                  BIGINT UNSIGNED NOT NULL PRIMARY KEY,
    redcap_event_name          VARCHAR(32)     NOT NULL,
    redcap_repeat_instrument   VARCHAR(32)     NOT NULL,
    redcap_repeat_instance     SMALLINT        NOT NULL,
    hh_scrn_num_obsloc         VARCHAR(14)     NOT NULL,
    hhe_hh_member_id           SMALLINT        NOT NULL,
    scrn_obsstdat              DATE,
    wra_enr_interviewer_obsloc MEDIUMTEXT      NOT NULL,
    wra_ptid                   VARCHAR(6)      NOT NULL,
    loc_fc_num                 VARCHAR(11)     NOT NULL,
    loc_pn_belongs             TINYINT         NOT NULL,
    loc_pn_belongs_oth         VARCHAR(32),
    loc_who_is_caller          VARCHAR(64)     NOT NULL,
    loc_other_contacts         BIT             NOT NULL,
    loc_sc_num                 VARCHAR(11)     NULL,
    loc_pn_belongs_2           TINYINT,
    loc_pn_belongs_oth_2       VARCHAR(32),
    loc_who_is_caller_2        VARCHAR(64),
    loc_other_contacts_2       BIT,
    loc_tc_num                 VARCHAR(11),
    loc_pn_belongs_3           TINYINT,
    loc_pn_belongs_oth_3       TINYTEXT,
    loc_who_is_caller_3        VARCHAR(32),
    loc_other_contacts_3       TINYINT,
    loc_enrolled_zapps         TINYINT         NOT NULL,
    loc_zapps_ptid             VARCHAR(11),
    loc_zapps_ptid_src         TINYINT,
    famliid_yn                 INTEGER         NOT NULL,
    famli_id_scorres           VARCHAR(15),
    loc_famli_id_src           TINYINT,
    loc_comments_yn            BIT             NOT NULL,
    loc_comments               MEDIUMTEXT
);

CREATE UNIQUE INDEX loc_wra_ptid_idx ON arch_db.wra_locator (wra_ptid);
CREATE INDEX loc_hh_scrn_num_obsloc_idx ON arch_db.wra_locator (hh_scrn_num_obsloc);
