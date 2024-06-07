DROP TABLE IF EXISTS arch_db.crt_revisits_2;
CREATE TABLE arch_db.crt_revisits_2
(
    id                SMALLINT    NOT NULL,
    record_id         SMALLINT,
    screening_id      VARCHAR(14),
    wra_ptid          VARCHAR(6),
    member_id         SMALLINT    NOT NULL,
    interviewer       VARCHAR(32) NOT NULL,
    wra               VARCHAR(32) NOT NULL,
    age      SMALLINT    NOT NULL,
    last_attempt      SMALLINT    NOT NULL,
    last_attempt_date DATE        NOT NULL,
    return_date       DATE,
    return_time       VARCHAR(16),
    days_due          SMALLINT    NOT NULL
);
