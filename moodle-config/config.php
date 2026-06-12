<?php
unset($CFG);
global $CFG;
$CFG = new stdClass();

$CFG->dbtype = 'mariadb';
$CFG->dblibrary = 'native';
$CFG->dbhost = '%MOODLE_DATABASE_HOST%';
$CFG->dbname = '%MOODLE_DATABASE_NAME%';
$CFG->dbuser = '%MOODLE_DATABASE_USER%';
$CFG->dbpass = '%MOODLE_DATABASE_PASSWORD%';
$CFG->prefix = 'mdl_';

$CFG->dboptions = [
    'dbcollation' => 'utf8mb4_unicode_ci',
];

$CFG->wwwroot = '%MOODLE_WWWROOT%';
$CFG->dataroot = '/var/www/moodledata';

$CFG->directorypermissions = 0770;

require_once('/var/www/html/lib/setup.php');
