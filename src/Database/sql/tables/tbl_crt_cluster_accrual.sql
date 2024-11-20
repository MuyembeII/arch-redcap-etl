DROP TABLE IF EXISTS arch_db.crt_cluster_accrual;
CREATE TABLE arch_db.crt_cluster_accrual
(
    id                          MEDIUMINT NOT NULL primary key AUTO_INCREMENT,
    cluster                     VARCHAR(3),
    household_screened          MEDIUMINT NOT NULL,
    hh_visit_completed          MEDIUMINT NOT NULL,
    hh_visit_incomplete         MEDIUMINT NOT NULL,
    household_not_found         MEDIUMINT NOT NULL,
    household_vacant            MEDIUMINT NOT NULL,
    household_destroyed         MEDIUMINT NOT NULL,
    household_vc_declined       MEDIUMINT NOT NULL,
    household_vc_deferred       MEDIUMINT NOT NULL,
    household_vc_absence        MEDIUMINT NOT NULL,
    household_no_adult          MEDIUMINT NOT NULL,
    hh_enum_ineligible_by_age   MEDIUMINT NOT NULL,
    hh_enum_eligible            MEDIUMINT NOT NULL,
    household_dnu_enb           MEDIUMINT NOT NULL,
    wra_screened                MEDIUMINT NOT NULL,
    wra_enrolled                MEDIUMINT NOT NULL,
    wra_visit_completed         MEDIUMINT NOT NULL,
    wra_visit_incomplete        MEDIUMINT NOT NULL,
    wra_withdraw                MEDIUMINT NOT NULL,
    wra_unavailable             MEDIUMINT NOT NULL,
    wra_declined                MEDIUMINT NOT NULL,
    wra_deferments              MEDIUMINT NOT NULL,
    wra_extended_absence        MEDIUMINT NOT NULL,
    wra_untraceable             MEDIUMINT NOT NULL,
    wra_dnu_enb                 MEDIUMINT NOT NULL,
    wra_mental_phys_challenged  MEDIUMINT NOT NULL,
    wra_vaginal_swabs_collected MEDIUMINT NOT NULL,
    wra_zapps_referrals         MEDIUMINT NOT NULL,
    wra_clinical_referrals      MEDIUMINT NOT NULL,
    wra_pregnancies             MEDIUMINT NOT NULL
);
CREATE UNIQUE INDEX crt_cluster_id_idx ON arch_db.crt_cluster_accrual (cluster);