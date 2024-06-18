DROP TABLE IF EXISTS arch_etl_db.visit;
CREATE TABLE arch_etl_db.visit
(
    id                                 INT         NOT NULL primary key AUTO_INCREMENT,
    visit_id INT NOT NULL,
    visit_number DECIMAL(10,1) NOT NULL,
    visit_name VARCHAR(255) NOT NULL,
    visit_alias VARCHAR(255) NOT NULL
);
