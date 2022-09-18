# Magento 2.4.3 Install

# Usage

Commands on your own risk. Installation of Magento 2.4.3-p1 with some hints and tipps.

# General

* Help https://devdocs.magento.com/guides/v2.4/install-gde/composer.html
* PHP Version > use 7.4 (not 8)
* Elastic Search > setup an test account with https://bonsai.io or https://elastic.co
* Elastic Search is required. Disabling as descriped in older version won't work.

# Hints

* Use DBeaver for your database tool
* Use an Online Service for Elastic Search with Elastic Search 7.1
* Use magerun

# PHP

* some hosting platforms display wrong PHP Version by using php -v
* use for M2.4.3 php7.4 bin/magento
* 
# Elastic Search 7

Magento 2.4.3 requires Elastic Search 7. Else you catalog disappears.

Example with bonsai.io

```
bin/magento config:set catalog/search/elasticsearch7_server_hostname https://xxxxxx-000000.us-east-1.bonsaisearch.net
bin/magento config:set catalog/search/elasticsearch7_server_port 443
bin/magento config:set catalog/search/elasticsearch7_enable_auth 1
bin/magento config:set catalog/search/elasticsearch7_index_prefix magento2
bin/magento config:set catalog/search/elasticsearch7_username xxxxxxxx
bin/magento config:set catalog/search/elasticsearch7_password xxxxxxxx
```
Example local Elastic Search
```
bin/magento config:set catalog/search/elasticsearch7_server_hostname localhost
bin/magento config:set catalog/search/elasticsearch7_server_port 9200
bin/magento config:set catalog/search/elasticsearch7_enable_auth 0
bin/magento config:set catalog/search/elasticsearch7_index_prefix magento2
```

# Error 

Maria DB Version can be altered in <magento-root>/app/etc/di.xml. Re-run install command.

