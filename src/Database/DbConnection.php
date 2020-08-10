<?php
#-------------------------------------------------------
# Copyright (C) 2019 The Trustees of Indiana University
# SPDX-License-Identifier: BSD-3-Clause
#-------------------------------------------------------

namespace IU\REDCapETL\Database;

/**
 * Abstract database connection class that is used as
 * a parent class by storage-system specific classes.
 */
abstract class DbConnection
{
    const DB_CONNECTION_STRING_SEPARATOR = ':';
    const DB_CONNECTION_STRING_ESCAPE_CHARACTER = '\\';
    
    public $errorString;
    protected $tablePrefix;
    protected $labelViewSuffix;
    
    private $errorHandler;

    /**
     * Create a database connection.
     *
     * @param string $dbString the database connection string without the databasse type.
     * @param boolean $ssl indicates if SSL should be used when communicating with the database.
     * @param boolean $sslVerify indicates if the SSL certificate of the database server
     *     should be verified.
     * @param string $caCertfile file path for certificate authority certificate file that is
     *     used to verify the SSL certificate of the database server.
     * @param string $tablePrefix the table prefix (if any) that should be prepended to the names
     *     of all tables in the database generated by the ETL process (except for the logging tables).
     * @param string $labelViewSuffix the suffix added to the views that REDCap-ETL creates that
     *     have labels (instead ov values) for multiple choice fields.
     */
    public function __construct($dbString, $ssl, $sslVerify, $caCertFile, $tablePrefix, $labelViewSuffix)
    {
        $this->tablePrefix = $tablePrefix;
        $this->labelViewSuffix = $labelViewSuffix;
    }

    /**
     * Drops the specified table from the database.
     *
     * @param IU\REDCapETL\Schema\Table $table table object corresponding
     *     to the database table to be dropped.
     * @param boolean $ifExists if true, the table will only be dropped if it
     *     already exists
     */
    abstract public function dropTable($table, $ifExists = false);

    /**
     * Creates the specified table.
     *
     * @param IU\REDCapETL\Schema\Table $table table object corresponding
     *     to the database table to be created.
     * @param boolean $ifNotExists if true, the table will only be created if it
     *     does not already exist.
     */
    abstract public function createTable($table, $ifNotExists = false);

    /**
     * Adds a primary key constraint to the specified table.
     *
     * @param IU\REDCap\Schema\Table $table the table to create the primary key for.
     */
    abstract public function addPrimaryKeyConstraint($table);

    /**
     * Adds foriegn key constraint on specified table for its parent table (if any).
     *
     * @param IU\REDCap\Schema\Table $table the table to create the foreign key for.
     */
    abstract public function addForeignKeyConstraint($table);

    /**
     * Drops the specified label view.
     *
     * @param IU\REDCapETL\Schema\Table $table table object corresponding
     *     to the database table for which the label view is being dropped.
     */
    abstract public function dropLabelView($table, $ifExists = false);

    /**
     * Replace the lookup view for the specified table. The lookup view
     * for a table is the same as the table except that for multiple-choice
     * fields, the label is displayed instead of the value.
     *
     * @param IU\REDCapETL\Schema\Table $table table object corresponding
     *     to the database table for which the lookup view is being replaced.
     * @param IU\REDCapETL\LookupTable lookup table that maps multiple-choice
     *     field values to labels.
     */
    abstract public function replaceLookupView($table, $lookup);

    /**
     * Inserts a row into a table.
     *
     * @param IU\REDCapETL\Schema\Row $row the row object that contains
     *     the data for the row to be inserted and a reference to the
     *     table where the data is to be inserted.
     */
    abstract public function insertRow($row);

    /**
     * Insert rows into the specified table.
     *
     * @param IU\REDCapETL\Schema\Table $table table object that contains
     *     a description of the table where the rows are to be inserted,
     *     and the rows of data to be inserted.
     */
    abstract protected function insertRows($table);
    
    /**
     * Process the specified file of queries.
     *
     * @param string $queryFile the path of the file containing the
     *     queries to be processed.
     */
    abstract public function processQueryFile($queryFile);
    
    /**
     * Process the specified queries text.
     *
     * @param string $queries the queries to be processed.
     */
    abstract public function processQueries($queries);


    /**
     * Replaces the specified table in the database
     *
     * @param Table $table the table to be replaced.
     */
    public function replaceTable($table)
    {
        $ifExists = true;
        $this->dropTable($table, $ifExists);

        $this->createTable($table);
    }

