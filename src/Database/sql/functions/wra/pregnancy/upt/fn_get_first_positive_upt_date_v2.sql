/**
 * Get FU-1 First Positive UPT Date, for either Self test or Facility test
 *
 * @author Gift Jr <muyembegift@gmail.com> | 04.05.25
 * @since 0.0.1
 * @alias Get First UPT Date | getFirstPositive_UPT_Date_V2 .
 * @param BIGINT | Record ID
 * @return DATE | first positive UPT date
 */
DROP FUNCTION IF EXISTS `getFirstPositive_UPT_Date_V2`;
DELIMITER $$
CREATE FUNCTION getFirstPositive_UPT_Date_V2(p_record_id BIGINT)
    RETURNS DATE
    NOT DETERMINISTIC
BEGIN
    DECLARE v_first_positive_upt_date_v2 DATE;
    DECLARE v_pregnancy_id_type TINYTEXT;
    DECLARE v_self_upt_date VARCHAR(16);
    DECLARE v_facility_upt_date VARCHAR(16);
    SELECT pos_v2.fu_np_pregid_mhyn, TRIM(pos_v2.fu_np_date_of_test), TRIM(pos_v2.fu_np_date_of_test_2)
    INTO v_pregnancy_id_type, v_self_upt_date, v_facility_upt_date
    FROM wrafu_pregnancy_surveillance pos_v2
    WHERE CAST(pos_v2.record_id as UNSIGNED) = p_record_id;
    IF v_pregnancy_id_type = 1 THEN
        SET v_first_positive_upt_date_v2 = use_ISO_DateTrimmer(v_self_upt_date);
    ELSEIF v_pregnancy_id_type = 2 THEN
        SET v_first_positive_upt_date_v2 = use_ISO_DateTrimmer(v_facility_upt_date);
    ELSE
        RETURN NULL;
    END IF;
    RETURN v_first_positive_upt_date_v2;
END $$
DELIMITER ;