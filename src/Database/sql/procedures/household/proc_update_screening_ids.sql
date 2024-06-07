/**
 * Populates HH Screening ID for HH Enumeration and Verbal Consent.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 06.09.23
 * @since 0.0.1
 * @alias Update Household Screening ID Data
 */
DROP PROCEDURE IF EXISTS `UpdateHouseholdScreeningIDData`;

DELIMITER $$
CREATE PROCEDURE UpdateHouseholdScreeningIDData()
BEGIN
    -- Update HH Screening ID
    UPDATE hh_enumeration hhe
        LEFT JOIN
        hh_screening hh ON hhe.record_id = hh.record_id
    SET hhe.hh_scrn_num_obsloc = hh.hh_scrn_num_obsloc
    WHERE hhe.record_id = hh.record_id;

    -- Update HH Screening ID in VC
    UPDATE hh_verbal_consent hhvc
        LEFT JOIN
        hh_screening hh ON hhvc.record_id = hh.record_id
    SET hhvc.hh_scrn_num_obsloc = hh.hh_scrn_num_obsloc
    WHERE hhvc.record_id = hh.record_id;

END $$

DELIMITER ;
