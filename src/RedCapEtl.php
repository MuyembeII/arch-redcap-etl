<?php


namespace IU\REDCapETL;

use IU\PHPCap\RedCap;
use IU\PHPCap\PhpCapException;

use IU\REDCapETL\Schema\Field;
use IU\REDCapETL\Schema\FieldType;
use IU\REDCapETL\Schema\Schema;
use IU\REDCapETL\Schema\Table;

use IU\REDCapETL\Database\DBConnectFactory;

/**
 * Class for REDCap ETL (Extract, Transform, Load).
 *
 * This class has several data dependencies:
 *
 * * configuration file - that contains the initial e-mail address to use for notifications
 *   the URL for the REDCap instance being used, the API token of the REDCap configuration
 *   project to use
 * * REDCap configuration project - provides information on the data and logging projects
 *   and the data store
 * * REDCap data project - the source for data extraction
 * * REDCap logging project - the place where messages are logged
 * * Database - the data store where the extracted data is loaded
 *
 */
class RedCapEtl
{
    const CHECKBOX_SEPARATOR         = '___';

    const DEFAULT_EMAIL_SUBJECT = 'REDCap ETL Error';

    # Rows Type
    const ROOT                 = 0;
    const BY_EVENTS            = 1;
    const BY_SUFFIXES          = 2;
    const BY_EVENTS_SUFFIXES   = 3;
    const BY_REPEATING_INSTRUMENTS   = 4;

    // For creating output fields to represent events and suffixes
    const COLUMN_EVENT             = 'redcap_event';
    const COLUMN_SUFFIXES          = 'redcap_suffix';
    const COLUMN_EVENT_TYPE        = FieldType::STRING;
    const COLUMN_SUFFIXES_TYPE     = FieldType::STRING;
    const REDCAP_EVENT_NAME        = 'redcap_event_name';

    const COLUMN_REPEATING_INSTRUMENT      = 'redcap_repeat_instrument';
    const COLUMN_REPEATING_INSTRUMENT_TYPE = FieldType::STRING;
    const COLUMN_REPEATING_INSTANCE        = 'redcap_repeat_instance';
    const COLUMN_REPEATING_INSTANCE_TYPE   = FieldType::INT;

    // For setting whether or not DET invokes the ETL or just parses
    const TRIGGER_ETL_NO  = '0';
    const TRIGGER_ETL_YES = '1';

    // For Lookup tables
    const LOOKUP_TABLE_NAME        = 'Lookup';
    const LOOKUP_TABLE_PRIMARY_ID  = 'lookup_id';
    const LOOKUP_FIELD_TABLE_NAME  = 'table_name';
    const LOOKUP_FIELD_FIELD_NAME  = 'field_name';
    const LOOKUP_FIELD_CATEGORY    = 'category';
    const LOOKUP_FIELD_LABEL       = 'label';

    protected $det;          // For calls related to Data Entry Triggers

    protected $configProject;
    protected $dataProject;
    protected $logProject;

    protected $logger;

    protected $batchSize = 1;   // In effect batch size of 1 is no batching

    protected $schema;
    protected $lookupTable;  // Table object that has label information for
                              // multiple choice REDCap fields.

    protected $rowsLoadedForTable = array();
  
    protected $dbcon;

    private $tablePrefix = '';   // Default: no prefix
                                 // This is intened for cases where multiple ETL instances
                                 // are writing to the same database. If this isn't used,
                                 // the Lookup table will be overwritten by each instance.

    private $labelViewSuffix = '_vLookup';

    private $fromEmailAddress;
    private $emailSubject;

    private $logFile;

    private $errorHandler;

    private $app;

    private $recordIdFieldName;   // The field name for the record ID
                                  // for the data project in REDCap

    private $configuration;
  

