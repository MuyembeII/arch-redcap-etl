DROP TABLE IF EXISTS arch_db.crt_zapps_participants;
CREATE TABLE arch_db.crt_zapps_participants
(
    id                       MEDIUMINT,
    wra_enrollment_id        BIGINT      NOT NULL,
    household_member_id      SMALLINT    NOT NULL,
    wra_ptid                 VARCHAR(6)  NOT NULL,
    wra_name                 VARCHAR(64) NOT NULL,
    screening_id             VARCHAR(14) NOT NULL,
    date_of_birth            DATE        NOT NULL,
    date_of_arch_enrollment  DATE        NULL,
    date_of_zapps_referral   DATE        NULL,
    date_of_zapps_enrollment DATE        NULL,
    date_of_lmp              DATE        NULL,
    date_of_fp_upt_test      DATE        NULL,
    date_of_appointment      DATE        NULL,
    referred_by              VARCHAR(64) NOT NULL,
    enrolled_by              VARCHAR(64) NULL,
    week_of_zapps_screening  TINYINT     NULL,
    zapps_ptid               VARCHAR(11) NULL
);
CREATE UNIQUE INDEX crt_zapps_id_idx ON arch_db.crt_zapps_participants (id);
CREATE UNIQUE INDEX crt_zapps_wra_enrollment_id_idx ON arch_db.crt_zapps_participants (wra_enrollment_id);
CREATE UNIQUE INDEX crt_zapps_wra_ptid_idx ON arch_db.crt_zapps_participants (wra_ptid);
CREATE INDEX crt_zapps_screening_id_idx ON arch_db.crt_zapps_participants (screening_id);
