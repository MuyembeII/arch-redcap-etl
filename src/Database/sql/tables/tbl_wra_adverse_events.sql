DROP TABLE IF EXISTS arch_etl_db.crt_wra_adverse_events;
CREATE TABLE arch_etl_db.crt_wra_adverse_events
(
    record_id                         INT            NOT NULL,
    alternate_id                      INT            NOT NULL,
    wra_ptid                          VARCHAR(6)     NOT NULL,
    member_id                         SMALLINT       NOT NULL,
    screening_id                      VARCHAR(14)    NOT NULL,
    age                               SMALLINT       NOT NULL,
    dob                               DATE           NULL,
    visit_number                      DECIMAL(10, 1) NOT NULL,
    visit_name                        VARCHAR(64)    NOT NULL,
    visit_date                        DATE           NOT NULL,
    primary_adverse_event             MEDIUMTEXT     NOT NULL,
    date_of_onset_of_ae               DATE,
    is_serious_adverse_event          ENUM ('No', 'Yes'),
    serious_adverse_event_type        VARCHAR(128),
    medical_attention_seeked_by_wra   VARCHAR(64),
    date_of_hospitalization           DATE,
    date_of_site_awareness_of_sae     DATE,
    study_related_adverse_event       ENUM ('No', 'Yes'),
    nature_severity_freq_expected_sae VARCHAR(16),
    outcome_of_sae                    VARCHAR(24),
    date_of_death                     DATE,
    time_of_death                     TIME,
    date_of_hospital_discharge        DATE,
    comments                          MEDIUMTEXT,
    PRIMARY KEY (record_id, alternate_id)
);
CREATE UNIQUE INDEX ae_record_id_idx ON arch_etl_db.crt_wra_adverse_events (record_id);
CREATE UNIQUE INDEX ae_wra_ptid_idx ON arch_etl_db.crt_wra_adverse_events (wra_ptid);
CREATE UNIQUE INDEX ae_alternate_id_idx ON arch_etl_db.crt_wra_adverse_events (alternate_id);
CREATE INDEX ae_screening_id_idx ON arch_etl_db.crt_wra_adverse_events (screening_id);
CREATE INDEX ae_age_idx ON arch_etl_db.crt_wra_adverse_events (age);
CREATE INDEX ae_visit_number_idx ON arch_etl_db.crt_wra_adverse_events (visit_number);
CREATE INDEX ae_visit_name_idx ON arch_etl_db.crt_wra_adverse_events (visit_name);
CREATE INDEX ae_visit_date_idx ON arch_etl_db.crt_wra_adverse_events (visit_date);
CREATE INDEX ae_is_serious_adverse_event_idx ON arch_etl_db.crt_wra_adverse_events (is_serious_adverse_event);
CREATE INDEX ae_is_serious_adverse_event_type_idx ON arch_etl_db.crt_wra_adverse_events (serious_adverse_event_type);
CREATE INDEX ae_medical_attention_seeked_by_wra_idx ON arch_etl_db.crt_wra_adverse_events (medical_attention_seeked_by_wra);
CREATE INDEX ae_study_related_adverse_event_idx ON arch_etl_db.crt_wra_adverse_events (study_related_adverse_event);
CREATE INDEX ae_outcome_of_sae_idx ON arch_etl_db.crt_wra_adverse_events (outcome_of_sae);
CREATE FULLTEXT INDEX ae_ft_idx ON crt_wra_adverse_events (primary_adverse_event,
                                                           outcome_of_sae);