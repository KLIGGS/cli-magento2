# Magento 2.4.3 CE Install


Installation of Magento 2.4.3-p1 CE with some hints and solutions.

## General

* Help https://devdocs.magento.com/guides/v2.4/install-gde/composer.html
* PHP Version > use 7.4 (not 8)
* Elasticsearch 7 is **MUST**. Disabling like in older M2 Version won't work and magento 2 catalog disappears.
* Commands on your own risk.

## Hints

* Use DBeaver for your database tool
* Use an Online Service for Elasticsearch with Elasticsearch 7.1
* Use n98-magerun2.phar

## PHP

* some hosting platforms or MAMP display wrong PHP Version by using php -v
* use for Magento 2.4.3 
```php
php7.4 bin/magento
```

## Install Errors

With Magento 2.4.3 some configurations changed. Some solutions to errors.

#### Error Maria DB Version
Installing is aborted if Maria Database 10.5 is installed. Alter the di.xml file to parameter 10.[2-5] and run again.
```php
nano <magento-root>/app/etc/di.xml
```

```xml
<item name="MariaDB-(10.2-10.5)" xsi:type="string">^10\.[2-5]\.</item>
```
#### Error Magento Catalog disappeared or don't show up
Enable a valid Elastic Search 7 connection. Note: If an older version i.e. Elastic Search is installed Magento 2 backend configuration confirms a valid connection but it won't work. Elastic Search 7.1 ist MUST.

#### Error PHP Code Dependeny Injection 
Check your PHP Version you are really running. By command or by <?php phpinfo();?> in your <magento-root>/pub/ Folder. Consider to run the php cli with php7.4 -f instead of php -f
```php
php7.4 <magento-root>/bin/magento setup:upgrade
php7.4 <magento-root>/bin/magento setup:di:compile
php7.4 <magento-root>/bin/magento setup:static-content:deploy
php7.4 <magento-root>/bin/magento cache:clean
```
#### Error HTTP 500
Check your error.log regarding misconfigurations and .htaccess directives. Some hosting enviroments don't support FollowSymLinks. Use SymLinksIfOwnerMatch instead.

Find `.htaccess` files with option FollowSymLinks
```sh
  find ./ -name .htaccess -type f -exec grep -Hni "FollowSymLinks" {} \;
```
Check php memory - 2G required and modules
```sh
php -i | grep 'memory_limit'
php -r 'phpinfo(INFO_MODULES);'
```
  
#### Error HTTP 400

CSS, JS and Media resources resulting in Error 400 or Error 500. Following directories have to be checked.

<magento-root>/pub/static/
<magento-root>/pub/media/

[Adobe Help configure permissions](https://experienceleague.adobe.com/docs/commerce-operations/installation-guide/prerequisites/file-system/configure-permissions.html?lang=en)
* Access
* Folder / File Permissions
* SymLinksIfOwnerMatch in .htaccess files

Run Magento CLI
 ```php
<magento-root>/bin/magento setup:static-content:deploy
<magento-root>/bin/magento cache:flush
``` 
## Elastic Search 7

Magento 2.4.3 requires Elastic Search 7. If there is no connection you Product Catalog will not display.

### Example with Online Service at bonsai.io
https://app.bonsai.io/signup
  
```php
bin/magento config:set catalog/search/elasticsearch7_server_hostname https://xxxxxx-000000.us-east-1.bonsaisearch.net
bin/magento config:set catalog/search/elasticsearch7_server_port 443
bin/magento config:set catalog/search/elasticsearch7_enable_auth 1
bin/magento config:set catalog/search/elasticsearch7_index_prefix magento2
bin/magento config:set catalog/search/elasticsearch7_username <username>
bin/magento config:set catalog/search/elasticsearch7_password <password>
```
### Example Elastic Search local on server system

```php
bin/magento config:set catalog/search/elasticsearch7_server_hostname localhost
bin/magento config:set catalog/search/elasticsearch7_server_port 9200
bin/magento config:set catalog/search/elasticsearch7_enable_auth 0
bin/magento config:set catalog/search/elasticsearch7_index_prefix magento2
```

You may check your index at the server in case you Magento Catalog don't show i.e. after an upgrade from older versions.

### Example Elastic Search at elastic.io
https://cloud.elastic.co/login

```php
bin/magento config:set catalog/search/elasticsearch7_server_hostname i-o-optimized-deployment-be8624.es.us-west1.gcp.cloud.es.io
bin/magento config:set catalog/search/elasticsearch7_port 9243
bin/magento config:set catalog/search/elasticsearch7_enable_auth 1
bin/magento config:set catalog/search/elasticsearch7_username <username>
bin/magento config:set catalog/search/elasticsearch7_password <password>
```
If errors occur check the service by using curl command (Note: -u option with username:password)
```shell
curl -u <username>:<password> https://i-o-optimized-deployment-be8624.es.us-west1.gcp.cloud.es.io:9243
```

### Magento CLI config search engine

show search engine
```php
bin/magento config:show catalog/search/engine
```
set search engine
```php
bin/magento config:set catalog/search/engine 'lmysql'
```
Enable Elastic Search
```php
bin/magento setup:install --enable-modules=Magento_InventoryElasticsearch,Magento_Elasticsearch7,Magento_Elasticsearch6,Magento_Elasticsearch
bin/magento module:enable Magento_Elasticsearch7 Magento_InventoryElasticsearch
```
