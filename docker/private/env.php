<?php
return [
  'backend' => [
    'frontName' => 'admin_1i2c9l'
  ],
  'crypt' => [
    'key' => 'a3068f82c49b01ef51ca9268daa4431d'
  ],
  'db' => [
    'table_prefix' => '',
    'connection' => [
      'default' => [
        'host' => 'm2-sampledocker_db_1',
        'dbname' => 'inchoo',
        'username' => 'inchoo',
        'password' => 'inchoo',
        'model' => 'mysql4',
        'engine' => 'innodb',
        'initStatements' => 'SET NAMES utf8;',
        'active' => '1'
      ]
    ]
  ],
  'resource' => [
    'default_setup' => [
      'connection' => 'default'
    ]
  ],
  'x-frame-options' => 'SAMEORIGIN',
  'MAGE_MODE' => 'develop',
  'cache' =>
      array (
          'frontend' =>
              array (
                  'default' =>
                      array (
                          'backend' => 'Cm_Cache_Backend_Redis',
                          'backend_options' =>
                              array (
                                  'server' => 'm2-sampledocker_redis_1',
                                  'database' => '0',
                                  'port' => '6379',
                              ),
                      ),
                  'page_cache' =>
                      array (
                          'backend' => 'Cm_Cache_Backend_Redis',
                          'backend_options' =>
                              array (
                                  'server' => 'm2-sampledocker_redis_1',
                                  'port' => '6379',
                                  'database' => '1',
                                  'compress_data' => '0',
                              ),
                      ),
              ),
      ),
    'session' =>
        array (
            'save' => 'redis',
            'redis' =>
                array (
                    'host' => 'm2-sampledocker_redis_1',
                    'port' => '6379',
                    'password' => '',
                    'timeout' => '2.5',
                    'persistent_identifier' => '',
                    'database' => '2',
                    'compression_threshold' => '2048',
                    'compression_library' => 'gzip',
                    'log_level' => '1',
                    'max_concurrency' => '6',
                    'break_after_frontend' => '5',
                    'break_after_adminhtml' => '30',
                    'first_lifetime' => '600',
                    'bot_first_lifetime' => '60',
                    'bot_lifetime' => '7200',
                    'disable_locking' => '0',
                    'min_lifetime' => '60',
                    'max_lifetime' => '2592000',
                ),
        ),
  'cache_types' => [
    'config' => 1,
    'layout' => 1,
    'block_html' => 1,
    'collections' => 1,
    'reflection' => 1,
    'db_ddl' => 1,
    'eav' => 1,
    'customer_notification' => 1,
    'config_integration' => 1,
    'config_integration_api' => 1,
    'full_page' => 1,
    'translate' => 1,
    'config_webservice' => 1
  ],
  'install' => [
    'date' => 'Mon, 28 May 2018 12:37:13 +0000'
  ]
];
