DROP TABLE IF EXISTS arch_etl_db.crt_visit_aggregates;
CREATE TABLE arch_etl_db.crt_visit_aggregates
(
    record_id                         BIGINT      NOT NULL,
    screening_id                      VARCHAR(14) NOT NULL,
    wra_ptid                          VARCHAR(6)  NOT NULL,
    first_follow_up_visit_outcome     TINYTEXT,
    second_follow_up_visit_outcome    TINYTEXT,
    third_follow_up_visit_outcome     TINYTEXT,
    fourth_follow_up_visit_outcome    TINYTEXT,
    fifth_follow_up_visit_outcome     TINYTEXT,
    total_incomplete_follow_up_visits SMALLINT    NULL,
    total_missed_follow_up_visits     SMALLINT    NULL,
    total_complete_follow_up_visits   SMALLINT    NULL
);
CREATE unique INDEX crt_visits_wra_ptid_idx ON arch_etl_db.crt_visit_aggregates (wra_ptid);