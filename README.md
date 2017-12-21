# magento2-docker

## Composer Setup

### Authentication

Please first setup Magento Marketplace authentication (details at <a href="http://devdocs.magento.com/guides/v2.0/install-gde/prereq/connect-auth.html" target="_blank">http://devdocs.magento.com/guides/v2.0/install-gde/prereq/connect-auth.html</a>).

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