    /**
     * Constructor.
     *
     * @param Logger2 $logger logger for information and errors
     * @param string $propertiesFile the name of the properties file to use.
     * @param boolean $useWebScriptLogFile indicates if the web script
     *     log file should be used instead of the regular log file. This
     *     allows logging to a different file when running REDCap ETL
     *     using a web script instead of the command line script.
     */
    public function __construct(
        $logger,
        $propertiesFile,
        $useWebScriptLogFile = false
    ) {
        $this->errorHandler = new EtlErrorHandler();

        $this->app = $logger->getApp();

        $properties = null;
        $this->configuration = new Configuration(
            $logger,
            $properties,
            $propertiesFile,
            $useWebScriptLogFile
        );
        
        $this->logger = $this->configuration->getLogger();
        
        $this->configProject = $this->configuration->getConfigProject();

        #-------------------------------------------------------------
        # Callback function for use in the RedCap class so
        # that project objects retrieved will have class EtlProject,
        # which has extensions for REDCapETL.
        #-------------------------------------------------------------
        $callback = function (
            $apiUrl,
            $apiToken,
            $sslVerify = false,
            $caCertificateFile = null,
            $errorHandler = null,
            $connection = null
        ) {
            return new EtlProject(
                $apiUrl,
                $apiToken,
                $sslVerify,
                $caCertificateFile,
                $errorHandler,
                $connection
            );
        };

        
        #---------------------------------------------------------
        # Set time limit
        #---------------------------------------------------------
        $timeLimit = $this->configuration->getTimeLimit();
        if (isset($timeLimit) && trim($timeLimit) !== '') {
            set_time_limit($timeLimit);
        } else {
            set_time_limit(0);   # no time limit
        }

        #---------------------------------------------------------
        # Set timezone if one was specified
        #---------------------------------------------------------
        $timezone = $this->configuration->getTimezone();
        if (isset($timezone) && trim($timezone) !== '') {
            date_default_timezone_set($timezone);
        }


        $apiUrl = $this->configuration->getRedCapApiUrl();

        #-----------------------------------------------------------
        # Create RedCap object to use for getting REDCap projects
        #-----------------------------------------------------------
        $superToken = null; // There is no need to create projects, so this is not needed
        $sslVerify  = $this->configuration->getSslVerify();
        $caCertFile = $this->configuration->getCaCertFile();

        try {
            $redCap = new RedCap($apiUrl, $superToken, $sslVerify, $caCertFile);
            $redCap->setProjectConstructorCallback($callback);
        } catch (PhpCapException $exception) {
            $message = 'Unable to set up RedCap object.';
            $this->errorHandler->throwException($message, EtlException::PHPCAP_ERROR, $exception);
        }


        #------------------------------------------------------
        # Create a REDCap DET (Data Entry Trigger) Handler,
        # in case it's needed.
        #------------------------------------------------------
        $projectId = $this->configuration->getProjectId();
        $this->det = new RedCapDetHandler(
            $projectId,
            $this->configuration->getAllowedServers(),
            $this->logger->getNotifier()
        );

        #----------------------------------------------------------------
        # Get the project that has the actual data
        #----------------------------------------------------------------
        $dataToken = $this->configuration->getDataSourceApiToken();
        try {
            $this->dataProject = $redCap->getProject($dataToken);
        } catch (PhpCapException $exception) {
            $message = 'Could not get data project.';
            $this->errorHandler->throwException($message, EtlException::PHPCAP_ERROR, $exception);
        }

        # $endDataProject = microtime(true);
        # print "    Data project time: ".($endDataProject - $startDataProject)." seconds\n";


        // Create a new Schema
        $this->schema = new Schema();

        # $endLog = microtime(true);
        # print "    Log setup time: ".($endLog - $startLog)." seconds\n";

        #---------------------------------------------
        # Log the version number of REDCap ETL
        #---------------------------------------------
        $this->log('REDCap ETL version '.Version::RELEASE_NUMBER);


        #---------------------------------------------------
        # Create a database connection for the database
        # where the transformed REDCap data will be stored
        #---------------------------------------------------
        $dbconfactory = new DBConnectFactory();
        $this->dbcon = $dbconfactory->createDbcon(
            $this->configuration->getDbConnection(),
            $this->tablePrefix,
            $this->labelViewSuffix
        );
        
        $this->logger->logInfo('Database connection created');  // Jim
    }


    /**
     * Parses the transformation rules, and creates a Schema object that describes
     * the schema of the database where the extracted data will be loaded.
     *
     * @return string if successful, return PARSE_VALID, if not successful,
     *    return a string with feedback about problems in parsing the transformationRules
     */
    public function parseMap()
    {
        $transformationRules = $this->configuration->getTransformationRules();
        $rules = new TransformationRules($transformationRules);
        list($schema, $lookupTable, $parseResult)
            = $rules->parse($this->dataProject, $this->tablePrefix, $this->logger);
        #print_r($lookupTable);
        #print_r($parseResult);
        ###print "\n".($schema->toString())."\n";

        $this->schema       = $schema;
        $this->lookupTable = $lookupTable;

        return $parseResult;
    }


