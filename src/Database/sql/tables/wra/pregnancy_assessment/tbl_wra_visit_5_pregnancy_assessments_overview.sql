DROP TABLE IF EXISTS arch_etl_db.crt_wra_visit_5_pregnancy_assessments_overview;
CREATE TABLE arch_etl_db.crt_wra_visit_5_pregnancy_assessments_overview
(
    record_id                                 INT            NOT NULL PRIMARY KEY,
    wra_ptid                                  VARCHAR(6)     NOT NULL,
    member_id                                 SMALLINT       NOT NULL,
    screening_id                              VARCHAR(14)    NOT NULL,
    age                                       SMALLINT       NOT NULL,
    ra                                        VARCHAR(32)    NOT NULL,
    visit_number                              DECIMAL(10, 1) NOT NULL,
    visit_name                                VARCHAR(64)    NOT NULL,
    visit_date                                DATE           NOT NULL,
    pregnancy_id                              VARCHAR(32),
    zapps_enrollment_status                   VARCHAR(32),
    zapps_ptid                                VARCHAR(16),
    zapps_ptid_source                         VARCHAR(16),
    pregnancy_identified_by_arch              ENUM ('No', 'Yes'),
    pregnancy_has_antenatal_care              ENUM ('No', 'Yes'),
    anc_visit_count                           TINYINT,
    anc_attendance_plan                       ENUM ('No', 'Yes', 'Don''t know', ''),
    planned_place_for_birth                   TINYTEXT,
    place_for_birth_planner                   TINYTEXT,
    alcoholic_consumption_during_pregnancy    ENUM ('No', 'Yes'),
    alcoholic_consumption_frequency           VARCHAR(16),
    tobacco_consumption_during_pregnancy      ENUM ('No', 'Yes'),
    tobacco_consumption_frequency             VARCHAR(16),
    street_drugs_consumption_during_pregnancy ENUM ('No', 'Yes'),
    street_drug_consumption_frequency         VARCHAR(16),
    zapps_referral_outcome                    ENUM ('Accepted', 'Declined'),
    preferred_zapps_clinic                    VARCHAR(32)
);
CREATE INDEX pa_5_wra_ptid_idx ON arch_etl_db.crt_wra_visit_5_pregnancy_assessments_overview (wra_ptid);
CREATE INDEX pa_5_visit_number_idx ON arch_etl_db.crt_wra_visit_5_pregnancy_assessments_overview (visit_number);
CREATE INDEX pa_5_visit_name_idx ON arch_etl_db.crt_wra_visit_5_pregnancy_assessments_overview (visit_name);
CREATE INDEX pa_5_pregnancy_id_idx ON arch_etl_db.crt_wra_visit_5_pregnancy_assessments_overview (pregnancy_id);
CREATE INDEX pa_5_pregnancy_identified_by_arch_idx ON arch_etl_db.crt_wra_visit_5_pregnancy_assessments_overview (pregnancy_identified_by_arch);
CREATE INDEX pa_5_zapps_enrollment_status_idx ON arch_etl_db.crt_wra_visit_5_pregnancy_assessments_overview (zapps_enrollment_status);
CREATE INDEX pa_5_zapps_referral_outcome_idx ON arch_etl_db.crt_wra_visit_5_pregnancy_assessments_overview (zapps_referral_outcome);