DROP TABLE IF EXISTS arch_db.wra_biometrics;
CREATE TABLE IF NOT EXISTS arch_db.wra_biometrics
(
    id             int auto_increment primary key,
    participant_id VARCHAR(6) NOT NULL ,
    first_name     VARCHAR(36)         not null,
    last_name      VARCHAR(36)  not null,
    gender         VARCHAR(6) not null,
    age            SMALLINT      not null,
    contact        VARCHAR(10) not null
);
CREATE UNIQUE INDEX bio_participant_id_idx ON arch_db.wra_biometrics (participant_id);
