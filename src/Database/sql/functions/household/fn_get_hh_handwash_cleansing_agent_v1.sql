/**
 * Returns Formatted Household Hand Wash Cleansing Agent(s).
  ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  The form control is a 1 or more selector
 * @author Gift Jr <muyembegift@gmail.com> | 01.04.25
 * @since 0.0.1
 * @alias Get HH Hand-Wash Cleansing Agent(s) V1.
 * @param BIGINT | Aux ID
 * @return TEXT | Cleansing Agent
 */
DROP FUNCTION IF EXISTS `getHouseholdHandWashCleansingAgents_V1`;
DELIMITER $$
CREATE FUNCTION arch_etl_db.getHouseholdHandWashCleansingAgents_V1(p_v1_aux_id BIGINT)
    RETURNS TEXT
    NOT DETERMINISTIC
BEGIN

    DECLARE v_hh_handwash_cleansing_agents_v1 TEXT;

    DECLARE v_hh_handwash_cleansing_agent_1 VARCHAR(128);
    DECLARE v_hh_handwash_cleansing_agent_2 VARCHAR(128);
    DECLARE v_hh_handwash_cleansing_agent_3 VARCHAR(128);

    SELECT IF(hhc_v1.wash_soap_ob___1 = 1, hhc_v1.wash_soap_ob___1_label, ''),
           IF(hhc_v1.wash_soap_ob___2 = 1, IF(hhc_v1.wash_soap_ob___1 = 1, CONCAT(', ', hhc_v1.wash_soap_ob___2_label),
                                              hhc_v1.wash_soap_ob___2_label),
              ''),
           IF(hhc_v1.wash_soap_ob___3 = 1, hhc_v1.wash_soap_ob___3_label, '')
    INTO v_hh_handwash_cleansing_agent_1,
        v_hh_handwash_cleansing_agent_2,
        v_hh_handwash_cleansing_agent_3
    FROM wra_forms_repeating_instruments hhc_v1
    WHERE hhc_v1.wra_forms_repeating_instruments_id = p_v1_aux_id;

    SET v_hh_handwash_cleansing_agents_v1 = CONCAT(
            useStringCapFirst(v_hh_handwash_cleansing_agent_1),
            useStringCapFirst(v_hh_handwash_cleansing_agent_2),
            useStringCapFirst(v_hh_handwash_cleansing_agent_3));

    RETURN v_hh_handwash_cleansing_agents_v1;
END $$

DELIMITER ;
