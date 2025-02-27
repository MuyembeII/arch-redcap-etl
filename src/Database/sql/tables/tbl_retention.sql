DROP TABLE IF EXISTS arch_etl_db.crt_wra_retention;
CREATE TABLE arch_etl_db.crt_wra_retention
(
    visit_id                     INT            NOT NULL,
    visit_number                 DECIMAL(10, 1) NOT NULL,
    visit_name                   VARCHAR(255)   NOT NULL,
    visit_alias                  VARCHAR(255)   NOT NULL,
    wra_visit_first_date         DATE,
    wra_visit_last_date          DATE,
    wra_visit_untraceable        SMALLINT,
    wra_visit_deferred           SMALLINT,
    wra_visit_extended_absence   SMALLINT,
    wra_visit_missed_appointment SMALLINT,
    wra_visits_total             SMALLINT,
    wra_screened                 SMALLINT,
    wra_screened_and_followed_up SMALLINT,
    wra_visit_total_remaining    SMALLINT
);

INSERT INTO crt_wra_retention(visit_id, visit_number, visit_name, visit_alias)
SELECT v.visit_id, v.visit_number, v.visit_name, v.visit_alias
FROM visit v
