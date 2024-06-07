DROP TABLE IF EXISTS arch_db.crt_ra_accrual;
CREATE TABLE arch_db.crt_ra_accrual
(
    id                   int         NOT NULL primary key AUTO_INCREMENT,
    ra_name              VARCHAR(32) NOT NULL,
    date                 DATE        NOT NULL,
    household_screened   int         not null,
    hh_visit_completed   int         not null,
    hh_visit_incomplete  int         not null,
    wra_screened         int         not null,
    wra_enrolled         int         not null,
    wra_fu_screened         int         not null,
    wra_fu_enrolled         int         not null,
    wra_visit_completed  int         not null,
    wra_visit_incomplete int         not null
);
