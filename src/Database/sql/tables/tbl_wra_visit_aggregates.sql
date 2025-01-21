DROP TABLE IF EXISTS arch_etl_db.crt_visit_aggregates;
CREATE TABLE arch_etl_db.crt_visit_aggregates
(
    record_id                      BIGINT      NOT NULL,
    screening_id                   VARCHAR(14) NOT NULL,
    wra_ptid                       VARCHAR(6)  NOT NULL,
    first_follow_up_visit_outcome  TINYTEXT,
    second_follow_up_visit_outcome TINYTEXT,
    third_follow_up_visit_outcome  TINYTEXT,
    fourth_follow_up_visit_outcome TINYTEXT,
    fifth_follow_up_visit_outcome  TINYTEXT,
    total_incomplete_follow_up_visits         SMALLINT    NULL,
    total_missed_follow_up_visits         SMALLINT    NULL,
    total_complete_follow_up_visits         SMALLINT    NULL
);
CREATE unique INDEX crt_visits_wra_ptid_idx ON arch_etl_db.crt_visit_aggregates (wra_ptid);

INSERT INTO crt_visit_aggregates(record_id, screening_id, wra_ptid)
SELECT v1.record_id, v1.screening_id, v1.wra_ptid
FROM wra_overview v1
ORDER BY v1.screening_id;

-- FU1: Attempted Follow-Ups
UPDATE crt_visit_aggregates v
    LEFT JOIN vw_wra_first_fu_visit_overview v1 ON v1.wra_ptid = v.wra_ptid
SET v.first_follow_up_visit_outcome = v1.visit_status
WHERE v.record_id = v1.record_id;

-- FU1: Missed Follow-Ups
UPDATE crt_visit_aggregates v
SET v.first_follow_up_visit_outcome = 'Missed'
WHERE v.record_id NOT IN (SELECT v1.record_id FROM vw_wra_first_fu_visit_overview v1);

-- FU2: Attempted Follow-Ups
UPDATE crt_visit_aggregates v
    LEFT JOIN vw_wra_second_fu_visit_overview v2 ON v2.wra_ptid = v.wra_ptid
SET v.second_follow_up_visit_outcome = v2.visit_status
WHERE v.record_id = v2.record_id;

-- FU2: Missed Follow-Ups
UPDATE crt_visit_aggregates v
SET v.second_follow_up_visit_outcome = 'Missed'
WHERE v.record_id NOT IN (SELECT v2.record_id FROM vw_wra_second_fu_visit_overview v2);

-- FU3: Attempted Follow-Ups
UPDATE crt_visit_aggregates v
    LEFT JOIN vw_wra_third_fu_visit_overview v3 ON v3.wra_ptid = v.wra_ptid
SET v.third_follow_up_visit_outcome = v3.visit_status
WHERE v.record_id = v3.record_id;

-- FU3: Missed Follow-Ups
UPDATE crt_visit_aggregates v
SET v.third_follow_up_visit_outcome = 'Missed'
WHERE v.record_id IN (SELECT v2.record_id FROM vw_wra_third_fu_missed_visit v2);

-- FU3: Pending Follow-Ups
UPDATE crt_visit_aggregates v
SET v.third_follow_up_visit_outcome = 'Pending'
WHERE v.record_id NOT IN (SELECT v2.record_id FROM vw_wra_third_fu_missed_visit v2)
  AND (v.third_follow_up_visit_outcome = '' OR v.third_follow_up_visit_outcome IS NULL);

-- FU4: Attempted Follow-Ups
UPDATE crt_visit_aggregates v
    LEFT JOIN vw_wra_fourth_fu_visit_overview v4 ON v4.wra_ptid = v.wra_ptid
SET v.fourth_follow_up_visit_outcome = v4.visit_status
WHERE v.record_id = v4.record_id;

-- FU4: Missed Follow-Ups
UPDATE crt_visit_aggregates v
SET v.fourth_follow_up_visit_outcome = 'Missed'
WHERE v.record_id IN (SELECT v4.record_id FROM vw_wra_fourth_fu_missed_visit v4);

-- FU4: Pending Follow-Ups
UPDATE crt_visit_aggregates v
SET v.fourth_follow_up_visit_outcome = 'Pending'
WHERE v.record_id NOT IN (SELECT v4.record_id FROM vw_wra_fourth_fu_missed_visit v4)
  AND (v.fourth_follow_up_visit_outcome = '' OR v.fourth_follow_up_visit_outcome IS NULL);

-- FU5: Pending Follow-Ups
UPDATE crt_visit_aggregates v
SET v.fifth_follow_up_visit_outcome = 'Pending'
WHERE v.record_id > 0;

-- Aggregates
UPDATE crt_visit_aggregates v
SET v.total_incomplete_follow_up_visits = get_WRA_Tx_Incomplete_Visits(v.wra_ptid),
    v.total_missed_follow_up_visits = get_WRA_Tx_Missed_Visits(v.wra_ptid),
    v.total_complete_follow_up_visits = get_WRA_Tx_Completed_Visits(v.wra_ptid)
WHERE v.record_id > 0;