    /**
     * Reads all records from the RedCapEtl project, transforms them
     * into Rows, and loads those rows
     *
     * Reads records out of REDCap in batches in order to reduce the likelihood
     * of causing memory issues on the Application server or Database server.
     */
    public function extractTransformLoad()
    {
        $startEtlTime = microtime(true);

        $extractTime   = 0.0;
        $transformTime = 0.0;
        $loadTime      = 0.0;

        #--------------------------------------------------
        # Extract the record ID batches
        #--------------------------------------------------
        $startExtractTime = microtime(true);
        $recordIdBatches = $this->dataProject->getRecordIdBatches((int) $this->batchSize);
        $endExtractTime = microtime(true);
        $extractTime += $endExtractTime - $startExtractTime;

        # Count and log the number of record IDs found
        $recordIdCount = 0;
        foreach ($recordIdBatches as $recordIdBatch) {
            $recordIdCount += count($recordIdBatch);
        }
        $this->log("Number of record_ids found: ". $recordIdCount);

        // Foreach record_id, get all REDCap records for that record_id.
        // There will be one record for each event for each record_id
        $recordEventsCount = 0;

        #-------------------------------------------------------
        # For each batch of data, extract, transform, and load
        #-------------------------------------------------------
        foreach ($recordIdBatches as $recordIdBatch) {
            #---------------------------------
            # Extract the data from REDCap
            #---------------------------------
            $startExtractTime = microtime(true);
            $recordBatch = $this->dataProject->getRecordBatch($recordIdBatch);
            $endExtractTime = microtime(true);
            $extractTime += $endExtractTime - $startExtractTime;

            foreach ($recordBatch as $recordId => $records) {
                $recordEventsCount += count($records);

                #-----------------------------------
                # Transform the data
                #-----------------------------------
                $startTransformTime = microtime(true);
                // For each root table
                foreach ($this->schema->getRootTables() as $rootTable) {
                    // Transform the records for this record_id into rows
                    $this->transform($rootTable, $records, '', '');
                }
                $endTransformTime = microtime(true);
                $transformTime += $endTransformTime - $startTransformTime;
            }

            #print("\n\n==============================================================================================\n");
            #print("\n\nSCHEMA MAP\n{$this->schema->toString()}\n\n");
            #print("\n\n==============================================================================================\n");

            #-------------------------------------
            # Load the data into the database
            #-------------------------------------
            $startLoadTime = microtime(true);
            $this->loadRows();
            $endLoadTime = microtime(true);
            $loadTime += $endLoadTime - $startLoadTime;
        }

        $endEtlTime = microtime(true);
        $this->logInfoToFile('Extract time:   '.$extractTime.' seconds');
        $this->logInfoToFile('Transform time: '.$transformTime.' seconds');
        $this->logInfoToFile('Load time:      '.$loadTime.' seconds');
        $this->logInfoToFile('ETL total time: '.($endEtlTime - $startEtlTime).' seconds');

        $this->reportRows();

        $this->log("Number of record events transformed: ". $recordEventsCount);
    
        return true;
    }


