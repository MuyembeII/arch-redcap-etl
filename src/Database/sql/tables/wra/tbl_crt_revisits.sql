DROP TABLE IF EXISTS arch_db.crt_revisits;
CREATE TABLE arch_db.crt_revisits
(
    id           SMALLINT         NOT NULL,
    record_id    SMALLINT,
    ra_name      VARCHAR(32) NOT NULL,
    cluster      VARCHAR(3),
    member_id    SMALLINT         NOT NULL,
    last_attempt    SMALLINT         NOT NULL,
    screening_id varchar(14),
    screening_date  DATE,
    return_date  DATE,
    days_due     SMALLINT         NOT NULL
);