    public function storeRow($row)
    {
        $rc = $this->insertRow($row);
        return $rc;
    }

    public function storeRows($table)
    {
        $rc = $this->insertRows($table);
        return $rc;
    }
    
        
    /**
     * Creates a connection string from the specified values. The
     * following characters are escaped using a backslash: '\', ':'
     *
     * @param array $values an array of string values from which to
     *     create the connection string.
     */
    public static function createConnectionString($values)
    {
        $connectionString = '';
        
        $isFirst = true;
        foreach ($values as $value) {
            if ($isFirst) {
                $isFirst = false;
            } else {
                $connectionString .= self::DB_CONNECTION_STRING_SEPARATOR;
            }
            
            $escapedValue = '';
            for ($i = 0; $i < strlen($value); $i++) {
                $char = $value[$i];
                if ($char === '\\') {  # Escape character
                    $escapedValue .= '\\\\';
                } elseif ($char === ':') {
                    $escapedValue .= '\\:';
                } else {
                    $escapedValue .= $char;
                }
            }
            $connectionString .= $escapedValue;
        }

        return $connectionString;
    }
    
    public static function parseConnectionString($connectionString)
    {
        $connectionValues = array();
        
        $escaped = false;
        $value = '';
        
        for ($i = 0; $i < strlen($connectionString); $i++) {
            $char = $connectionString[$i];
            if ($char === '\\') { // Escape character
                if ($escaped) {
                    $value .= '\\';
                    $escaped = false;
                } else {
                    $escaped = true;
                }
            } elseif ($char === ':') {
                if ($escaped) {
                    # if this is an escaped ':'
                    $value .= ':';
                    $escaped = false;
                } else {
                    # if this is a separator
                    array_push($connectionValues, $value);
                    $value = '';
                }
            } else {
                if ($escaped) {
                    $value .= '\\';
                    $escaped = false;
                }
                $value .= $char;
            }
        }
        array_push($connectionValues, $value);
                            
        return $connectionValues;
    }


    /**
     * Parses the SQL queries in the specified text and
     * returns an array of queries.
     *
     * @return array list of single SQL query strings.
     */
    public static function parseSqlQueries($text)
    {
        $queries = array();

        $query = '';
        $separators = [];    // SQL query separators
        $lastChar = '';
        $quoteStarted = false;
        $quoteEnded   = false;
        $charEscapeStarted = false;
        $inComment = false;
        $atEnd = false;

        for ($i = 0; $i < strlen($text); $i++) {
            if ($i === strlen($text) - 1) {
                $atEnd = true;
            }

            $char = $text[$i];

            if ($quoteStarted) {
                # In quote
                if ($quoteEnded) {
                    if ($char === "'") {
                        # quote wasn't actually ended,
                        # end quote was escape quote, and this is the
                        # quote being escaped
                        $quoteEnded = false;
                    } else {
                        $quoteStarted = false;
                        $quoteEnded   = false;
                    }
                } else {
                    if ($charEscapeStarted) {
                        $charEscapeStarted = false;
                    } elseif ($char === '\\') {
                        $charEscapeStarted = true;
                    } elseif ($char === "'") {
                        $quoteEnded = true;
                    }
                }
            } elseif ($inComment) {
                # In comment

                # If end of line reached, comment ends
                if ($char === "\n") {
                    $inComment = false;
                }
            } else {
                #------------------------------------------------
                # Processing query, not in quote or comment
                #------------------------------------------------
                if ($char === ';') {
                    // $separators[] = $i;
                    $queries[] = trim($query); // NEW
                    $query = '';
                } elseif ($char === "'") {
                    $query .= $char;
                    $quoteStarted = true;
                } elseif ($char === '-' && !$atEnd && $text[$i+1] === '-') {
                    $inComment = true;
                } elseif ($char === "\n" || $char === "\r" || $char === "\t") {
                    $query .= ' ';
                } elseif ($atEnd) {
                    # End of text reached; save the last query if it is not empty
                    $query .= $char;
                    $query = trim($query);
                    if (!empty($query)) {
                        $queries[] = $query; // NEW
                    }
                    $query = '';
                } else {
                    $query .= $char;
                }
            }
            $lastChar = $char;
        }

        return $queries;
    }
}
