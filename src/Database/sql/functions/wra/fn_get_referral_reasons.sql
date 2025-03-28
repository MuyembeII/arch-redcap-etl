/**
 * Returns selected reasons for referral.
 * <br/>
 * More than one referral reason can be specified, as such,it will be displayed as an item list.
 * The logic is not optimal but it gets the job done!, have fun with this one :{
 * @author Gift Jr <muyembegift@gmail.com> | 25.03.25
 * @since 0.0.1
 * @alias Get Referral Reasons.
 * @param BIGINT | Record ID
 * @param DECIMAL | Visit ID
 * @return Reason(s)
 */
DROP FUNCTION IF EXISTS `get_Referral_Reasons`;
DELIMITER $$
CREATE FUNCTION get_Referral_Reasons(p_id BIGINT)
    RETURNS TINYTEXT
    NOT DETERMINISTIC
BEGIN

    DECLARE v_referral_reason_pregnancy_care TINYTEXT;
    DECLARE v_referral_reason_depression_anxiety TINYTEXT;
    DECLARE v_referral_reason_high_blood_pressure TINYTEXT;
    DECLARE v_referral_reason_pos_covid_screen TINYTEXT;
    DECLARE v_referral_reason_malnutrition TINYTEXT;
    DECLARE v_referral_reason_hypertension TINYTEXT;
    DECLARE v_referral_reason_other TINYTEXT;

    SET @v_reasons_output := '';

    SELECT IF(r.referral_reasons___1 = 1, r.referral_reasons___1_label, ''),
           IF(r.referral_reasons___2 = 1, r.referral_reasons___2_label, ''),
           IF(r.referral_reasons___3 = 1, r.referral_reasons___3_label, ''),
           IF(r.referral_reasons___4 = 1, r.referral_reasons___4_label, ''),
           IF(r.referral_reasons___5 = 1, r.referral_reasons___5_label, ''),
           IF(r.referral_reasons___6 = 1, r.referral_reasons___6_label, ''),
           IF(r.referral_reasons___7 = 1, r.referral_reasons_other, '')
    INTO v_referral_reason_pregnancy_care,
        v_referral_reason_depression_anxiety,
        v_referral_reason_high_blood_pressure,
        v_referral_reason_pos_covid_screen,
        v_referral_reason_malnutrition,
        v_referral_reason_hypertension,
        v_referral_reason_other
    FROM clinical_referral_repeating_instruments r
    WHERE r.clinical_referral_repeating_instruments_id = p_id;

    SET @v_reasons_output = CONCAT_WS(', ',
                                      useStringCapFirst(v_referral_reason_pregnancy_care),
                                      v_referral_reason_depression_anxiety,
                                      useStringCapFirst(v_referral_reason_high_blood_pressure),
                                      useStringCapFirst(v_referral_reason_pos_covid_screen),
                                      useStringCapFirst(v_referral_reason_malnutrition),
                                      useStringCapFirst(v_referral_reason_hypertension),
                                      v_referral_reason_other
                            );
    -- , Depression or Anxiety , BMI overweight
    SET @v_reasons_output = REGEXP_REPLACE(@v_reasons_output, ' , ', ', ');
    SET @v_reasons_output = REGEXP_REPLACE(@v_reasons_output, ' ,', ',');
    SET @v_reasons_output = REGEXP_REPLACE(@v_reasons_output, ',,', ',');
    SET @v_reasons_output = TRIM(BOTH '   ' FROM @v_reasons_output);
    SET @v_reasons_output = TRIM(BOTH ',' FROM @v_reasons_output);
    SET @v_reasons_output = TRIM(TRAILING ', ' FROM @v_reasons_output);
    SET @v_reasons_output = TRIM(TRAILING ',,' FROM @v_reasons_output);
    SET @v_reasons_output = TRIM(TRAILING ',' FROM @v_reasons_output);
    SET @v_reasons_output = REGEXP_REPLACE(@v_reasons_output, ',, ', ', ');

    RETURN @v_reasons_output;
END $$

DELIMITER ;
