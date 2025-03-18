DROP TABLE IF EXISTS arch_etl_db.crt_ra_fu_accrual;
CREATE TABLE arch_etl_db.crt_ra_fu_accrual
(
    id                           int         NOT NULL primary key AUTO_INCREMENT,
    ra_name                      VARCHAR(32) NOT NULL,
    date                         DATE        NOT NULL,
    wra_followed_up              int         not null,
    wra_followed_up_and_screened int         not null
);
CREATE INDEX acc_ra_name_idx ON arch_etl_db.crt_ra_fu_accrual (ra_name);
CREATE FULLTEXT INDEX acc_ft_idx ON arch_etl_db.crt_ra_fu_accrual (ra_name);