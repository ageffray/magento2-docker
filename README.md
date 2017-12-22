# magento2-docker

## Composer Setup

### Create Magento folder

First of all create a folder named "magento" in root of projetct

### Authentication

Then setup Magento Marketplace authentication (details at <a href="http://devdocs.magento.com/guides/v2.0/install-gde/prereq/connect-auth.html" target="_blank">http://devdocs.magento.com/guides/v2.0/install-gde/prereq/connect-auth.html</a>).

Place your token as .composer/auth.json like :

```
{
    "http-basic": {
        "repo.magento.com": {
            "username": "MAGENTO_PUBLIC_KEY",
            "password": "MAGENTO_PRIVATE_KEY"
        }
    }
}
```

Then, just set `M2SETUP_USE_ARCHIVE` to `false` in your ./env/setup.env file. 

### Magento Enterprise 

You can install Magento Enterprise via Composer by setting `M2SETUP_USE_COMPOSER_ENTERPRISE=true` in your ./env/setup.env file.


## Composer-less, No-Auth Setup

If you don't want to use Composer or setup the auth keys just set the `M2SETUP_USE_ARCHIVE` environment variable to `true` when running setup.

## Running Setup

A setup container check if Magento is already installed or not, if not it will install automatically.
You may modify any environment variables depending on your requirements

## Docker Compose Override

You can copy `docker-compose.override.yml.dist` to `docker-compose.override.yml` and adjust environment variables, volume mounts etc in the `docker-compose.override.yml` file to avoid losing local configuration changes when you pull changes to this repository. 

Docker Compose will automatically read any of the values you define in the file. See [this link](https://docs.docker.com/compose/extends/#/understanding-multiple-compose-files) for more information about the override file.

### Env configuration 

## env/mysql.env

- MYSQL_ROOT_PASSWORD : root password of mysql server 
- MYSQL_DATABASE : Magento database name 
- MYSQL_USER : Magento mysql user name
- MYSQL_PASSWORD : Magento mysql user password

Please take care if you need to update the three lasts variables because they are linked to magento setup and pma setup (see env/setup.env and env/pma.env sections)

## env/pma.env

- MYSQL_ROOT_PASSWORD : root password of your mysql server (need to be same as in mysql.env)
- MYSQL_USER (optional) : User name
- MYSQL_PASSWORD (optional) : User password

## env/setup.env

- M2SETUP_DB_HOST : Mysql hostname (use name defined in docker-compose.yml eg: db)
- M2SETUP_DB_NAME : Magento database name (must be same as mysql.env)
- M2SETUP_DB_USER : Magento database username (must be the same as mysql.env)
- M2SETUP_DB_PASSWORD : Magento database password (must be the same as mysql.env)
- M2SETUP_BASE_URL : Base url of website (it must be related to your nginx configuration, by default you can set every subdomain of localhost with port 8000, eg: http://m2.localhost:8000/, and don't forget the ending slash ;) )
- M2SETUP_ADMIN_FIRSTNAME : Magento back office admin account firstname
- M2SETUP_ADMIN_LASTNAME : Magento back office admin account lastname
- M2SETUP_ADMIN_EMAIL : Magento back office admin account email
- M2SETUP_ADMIN_USER : Magento back office admin account username
- M2SETUP_ADMIN_PASSWORD : Magento back office admin account password
- M2SETUP_CURRENCY : Default currency
- M2SETUP_LANGUAGE : Default language
- M2SETUP_TIMEZONE : Default timezone (in magento only not in php configuration)
- M2SETUP_USE_SAMPLE_DATA : Boolean to use or not magento sample data
- M2SETUP_USE_ARCHIVE : Boolean : yes = download magento archive and unzip it, no = use composer install (recommanded)
- M2SETUP_USE_COMPOSER_ENTERPRISE : Boolean use magento EE (Enteprise Edition)instead of CE (Community Edition)
- M2SETUP_VERSION : Magento 2.x.x version you want to install (2.2.0 for now)

## Use Redis cache

To use redis for Magento cache edit your app/etc/env.php and add this few lines :

```
'cache' => array(
    'frontend' => array(
      'default' => array(
        'backend' => 'Cm_Cache_Backend_Redis',
        'backend_options' => array(
          'server' => 'redis_cache',
          'port' => '6379',
          'persistent' => '', // Specify a unique string like "cache-db0" to enable persistent connections.
          'database' => '0',
          'password' => '',
          'force_standalone' => '0', // 0 for phpredis, 1 for standalone PHP
          'connect_retries' => '1', // Reduces errors due to random connection failures
          'read_timeout' => '10', // Set read timeout duration
          'automatic_cleaning_factor' => '0', // Disabled by default
          'compress_data' => '1', // 0-9 for compression level, recommended: 0 or 1
          'compress_tags' => '1', // 0-9 for compression level, recommended: 0 or 1
          'compress_threshold' => '20480', // Strings below this size will not be compressed
          'compression_lib' => 'gzip', // Supports gzip, lzf and snappy,
          'use_lua' => '0' // Lua scripts should be used for some operations
        )
      ),
      'page_cache' => array(
        'backend' => 'Cm_Cache_Backend_Redis',
        'backend_options' => array(
          'server' => 'redis_cache',
          'port' => '6379',
          'persistent' => '', // Specify a unique string like "cache-db0" to enable persistent connections.
          'database' => '1', // Separate database 1 to keep FPC separately
          'password' => '',
          'force_standalone' => '0', // 0 for phpredis, 1 for standalone PHP
          'connect_retries' => '1', // Reduces errors due to random connection failures
          'lifetimelimit' => '57600', // 16 hours of lifetime for cache record
          'compress_data' => '0' // DISABLE compression for EE FPC since it already uses compression
        )
      )
    )
  ),
````  

Then flush Magento cache.

## Use Redis for Session

In app/etc/env.php replace the session configuration :

````
'session' => 
  array (
    'save' => 'files',
  ),
````

by :

````
'session' =>
    array (
      'save' => 'redis',
      'redis' =>
        array (
          'host' => 'redis_session',
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
          'max_lifetime' => '2592000'
        )
    ),
````

Then flush Magento cache.
