/**
 * Get FU-2 First Positive UPT Date, for either Self test or Facility test
 *
 * @author Gift Jr <muyembegift@gmail.com> | 04.05.25
 * @since 0.0.1
 * @alias Get First UPT Date | getFirstPositive_UPT_Date_V3 .
 * @param BIGINT | Record ID
 * @return DATE | first positive UPT date
 */
DROP FUNCTION IF EXISTS `getFirstPositive_UPT_Date_V3`;
DELIMITER $$
CREATE FUNCTION getFirstPositive_UPT_Date_V3(p_record_id BIGINT)
    RETURNS DATE
    NOT DETERMINISTIC
BEGIN
    DECLARE v_first_positive_upt_date_v3 DATE;
    DECLARE v_pregnancy_id_type TINYTEXT;
    DECLARE v_self_upt_date VARCHAR(16);
    DECLARE v_facility_upt_date VARCHAR(16);
    SELECT pos_v3.fu_np_pregid_mhyn_f2, TRIM(pos_v3.fu_np_date_of_test_f2), TRIM(pos_v3.fu_np_date_of_test_2_f2)
    INTO v_pregnancy_id_type, v_self_upt_date, v_facility_upt_date
    FROM wrafu_pregnancy_surveillance_2 pos_v3
    WHERE CAST(pos_v3.record_id as UNSIGNED) = p_record_id;
    IF v_pregnancy_id_type = 1 THEN
        SET v_first_positive_upt_date_v3 = use_ISO_DateTrimmer(v_self_upt_date);
    ELSEIF v_pregnancy_id_type = 2 THEN
        SET v_first_positive_upt_date_v3 = use_ISO_DateTrimmer(v_facility_upt_date);
    ELSE
        RETURN NULL;
    END IF;
    RETURN v_first_positive_upt_date_v3;
END $$
DELIMITER ;