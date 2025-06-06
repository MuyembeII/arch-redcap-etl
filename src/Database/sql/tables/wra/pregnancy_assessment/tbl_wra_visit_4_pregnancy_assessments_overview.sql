DROP TABLE IF EXISTS arch_etl_db.crt_wra_visit_4_pregnancy_assessments_overview;
CREATE TABLE arch_etl_db.crt_wra_visit_4_pregnancy_assessments_overview
(
    record_id                                  BIGINT         NOT NULL PRIMARY KEY,
    wra_ptid                                   VARCHAR(6)     NOT NULL,
    member_id                                  SMALLINT       NOT NULL,
    screening_id                               VARCHAR(14)    NOT NULL,
    age                                        SMALLINT       NOT NULL,
    ra                                         VARCHAR(32)    NOT NULL,
    visit_number                               DECIMAL(10, 1) NOT NULL,
    visit_name                                 VARCHAR(64)    NOT NULL,
    visit_date                                 DATE           NOT NULL,
    /* WRA New Pregnancy*/
    pregnancy_id                               VARCHAR(32),
    upt_result                                 ENUM ('Negative', 'Positive'),
    zapps_enrollment_status                    VARCHAR(32),
    zapps_ptid                                 VARCHAR(16),
    zapps_ptid_source                          VARCHAR(16),
    pregnancy_identified_by_arch               ENUM ('No', 'Yes'),
    pregnancy_has_antenatal_care               ENUM ('No', 'Yes'),
    anc_visit_count                            TINYINT,
    anc_attendance_plan                        ENUM ('No', 'Yes'),
    planned_place_for_birth                    TINYTEXT,
    place_for_birth_planner                    TINYTEXT,
    /* WRA Health Behaviors in Pregnancy*/
    alcoholic_consumption_during_pregnancy     ENUM ('No', 'Yes'),
    alcoholic_consumption_frequency            VARCHAR(16),
    tobacco_consumption_during_pregnancy       ENUM ('No', 'Yes'),
    tobacco_consumption_frequency              VARCHAR(16),
    other_tobacco_consumption_during_pregnancy TINYTEXT,
    street_drugs_consumption_during_pregnancy  ENUM ('No', 'Yes'),
    street_drug_consumption_frequency          VARCHAR(16),
    drugs_consumed_during_pregnancy            TINYTEXT,
    /* WRA ZAPPS Referrals */
    zapps_referral_outcome                     ENUM ('Declined', 'Accepted'),
    zapps_referral_declined_reasons            TINYTEXT,
    preferred_zapps_clinic                     VARCHAR(32),
    preferred_zapps_appointment_date           DATE,
    pregnancy_identifier                       TINYTEXT,
    first_positive_upt_date                    DATE,
    first_ultra_sound_date                     DATE,
    first_ultra_sound_by_edd                   DATE,
    lmp_date                                   DATE,
    ega_by_lmp                                 NUMERIC(4, 1),
    edd_by_ega                                 DATE,
    zapps_referral_comments                    MEDIUMTEXT
);
CREATE UNIQUE INDEX pa_4_record_id_idx ON arch_etl_db.crt_wra_visit_4_pregnancy_assessments_overview (record_id);
CREATE UNIQUE INDEX pa_4_wra_ptid_idx ON arch_etl_db.crt_wra_visit_4_pregnancy_assessments_overview (wra_ptid);
CREATE INDEX pa_4_visit_number_idx ON arch_etl_db.crt_wra_visit_4_pregnancy_assessments_overview (visit_number);
CREATE INDEX pa_4_visit_name_idx ON arch_etl_db.crt_wra_visit_4_pregnancy_assessments_overview (visit_name);
CREATE INDEX pa_4_pregnancy_id_idx ON arch_etl_db.crt_wra_visit_4_pregnancy_assessments_overview (pregnancy_id);
CREATE INDEX pa_4_pregnancy_identified_by_arch_idx ON arch_etl_db.crt_wra_visit_4_pregnancy_assessments_overview (pregnancy_identified_by_arch);
CREATE INDEX pa_4_pregnancy_has_antenatal_care_idx ON arch_etl_db.crt_wra_visit_4_pregnancy_assessments_overview (pregnancy_has_antenatal_care);
CREATE INDEX pa_4_anc_attendance_plan_idx ON arch_etl_db.crt_wra_visit_4_pregnancy_assessments_overview (anc_attendance_plan);
CREATE INDEX pa_4_zapps_enrollment_status_idx ON arch_etl_db.crt_wra_visit_4_pregnancy_assessments_overview (zapps_enrollment_status);
CREATE INDEX pa_4_zapps_referral_outcome_idx ON arch_etl_db.crt_wra_visit_4_pregnancy_assessments_overview (zapps_referral_outcome);
CREATE INDEX pa_4_preferred_zapps_clinic_idx ON arch_etl_db.crt_wra_visit_4_pregnancy_assessments_overview (preferred_zapps_clinic);
CREATE INDEX pa_4_pregnancy_identifier_idx ON arch_etl_db.crt_wra_visit_4_pregnancy_assessments_overview (pregnancy_identifier);
CREATE FULLTEXT INDEX pa_4_ft_idx ON arch_etl_db.crt_wra_visit_4_pregnancy_assessments_overview (planned_place_for_birth,
                                                                                                 place_for_birth_planner,
                                                                                                 zapps_referral_declined_reasons);