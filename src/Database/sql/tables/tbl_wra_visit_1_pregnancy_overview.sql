DROP TABLE IF EXISTS arch_etl_db.crt_wra_visit_1_pregnancy_overview;
CREATE TABLE arch_etl_db.crt_wra_visit_1_pregnancy_overview
(
    record_id                      INT            NOT NULL PRIMARY KEY,
    wra_ptid                       VARCHAR(6)     NOT NULL,
    member_id                      SMALLINT       NOT NULL,
    screening_id                   VARCHAR(14)    NOT NULL,
    age                            SMALLINT       NOT NULL,
    ra                             VARCHAR(32)    NOT NULL,
    visit_number                   DECIMAL(10, 1) NOT NULL,
    visit_name                     VARCHAR(255)   NOT NULL,
    visit_date                     DATE           NOT NULL,
    has_pregnancy_hx               TINYTEXT,
    pregnancy_count                SMALLINT,
    live_birth_count               SMALLINT,
    loss_count                     SMALLINT,
    spontaneous_miscarriages_count SMALLINT,
    still_birth_count              SMALLINT,
    has_menstruals                 TINYTEXT,
    no_menstruals_reason           TINYTEXT,
    currently_pregnant             TINYTEXT,
    pregnancy_identifier           TINYTEXT
);
CREATE UNIQUE INDEX visit_1_pregnancy_wra_ptid_idx ON arch_etl_db.crt_wra_visit_1_pregnancy_overview (wra_ptid);

INSERT INTO arch_etl_db.crt_wra_visit_1_pregnancy_overview(record_id,
                                                           wra_ptid,
                                                           member_id,
                                                           screening_id,
                                                           age,
                                                           ra,
                                                           visit_number,
                                                           visit_name,
                                                           visit_date)
SELECT v1.record_id,
       v1.wra_ptid,
       v1.member_id,
       v1.screening_id,
       v1.age,
       v1.ra,
       v1.visit_number,
       v1.visit_name,
       v1.visit_date
FROM crt_wra_visit_1_overview v1
GROUP BY v1.visit_date, v1.screening_id
ORDER BY v1.visit_date DESC;

UPDATE crt_wra_visit_1_pregnancy_overview v1
    LEFT JOIN wra_pregnancy_overview_and_surveillance pos_v1 ON v1.record_id = pos_v1.record_id
SET v1.has_pregnancy_hx               = IF(pos_v1.ph_prev_rporres = 1, 'Yes',
                                           IF(pos_v1.ph_prev_rporres = 0, 'No', pos_v1.ph_prev_rporres)),
    v1.pregnancy_count                = pos_v1.pho_num_preg_rporres,
    v1.live_birth_count               = pos_v1.ph_live_rporres,
    v1.loss_count                     = pos_v1.pho_loss_count,
    v1.spontaneous_miscarriages_count = pos_v1.ph_bs_rporres,
    v1.still_birth_count              = pos_v1.stlb_num_rporres,
    v1.has_menstruals                 = IF(pos_v1.lmp_reg_scorres = 1, 'Yes',
                                           IF(pos_v1.lmp_reg_scorres = 0, 'No', pos_v1.lmp_reg_scorres)),
    v1.no_menstruals_reason           = IF(pos_v1.lmp_kd_scorres = 96,
                                           CONCAT_WS(' - ', 'Other', pos_v1.lmp_kd_scorres_other),
                                           pos_v1.lmp_kd_scorres_label),
    v1.currently_pregnant             = pos_v1.preg_scorres_label,
    v1.pregnancy_identifier           = pos_v1.np_pregid_mhyn_label
WHERE v1.record_id = pos_v1.record_id;