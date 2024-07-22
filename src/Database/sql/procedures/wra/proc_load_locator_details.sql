DROP PROCEDURE IF EXISTS `Load_WRA_Locator_Details`;

DELIMITER $$
CREATE PROCEDURE Load_WRA_Locator_Details()
BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND, 1062
        BEGIN
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error =
                    CONCAT_WS(' ', 'ERROR - Failed to load WRA Locator Details;', '|', @errno, '(', @sqlstate,
                              '):', @text);
            SELECT @full_error;
            RESIGNAL;
        END;


    START TRANSACTION;
    TRUNCATE TABLE arch_etl_db.crt_wra_locator;
    -- Insert base data, fetch latest record by selecting max instance/visit number
    INSERT INTO arch_etl_db.crt_wra_locator (record_id, screening_id, member_id, screening_date, wra_ptid, wra_name,
                                             age, first_contact_number)
    SELECT DISTINCT loc.record_id,
                    TRIM(loc.screening_id) as screening_id,
                    loc.member_id,
                    loc.screening_date     as date_of_enrollment,
                    TRIM(loc.wra_ptid)     as wra_ptid,
                    REPLACE(CONCAT_WS(' ', TRIM(loc.first_name), TRIM(loc.middle_name), TRIM(loc.last_name)), '  ',
                            ' ')            as wra_name,
                    loc.age                as age,
                    wfri.loc_fc_num        as first_contact_number
    FROM vw_wra_enrolled loc
             LEFT JOIN wra_forms_repeating_instruments wfri on loc.record_id = wfri.record_id
    WHERE loc.age > 0
      AND wfri.loc_fc_num IS NOT NULL
    ORDER BY loc.screening_id;
    COMMIT;

END $$

DELIMITER ;
