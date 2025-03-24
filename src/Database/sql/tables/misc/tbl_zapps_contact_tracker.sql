DROP TABLE IF EXISTS arch_etl_db.zapps_wra_tracker;
CREATE TABLE arch_etl_db.zapps_wra_tracker
(
    id                                 INT         NOT NULL primary key AUTO_INCREMENT,
    arch_ptid                          VARCHAR(18) NOT NULL,
    redcap_event_name                  VARCHAR(23) NOT NULL,
    redcap_repeat_instrument           VARCHAR(26) NOT NULL,
    redcap_repeat_instance             SMALLINT    NOT NULL,
    contact_count                      SMALLINT    NOT NULL,
    contact_date                       DATE,
    contact_outcome                    MEDIUMTEXT,
    stop_calling                       SMALLINT    NOT NULL,
    new_apt_date                       DATE,
    cont1_notify                       VARCHAR(3),
    phone1_correction                  VARCHAR(3),
    correct_phone1                     INTEGER,
    contact_outcome_cor                TEXT,
    new_apt_date_3                     VARCHAR(30),
    contact_outcome_2                  TEXT,
    stop_calling_2                     SMALLINT    NOT NULL,
    cont1_notify_2                     VARCHAR(3),
    phone2_correction                  VARCHAR(2),
    correct_phone2                     VARCHAR(30),
    new_apt_date_2                     DATE,
    contact_notes                      TEXT,
    zappsarch_contact_tracker_complete VARCHAR(10) NOT NULL
);
