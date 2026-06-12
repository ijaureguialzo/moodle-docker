<?php
unset($CFG);
global $CFG;
$CFG = new stdClass();

$CFG->dbtype = 'mariadb';
$CFG->dblibrary = 'native';
$CFG->dbhost = 'mariadb';
$CFG->dbname = 'moodle';
$CFG->dbuser = 'moodle';
$CFG->dbpass = '12345Abcde';
$CFG->prefix = 'mdl_';

$CFG->dboptions = [
    'dbcollation' => 'utf8mb4_unicode_ci',
];

$CFG->wwwroot = 'https://moodle.test';
$CFG->dataroot = '/var/www/moodledata';

$CFG->directorypermissions = 0770;

require_once('/var/www/html/lib/setup.php');