    /**
     * Transform the values from REDCap in the specified records into
     * values in the specified table and its child tables objects.
     * The rows are added to the Table objects as data rows, and NOT
     * stored in the database at this point.
     *
     * @param Table $table the table (and its child tables) in which the
     *        records values are being stored.
     *
     * @param array $records array of records for a single record_id. If there
     *     is more than one record, they represent multiple
     *     events or repeating instruments (forms).
     *
     * @param string $foreignKey if set, represents the value to use as the
     *     foreign key for any records created.
     *
     * @param string $suffix If set, represents the suffix used for the parent table.
     */
    protected function transform($table, $records, $foreignKey, $suffix)
    {
        // Look at row_event for this table
        switch ($table->rows_type) {
            // If root
            case RedCapEtl::ROOT:
                $this->createRowAndRecurse($table, $records, $foreignKey, $suffix);
                break;

            // If events
            case RedCapEtl::BY_EVENTS:
                // Foreach Record (i.e., foreach event)
                foreach ($records as $record) {
                    $this->createRowAndRecurse($table, array($record), $foreignKey, $suffix);
                }
                break;

            // If repeatable forms
            case RedCapEtl::BY_REPEATING_INSTRUMENTS:
                // Foreach Record (i.e., foreach repeatable form)
                foreach ($records as $record) {
                    $this->createRowAndRecurse($table, array($record), $foreignKey, $suffix);
                }
                break;

            // If suffix
            case RedCapEtl::BY_SUFFIXES:
                // Foreach Suffix
                foreach ($table->rows_suffixes as $new_suffix) {
                    $this->createRowAndRecurse($table, $records, $foreignKey, $suffix.$new_suffix);
                }
                break;

            // If events and suffix
            case RedCapEtl::BY_EVENTS_SUFFIXES:
                // Foreach Record (i.e., foreach event)
                foreach ($records as $record) {
                    // Foreach Suffix
                    foreach ($table->rows_suffixes as $new_suffix) {
                        $this->createRowAndRecurse($table, array($record), $foreignKey, $suffix.$new_suffix);
                    }
                }
                break;
        }

        return true;
    }


    /**
     * See 'transform' function for explanation of variables.
     */
    protected function createRowAndRecurse($table, $records, $foreignKey, $suffix)
    {
        // Create Row using 1st Record
        $primaryKey = $table->createRow($records[0], $foreignKey, $suffix);

        // If primary key generated, recurse for child tables
        if ($primaryKey) {
            // Foreach child table
            foreach ($table->getChildren() as $child_table) {
                $this->transform($child_table, $records, $primaryKey, $suffix);
            }
        }
        return true;
    }


    /**
     * Creates the database tables where the data will be loaded, and
     * creates some views based on those tables. If there are existing
     * tables, then those tables are dropped first.
     */
    public function createLoadTables()
    {
        // Used to speed up processing
        $lookup = new Lookup($this->lookupTable);

        // foreach table, replace it
        // NOTE: This works on each table plus the lookup table
        $tables = array_merge(array($this->lookupTable), $this->schema->getTables());
        foreach ($tables as $table) {
            $this->dbcon->replaceTable($table);

            $msg = "Created table '".$table->name."'";

            // If this table uses the Lookup table, create a view
            if (true === $table->uses_lookup) {
                $this->dbcon->replaceLookupView($table, $lookup);
                $msg .= '; Lookup table created';
            }

            $this->log($msg);
        }
        return true;
    }


    /**
     * Write rows to the database.
     */
    protected function loadRows()
    {

        // foreach table object, store it's rows in the database and
        // then remove them from the table object
        // NOTE: This works on each table AND on each lookup table
        foreach (array_merge(array($this->lookupTable), $this->schema->getTables()) as $table) {
            #$rc = $this->dbcon->storeRows($table);
            #if (false === $rc) {
            #    $this->log("Error storing row in '".$table->name."': ".$this->dbcon->err_str);
            #}

            # Single row storage (stores one row at a time):
            # foreach row, load it
            foreach ($table->getRows() as $row) {
                $rc = $this->dbcon->storeRow($row);
                if (false === $rc) {
                    $this->log("Error storing row in '".$table->name."': ".$this->dbcon->err_str);
                }
            }

            // Add to summary how many rows created for this table
            if (array_key_exists($table->name, $this->rowsLoadedForTable)) {
                $this->rowsLoadedForTable[$table->name] += $table->getNumRows();
            } else {
                $this->rowsLoadedForTable[$table->name] = $table->getNumRows();
            }

            // Empty the rows for this table
            $table->emptyRows();
        }

        return true;
    }


    /**
     * Report rows written to the database
     */
    protected function reportRows()
    {
        // foreach table
        foreach ($this->rowsLoadedForTable as $table_name => $rows) {
            $msg = "Rows loaded for table '".$table_name."': ".$rows;
            $this->log($msg);
        }

        return true;
    }


    /**
     * For DET-invocations, upload the result and reset the etl_trigger
     */
    public function uploadResultAndReset($result, $record_id)
    {
        $records = array();
        $records[0] = array(
            'record_id' => $record_id,
            ConfigProperties::TRIGGER_ETL => RedCapEtl::TRIGGER_ETL_NO,
            ConfigProperties::TRANSFORM_RULES_CHECK => $result
        );

        try {
            $this->configProject->importRecords($records);
        } catch (PhpCapException $exception) {
            $message = 'Unable to load results and reset ETL trigger';
            $this->errorHandler->throwException($message, EtlException::PHPCAP_ERROR, $exception);
        }

        return true;
    }


