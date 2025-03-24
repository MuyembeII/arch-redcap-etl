DROP TABLE IF EXISTS arch_etl_db.wra_overview;
CREATE TABLE arch_etl_db.wra_overview
(
    record_id    INT         NOT NULL primary key,
    wra_ptid     VARCHAR(6)  NOT NULL,
    member_id    SMALLINT    NOT NULL,
    screening_id VARCHAR(14) NOT NULL,
    age          SMALLINT    NOT NULL
);
CREATE UNIQUE INDEX wra_record_id_idx ON arch_etl_db.wra_overview (record_id);
CREATE INDEX wra_ptid_idx ON arch_etl_db.wra_overview (wra_ptid);

INSERT INTO arch_etl_db.wra_overview(record_id, wra_ptid, member_id, screening_id, age)
SELECT record_id,
       wra_ptid,
       member_id,
       screening_id,
       age
FROM (SELECT wra_enr.root_id                                    as id,
             wra_enr.record_id,
             ROW_NUMBER() OVER (
                 PARTITION BY wra_enr.record_id
                 ORDER BY wra_enr.redcap_repeat_instance DESC ) as visit_id,
             TRIM(wra_enr.wra_ptid)                             as wra_ptid,
             wra_enr.hhe_hh_member_id                           as member_id,
             get_WRA_HH_Screening_ID(wra_enr.record_id)         as screening_id,
             wra_enr.wra_age                                    as age
      FROM wra_forms_repeating_instruments wra_enr
      WHERE wra_enr.wra_age > 0) e
WHERE e.visit_id = 1;

