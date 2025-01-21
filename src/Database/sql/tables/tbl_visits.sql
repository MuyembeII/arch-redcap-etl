DROP TABLE IF EXISTS arch_etl_db.visit;
CREATE TABLE arch_etl_db.visit
(
    id           INT            NOT NULL primary key AUTO_INCREMENT,
    visit_id     INT            NOT NULL,
    visit_number DECIMAL(10, 1) NOT NULL,
    visit_name   VARCHAR(255)   NOT NULL,
    visit_alias  VARCHAR(255)   NOT NULL
);
CREATE INDEX visit_number_idx ON arch_etl_db.visit (visit_number);
CREATE INDEX visit_name_idx ON arch_etl_db.visit (visit_name);

INSERT INTO arch_etl_db.visit(visit_id, visit_number, visit_name, visit_alias)
VALUES (98, 1.0, 'wra_baseline_arm_1', 'WRA Baseline'),
       (99, 2.0, 'wra_followup_visit_arm_1', 'WRA Follow-Up Visit'),
       (116, 3.0, 'wra_followup_visit_arm_1b', 'WRA Follow-Up Visit 2'),
       (117, 4.0, 'wra_followup_visit_arm_1c', 'WRA Follow-Up Visit 3'),
       (117, 5.0, 'wra_followup_visit_arm_1d', 'WRA Follow-Up Visit 4');