    /**
     * Runs the entire ETL process
     */
    public function run()
    {
        try {
            $this->log("Starting processing.");

            //-------------------------------------------------------------------------
            // Parse Transformation Rules
            //-------------------------------------------------------------------------
            // NOTE: The $result is not used in batch mode. It is used
            //       by the DET handler to give feedback within REDCap.


            list($parseStatus, $result) = $this->parseMap();

            if ($parseStatus === TransformationRules::PARSE_ERROR) {
                $message = "Transformation rules not parsed. Processing stopped.";
                $this->errorHandler->throwException($message, EtlException::INPUT_ERROR);
            } else {
                //----------------------------------------------------------------------
                // Extract, Transform, and Load
                //
                // These three steps are joined together at this level so that
                // the data from REDCap can be worked on in batches
                //----------------------------------------------------------------------
                $this->createLoadTables();
                $this->extractTransformLoad();

                $this->log("Processing complete.");
            }
        } catch (EtlException $exception) {
            $this->log('Processing failed.');
            throw $exception;  // re-throw the exception
        }
    }


    /**
     * Run the ETL process for a DET (Data Entry Trigger)
     */
    public function runForDet()
    {
        $this->logger->logInfo('Executing web script '.$this->logger->getApp());

        $detHandler = $this->getDetHandler();
        list($project_id,$record_id) = $detHandler->getDetParams();

        #-----------------------------------------------------------------------
        # Data Entry Trigger: Check for allowed project/servers
        #-----------------------------------------------------------------------
        $detHandler->checkDetId($project_id);
        $detHandler->checkAllowedServers();

        #-----------------------------------------------------------------------
        # Parse Map
        #-----------------------------------------------------------------------
        list($parse_status, $result) = $this->parseMap();

        # If the parsing of the schema map failed.
        if ($parse_status === TransformationRules::PARSE_ERROR) {
            $msg = "Schema map not fully parsed. Processing stopped.";
            $this->log($msg);
            $result .= $msg."\n";
        } else {
            $result .= "Schema map is valid.\n";

            if ($this->getTriggerEtl() !== RedCapEtl::TRIGGER_ETL_YES) {
                // ETL not requested
                $msg = "Web-invoked process stopped after parsing, per default.";
                $this->log($msg);
                $result .= $msg."\n";
            } else {
                $result .= "ETL proceeding. Please see log for results\n";

                $this->createLoadTables();
                //--------------------------------------------------------------------
                // Extract, Transform, and Load
                //
                // These three steps are joined together at this level so that
                // the data from REDCap can be worked on in batches
                //--------------------------------------------------------------------
                $this->extractTransformLoad();
            } // ETL requested
        } // parseMap valid

        // Provide a timestamp for the results
        $result = date('g:i:s a d-M-Y T') . "\n" . $result;

        #-----------------------------------------------------------
        # Upload the results, and set ETL trigger back to default
        #-----------------------------------------------------------
        $this->uploadResultAndReset($result, $record_id);
    }


    /**
     * Gets the DET (Data Entry Trigger) handler.
     */
    public function getDetHandler()
    {
        return $this->det;
    }

    public function getTriggerEtl()
    {
        $records = $this->configProject->exportRecords();
        $triggerEtl = $records[0][ConfigProperties::TRIGGER_ETL];
        return $triggerEtl;
    }

    public function setTriggerEtl()
    {
        $records = $this->configProject->exportRecordsAp();
        $records = array($records[0]);
        $records[0][ConfigProperties::TRIGGER_ETL] = RedCapEtl::TRIGGER_ETL_YES;
        $this->configProject->importRecords($records);
    }

    public function getLogger()
    {
        return $this->logger;
    }
    
    public function log($message)
    {
        $this->logger->logInfo($message);
    }

    public function logInfoToFile($message)
    {
        $this->logger->logToFile($message, $this->logFile);
    }

    public function getTablePrefix()
    {
        return $this->tablePrefix;
    }

    public function getConfiguration()
    {
        return $this->configuration;
    }
}
