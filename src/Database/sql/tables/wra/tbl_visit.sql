DROP TABLE IF EXISTS arch_etl_db.visit;
CREATE TABLE arch_etl_db.visit
(
    visit_id     SMALLINT       NOT NULL,
    visit_number DECIMAL(10, 1) NOT NULL,
    visit_title  VARCHAR(64)    NOT NULL,
    visit_name   VARCHAR(64)    NOT NULL,
    visit_alias  VARCHAR(64)    NOT NULL,
    PRIMARY KEY (visit_id)
);
CREATE INDEX visit_number_idx ON arch_etl_db.visit (visit_number);
CREATE UNIQUE INDEX visit_title_idx ON arch_etl_db.visit (visit_title);
CREATE UNIQUE INDEX visit_name_idx ON arch_etl_db.visit (visit_name);

-- Visit Details static data; HH Prescreening x WRA Screening REDCap events.
INSERT INTO arch_etl_db.visit(visit_id, visit_number, visit_title, visit_name, visit_alias)
VALUES (88, 0, 'Mapping and Listing', 'mapping_and_listin_arm_1', 'M & L'),
       (85, 1, 'Pre-screening', 'prescreening_arm_1', 'Baseline Visit'),
       (108, 2, 'Pre-screening Follow Up Visit', 'prescreening_follo_arm_1', 'First Follow-Up Visit'),
       (118, 3, 'Pre-screening Follow Up Visit2', 'prescreening_follo_arm_1b', 'Second Follow-Up Visit'),
       (98, 1, 'WRA Baseline', 'wra_baseline_arm_1', 'Baseline Visit'),
       (99, 2, 'WRA Follow-Up Visit', 'wra_followup_visit_arm_1', 'First Follow-Up Visit'),
       (116, 3, 'WRA Follow-Up Visit 2', 'wra_followup_visit_arm_1b', 'Second Follow-Up Visit'),
       (117, 4, 'WRA Follow-Up Visit 3', 'wra_followup_visit_arm_1c', 'Third Follow-Up Visit');