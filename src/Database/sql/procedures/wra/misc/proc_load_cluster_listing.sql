/*_________________________| M & L - Cluster Loading |______________________________*/
/**
 * Mapping and Listing Cluster Loader: Get HH listings from CSPro data extracts; HUN and
 * SBN household mapping and listing are exported as separate extracts.
 *
 * @author Gift Jr <muyembegift@gmail.com> | 17.02.24
 * @since 0.0.1
 * @alias Load M & L Data By Cluster
 * @param varchar(3) p_cluster_number
 * @param mediumint p_last_insert_id
 */
DROP PROCEDURE IF EXISTS `LoadClusterListing`;
DELIMITER $$
CREATE PROCEDURE LoadClusterListing(IN p_cluster_number VARCHAR(3), OUT p_last_insert_id MEDIUMINT)
BEGIN

    DECLARE v_cluster_number DATE DEFAULT p_cluster_number;
    /*
       Properly raise errors that could be propagated throughout a
       call stack for convenient examination of exceptions.
    */
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
        BEGIN
            SHOW ERRORS;
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            IF v_cluster_number NOT IN (
                                        '001', '002', '003', '004', '005', '006', '007', '008', '009', '010',
                                        '011', '012', '013', '014', '015', '016', '017', '018', '019', '020',
                                        '021', '022', '023', '024', '025', '026', '027', '028', '029', '030',
                                        '031', '032', '033', '034', '035', '036', '037', '038', '039', '040',
                                        '041', '042', '043', '044', '045'
                ) THEN
                SIGNAL SQLSTATE '42S22' SET MESSAGE_TEXT = 'ERROR - Bad Parameters; Supplied Cluster Not Found!';
            END IF;
            SET @full_error =
                CONCAT_WS(
                    CHAR(10 using UTF8),
                    'PROC-ERROR - Failed to load Cluster-Listing;',
                    'CLUSTER-NUMBER: ',
                    p_cluster_number,
                    @errno, '(', @sqlstate, '):', @text
                    );
            SELECT @full_error as Proc_Error_Details;
            RESIGNAL;
        END;

    START TRANSACTION;
    -- load primary fields
    INSERT INTO map_and_list (zone,
                              cluster,
                              sbn,
                              hun,
                              hhn,
                              screenid,
                              gps_obtain,
                              latitude,
                              longitude,
                              neighbourh,
                              address,
                              st_type,
                              Latitude_1,
                              Longitud_1,
                              occupancy,
                              hh_name,
                              hh_total_m,
                              hh_wra)
    SELECT DISTINCT chd.zone,
                    chd.cluster,
                    csb.sbn,
                    chd.household_unit_number    as hun,
                    chd.household_number         as hhn,
                    chd.screening_id             as screenid,
                    csb.gps_obtain,
                    csb.latitude,
                    csb.longitude,
                    csb.neighbourhood            as neighbourh,
                    csb.address,
                    csb.st_type,
                    csb.Latitude_1,
                    csb.Longitude_1,
                    csb.occupancy,
                    chd.household_head           as hh_name,
                    chd.number_household_members as hh_total_m,
                    chd.number_of_women          as hh_wra
    FROM cluster_hun_details chd,
         cluster_sbn_details csb
    WHERE chd.zone = csb.zone
      AND chd.cluster = csb.cluster
      AND chd.structure_building_number = csb.sbn
      AND chd.cluster = v_cluster_number;

    SELECT LAST_INSERT_ID() INTO p_last_insert_id;
    COMMIT;

END $$

DELIMITER ;
