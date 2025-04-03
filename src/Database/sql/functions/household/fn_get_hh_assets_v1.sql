/**
 * Returns Formatted HH Assets.
 * @author Gift Jr <muyembegift@gmail.com> | 01.04.25
 * @since 0.0.1
 * @alias Get HH Assets V1.
 * @param BIGINT | Aux ID
 * @return TEXT | Assets
 */
DROP FUNCTION IF EXISTS `getHouseholdAssets_V1`;
DELIMITER $$
CREATE FUNCTION arch_etl_db.getHouseholdAssets_V1(p_v1_aux_id BIGINT)
    RETURNS TEXT
    NOT DETERMINISTIC
BEGIN

    DECLARE v_hh_assets_v1 TEXT;

    DECLARE v_hh_asset_1 VARCHAR(27);
    DECLARE v_hh_asset_2 VARCHAR(27);
    DECLARE v_hh_asset_3 VARCHAR(27);
    DECLARE v_hh_asset_4 VARCHAR(27);
    DECLARE v_hh_asset_5 VARCHAR(27);
    DECLARE v_hh_asset_6 VARCHAR(64);
    DECLARE v_hh_asset_7 VARCHAR(27);
    DECLARE v_hh_asset_8 VARCHAR(27);
    DECLARE v_hh_asset_9 VARCHAR(27);
    DECLARE v_hh_asset_10 VARCHAR(27);
    DECLARE v_hh_asset_11 VARCHAR(27);
    DECLARE v_hh_asset_12 VARCHAR(27);
    DECLARE v_hh_asset_13 VARCHAR(27);
    DECLARE v_hh_asset_14 VARCHAR(27);
    DECLARE v_hh_asset_15 VARCHAR(27);
    DECLARE v_hh_asset_16 VARCHAR(27);
    DECLARE v_hh_asset_17 VARCHAR(27);
    DECLARE v_hh_asset_18 VARCHAR(27);
    DECLARE v_hh_asset_19 VARCHAR(27);
    DECLARE v_hh_asset_20 VARCHAR(64);
    DECLARE v_hh_asset_21 VARCHAR(64);
    DECLARE v_hh_asset_22 VARCHAR(27);

    SELECT IF(hhc_v1.hh_assets_fcorres___1 = 1,
              CONCAT_WS(',', hhc_v1.hh_assets_fcorres___1_label, ' '),
              IF(hhc_v1.hh_assets_fcorres___1 = 0, CONCAT_WS(',', 'No Electricity', ' '), '')),
           IF(hhc_v1.hh_assets_fcorres___2 = 1,
              CONCAT_WS(',', useHH_AssetsTxtTransformer(hhc_v1.hh_assets_fcorres___2_label), ' '),
              IF(hhc_v1.hh_assets_fcorres___2 = 0, CONCAT_WS(',', 'No Radio', ' '), '')),
           IF(hhc_v1.hh_assets_fcorres___3 = 1,
              CONCAT_WS(',', useHH_AssetsTxtTransformer(hhc_v1.hh_assets_fcorres___3_label), ' '),
              IF(hhc_v1.hh_assets_fcorres___3 = 0, CONCAT_WS(',', 'No Television', ' '), '')),
           IF(hhc_v1.hh_assets_fcorres___4 = 1,
              CONCAT_WS(',', useHH_AssetsTxtTransformer(hhc_v1.hh_assets_fcorres___4_label), ' '),
              IF(hhc_v1.hh_assets_fcorres___4 = 0, CONCAT_WS(',', 'No Computer', ' '), '')),
           IF(hhc_v1.hh_assets_fcorres___5 = 1,
              CONCAT_WS(',', useHH_AssetsTxtTransformer(hhc_v1.hh_assets_fcorres___5_label), ' '),
              IF(hhc_v1.hh_assets_fcorres___5 = 0, CONCAT_WS(',', 'No Refrigerator', ' '), '')),
           IF(hhc_v1.hh_assets_fcorres___6 = 1,
              CONCAT_WS(',', hhc_v1.hh_assets_fcorres___6_label, ' '),
              IF(hhc_v1.hh_assets_fcorres___6 = 0, CONCAT_WS(',', 'No Access to Internet', ' '), '')),
           IF(hhc_v1.hh_assets_fcorres___7 = 1,
              CONCAT_WS(',', useHH_AssetsTxtTransformer(hhc_v1.hh_assets_fcorres___7_label), ' '),
              IF(hhc_v1.hh_assets_fcorres___7 = 0, CONCAT_WS(',', 'No Bed', ' '), '')),
           IF(hhc_v1.hh_assets_fcorres___8 = 1,
              CONCAT_WS(',', useHH_AssetsTxtTransformer(hhc_v1.hh_assets_fcorres___8_label), ' '),
              IF(hhc_v1.hh_assets_fcorres___8 = 0, CONCAT_WS(',', 'No Table', ' '), '')),
           IF(hhc_v1.hh_assets_fcorres___9 = 1,
              CONCAT_WS(',', useHH_AssetsTxtTransformer(hhc_v1.hh_assets_fcorres___9_label), ' '),
              IF(hhc_v1.hh_assets_fcorres___9 = 0, CONCAT_WS(',', 'No Sofa', ' '), '')),
           IF(hhc_v1.hh_assets_fcorres___10 = 1,
              CONCAT_WS(',', useStringCapFirst(useHH_AssetsTxtTransformer(hhc_v1.hh_assets_fcorres___10_label)), ' '),
              IF(hhc_v1.hh_assets_fcorres___10 = 0, CONCAT_WS(',', 'No Washing Machine', ' '), '')),
           IF(hhc_v1.hh_assets_fcorres___11 = 1,
              CONCAT_WS(',', 'Air Conditioner', ' '),
              IF(hhc_v1.hh_assets_fcorres___11 = 0, CONCAT_WS(',', 'No Air Conditioner', ' '), '')),
           IF(hhc_v1.hh_assets_fcorres___12 = 1,
              CONCAT_WS(',', useHH_AssetsTxtTransformer(hhc_v1.hh_assets_fcorres___12_label), ' '),
              IF(hhc_v1.hh_assets_fcorres___12 = 0, CONCAT_WS(',', 'No Generator', ' '), '')),
           IF(hhc_v1.hh_assets_fcorres___13 = 1,
              CONCAT_WS(',', useHH_AssetsTxtTransformer(hhc_v1.hh_assets_fcorres___13_label), ' '),
              IF(hhc_v1.hh_assets_fcorres___13 = 0, CONCAT_WS(',', 'No Microwave', ' '), '')),
           IF(hhc_v1.hh_assets_fcorres___14 = 1,
              CONCAT_WS(',', useStringCapFirst(useHH_AssetsTxtTransformer(hhc_v1.hh_assets_fcorres___14_label)), ' '),
              IF(hhc_v1.hh_assets_fcorres___14 = 0, CONCAT_WS(',', 'No Geyser (Water Heater)', ' '), '')),
           IF(hhc_v1.hh_assets_fcorres___15 = 1,
              CONCAT_WS(',', useHH_AssetsTxtTransformer(hhc_v1.hh_assets_fcorres___15_label), ' '),
              IF(hhc_v1.hh_assets_fcorres___15 = 0, CONCAT_WS(',', 'No Clock', ' '), '')),
           IF(hhc_v1.hh_assets_fcorres___16 = 1,
              CONCAT_WS(',', useHH_AssetsTxtTransformer(hhc_v1.hh_assets_fcorres___16_label), ' '),
              IF(hhc_v1.hh_assets_fcorres___16 = 0, CONCAT_WS(',', 'No Chair', ' '), '')),
           IF(hhc_v1.hh_assets_fcorres___17 = 1,
              CONCAT_WS(',', useHH_AssetsTxtTransformer(hhc_v1.hh_assets_fcorres___17_label), ' '),
              IF(hhc_v1.hh_assets_fcorres___17 = 0, CONCAT_WS(',', 'No Cupboard', ' '), '')),
           IF(hhc_v1.hh_assets_fcorres___18 = 1,
              CONCAT_WS(',', useHH_AssetsTxtTransformer(hhc_v1.hh_assets_fcorres___18_label), ' '),
              IF(hhc_v1.hh_assets_fcorres___18 = 0, CONCAT_WS(',', 'No Fan', ' '), '')),
           IF(hhc_v1.hh_assets_fcorres___19 = 1,
              CONCAT_WS(',', 'VCR/DVD Player', ' '),
              IF(hhc_v1.hh_assets_fcorres___19 = 0, CONCAT_WS(',', 'No VCR/DVD Player', ' '), '')),
           IF(hhc_v1.hh_assets_fcorres___20 = 1,
              CONCAT_WS(',', useStringCapFirst(hhc_v1.hh_assets_fcorres___20_label), ' '),
              IF(hhc_v1.hh_assets_fcorres___20 = 0, CONCAT_WS(',', 'No Solar Panels', ' '), '')),
           IF(hhc_v1.hh_assets_fcorres___21 = 1, hhc_v1.hh_assets_fcorres___21_label,
              IF(hhc_v1.hh_assets_fcorres___21 = 0, 'No Non-Mobile Phone (Landline)', '')),
           IF(hhc_v1.hh_assets_fcorres___22 = 1, hhc_v1.hh_assets_fcorres___22_label, '')
    INTO v_hh_asset_1,
        v_hh_asset_2,
        v_hh_asset_3,
        v_hh_asset_4,
        v_hh_asset_5,
        v_hh_asset_6,
        v_hh_asset_7,
        v_hh_asset_8,
        v_hh_asset_9,
        v_hh_asset_10,
        v_hh_asset_11,
        v_hh_asset_12,
        v_hh_asset_13,
        v_hh_asset_14,
        v_hh_asset_15,
        v_hh_asset_16,
        v_hh_asset_17,
        v_hh_asset_18,
        v_hh_asset_19,
        v_hh_asset_20,
        v_hh_asset_21,
        v_hh_asset_22
    FROM wra_forms_repeating_instruments hhc_v1
    WHERE hhc_v1.wra_forms_repeating_instruments_id = p_v1_aux_id;

    SET v_hh_assets_v1 = CONCAT(
            v_hh_asset_1,
            v_hh_asset_2,
            v_hh_asset_3,
            v_hh_asset_4,
            v_hh_asset_5,
            v_hh_asset_6,
            v_hh_asset_7,
            v_hh_asset_8,
            v_hh_asset_9,
            v_hh_asset_10,
            v_hh_asset_11,
            v_hh_asset_12,
            v_hh_asset_13,
            v_hh_asset_14,
            v_hh_asset_15,
            v_hh_asset_16,
            v_hh_asset_17,
            v_hh_asset_18,
            v_hh_asset_19,
            v_hh_asset_20,
            v_hh_asset_21,
            v_hh_asset_22);

    RETURN v_hh_assets_v1;
END $$

DELIMITER ;
