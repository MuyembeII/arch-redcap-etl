DROP TABLE IF EXISTS arch_db.wra_clinical_referral;
CREATE TABLE IF NOT EXISTS arch_db.wra_clinical_referral
(
    id                         MEDIUMINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    record_id                  MEDIUMINT UNSIGNED NOT NULL,
    redcap_event_name          VARCHAR(32)        NOT NULL,
    redcap_repeat_instrument   VARCHAR(32)        NOT NULL,
    redcap_repeat_instance     TINYINT            NOT NULL,
    cr_interviewer_obsloc      VARCHAR(32),
    cr_visit_date              DATE,
    cr_wra_ptid                VARCHAR(6),
    cr_refer_to                TINYINT,
    cr_refer_to_other          VARCHAR(64),
    referral_reasons_1         TINYINT,
    referral_reasons_2         TINYINT,
    referral_reasons_3         TINYINT,
    referral_reasons_4         TINYINT,
    referral_reasons_5         TINYINT,
    referral_reasons_6         TINYINT,
    referral_reasons_7         TINYINT,
    referral_reasons_other     TINYTEXT,
    cr_ra_comments_yn          BIT,
    cr_ra_comments             TINYTEXT,
    clinical_referral_complete TINYINT
);
CREATE INDEX cr_record_id_idx ON arch_db.wra_clinical_referral (record_id);
CREATE INDEX cr_wra_ptid_idx ON arch_db.wra_clinical_referral (cr_wra_ptid);
CREATE INDEX cr_interviewer_obsloc_idx ON arch_db.wra_clinical_referral (cr_interviewer_obsloc);
