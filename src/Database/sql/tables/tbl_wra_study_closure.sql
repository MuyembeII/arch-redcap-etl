DROP TABLE IF EXISTS arch_etl_db.crt_wra_study_closure;
CREATE TABLE arch_etl_db.crt_wra_study_closure
(
    record_id                  INT                NOT NULL,
    alternate_id               INT                NOT NULL,
    wra_ptid                   VARCHAR(6)         NOT NULL,
    member_id                  SMALLINT           NOT NULL,
    screening_id               VARCHAR(14)        NOT NULL,
    age                        SMALLINT           NOT NULL,
    dob                        DATE               NULL,
    visit_number               DECIMAL(10, 1)     NOT NULL,
    visit_name                 VARCHAR(255)       NOT NULL,
    visit_date                 DATE               NOT NULL,
    is_serious_adverse_event   ENUM ('No', 'Yes') NOT NULL,
    serious_adverse_event_code TINYTEXT,
    study_termination_reason   TINYTEXT           NOT NULL,
    date_of_death              DATE,
    cause_of_death             TINYTEXT,
    reason_for_withdraw TINYTEXT,
    PRIMARY KEY (record_id, alternate_id)
);
CREATE UNIQUE INDEX sc_record_id_idx ON arch_etl_db.crt_wra_study_closure (record_id);
CREATE UNIQUE INDEX sc_wra_ptid_idx ON arch_etl_db.crt_wra_study_closure (wra_ptid);
CREATE UNIQUE INDEX sc_alternate_id_idx ON arch_etl_db.crt_wra_study_closure (alternate_id);
CREATE INDEX sc_screening_id_idx ON arch_etl_db.crt_wra_study_closure (screening_id);
CREATE INDEX sc_age_idx ON arch_etl_db.crt_wra_study_closure (age);
CREATE INDEX sc_visit_number_idx ON arch_etl_db.crt_wra_study_closure (visit_number);
CREATE INDEX sc_visit_name_idx ON arch_etl_db.crt_wra_study_closure (visit_name);
CREATE INDEX sc_visit_date_idx ON arch_etl_db.crt_wra_study_closure (visit_date);
CREATE INDEX sc_is_serious_adverse_event_idx ON arch_etl_db.crt_wra_study_closure (is_serious_adverse_event);
CREATE INDEX sc_serious_adverse_event_code_idx ON arch_etl_db.crt_wra_study_closure (serious_adverse_event_code);
CREATE INDEX sc_study_termination_reason_idx ON arch_etl_db.crt_wra_study_closure (study_termination_reason);
CREATE INDEX sc_reason_for_withdraw_idx ON arch_etl_db.crt_wra_study_closure (reason_for_withdraw);

