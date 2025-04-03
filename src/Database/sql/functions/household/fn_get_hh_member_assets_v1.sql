/**
 * Returns Formatted HH Member Assets.
 * @author Gift Jr <muyembegift@gmail.com> | 01.04.25
 * @since 0.0.1
 * @alias Get HH Member Assets V1.
 * @param BIGINT | Aux ID
 * @return TEXT | Member Assets
 */
DROP FUNCTION IF EXISTS `getHouseholdMemberAssets_V1`;
DELIMITER $$
CREATE FUNCTION arch_etl_db.getHouseholdMemberAssets_V1(p_v1_aux_id BIGINT)
    RETURNS TEXT
    NOT DETERMINISTIC
BEGIN

    DECLARE v_hh_member_assets_v1 TEXT;

    DECLARE v_hh_member_asset_1 VARCHAR(32);
    DECLARE v_hh_member_asset_2 VARCHAR(32);
    DECLARE v_hh_member_asset_3 VARCHAR(32);
    DECLARE v_hh_member_asset_4 VARCHAR(32);
    DECLARE v_hh_member_asset_5 VARCHAR(64);
    DECLARE v_hh_member_asset_6 VARCHAR(16);
    DECLARE v_hh_member_asset_7 VARCHAR(16);
    DECLARE v_hh_member_asset_8 VARCHAR(16);
    DECLARE v_hh_member_asset_9 VARCHAR(8);

    SELECT IF(hhc_v1.hh_asset_ownr___1 = 1,
              CONCAT_WS(',', useStringCapFirst(REPLACE(
                      useHH_AssetsTxtTransformer(hhc_v1.hh_asset_ownr___1_label), '?', ''
                                               )),
                        ' '),
              IF(hhc_v1.hh_asset_ownr___1 = 0, CONCAT_WS(',', 'No Wrist Watch', ' '), '')
           ),
           IF(hhc_v1.hh_asset_ownr___2 = 1,
              CONCAT_WS(',', useStringCapFirst(REPLACE(
                      useHH_AssetsTxtTransformer(hhc_v1.hh_asset_ownr___2_label), '?', ''
                                               )),
                        ' '),
              IF(hhc_v1.hh_asset_ownr___2 = 0, CONCAT_WS(',', 'No Mobile Phone', ' '), '')
           ),
           IF(hhc_v1.hh_asset_ownr___3 = 1,
              CONCAT_WS(',', REPLACE(
                      useHH_AssetsTxtTransformer(hhc_v1.hh_asset_ownr___3_label), '?', ''
                             ),
                        ' '),
              IF(hhc_v1.hh_asset_ownr___3 = 0, CONCAT_WS(',', 'No Tablet', ' '), '')
           ),
           IF(hhc_v1.hh_asset_ownr___4 = 1,
              CONCAT_WS(',', REPLACE(
                      useHH_AssetsTxtTransformer(hhc_v1.hh_asset_ownr___4_label), '?', ''
                             ),
                        ' '),
              IF(hhc_v1.hh_asset_ownr___4 = 0, CONCAT_WS(',', 'No Bicycle', ' '), '')
           ),
           IF(hhc_v1.hh_asset_ownr___5 = 1,
              CONCAT_WS(',', useStringCapFirst(REPLACE(
                      useHH_AssetsTxtTransformer(hhc_v1.hh_asset_ownr___5_label), '?', ''
                                               )),
                        ' '),
              IF(hhc_v1.hh_asset_ownr___5 = 0, CONCAT_WS(',', 'No Motor Cycle or Motor Scooter', ' '), '')
           ),
           IF(hhc_v1.hh_asset_ownr___6 = 1,
              CONCAT_WS(',', useStringCapFirst(REPLACE(
                      useHH_AssetsTxtTransformer(hhc_v1.hh_asset_ownr___6_label), '?', ''
                                               )),
                        ' '),
              IF(hhc_v1.hh_asset_ownr___6 = 0, CONCAT_WS(',', 'No Car or Truck', ' '), '')
           ),
           IF(hhc_v1.hh_asset_ownr___7 = 1,
              CONCAT_WS(',', hhc_v1.hh_asset_ownr___7_label, ' '),
              IF(hhc_v1.hh_asset_ownr___7 = 0, CONCAT_WS(',', 'No Wheelbarrow', ' '), '')),
           IF(hhc_v1.hh_asset_ownr___8 = 1, hhc_v1.hh_asset_ownr___8_label,
              IF(hhc_v1.hh_asset_ownr___8 = 0, 'No Oxcart', '')),
           IF(hhc_v1.hh_asset_ownr___9 = 1, hhc_v1.hh_asset_ownr___9_label, '')
    INTO v_hh_member_asset_1,
        v_hh_member_asset_2,
        v_hh_member_asset_3,
        v_hh_member_asset_4,
        v_hh_member_asset_5,
        v_hh_member_asset_6,
        v_hh_member_asset_7,
        v_hh_member_asset_8,
        v_hh_member_asset_9
    FROM wra_forms_repeating_instruments hhc_v1
    WHERE hhc_v1.wra_forms_repeating_instruments_id = p_v1_aux_id;

    SET v_hh_member_assets_v1 = CONCAT(
            v_hh_member_asset_1,
            v_hh_member_asset_2,
            v_hh_member_asset_3,
            v_hh_member_asset_4,
            v_hh_member_asset_5,
            v_hh_member_asset_6,
            v_hh_member_asset_7,
            v_hh_member_asset_8,
            v_hh_member_asset_9);

    RETURN v_hh_member_assets_v1;
END $$

DELIMITER ;
