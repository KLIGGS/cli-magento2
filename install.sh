#!/bin/bash

 #############################################################################
#
# description	Example CLI installing Magento 2.4.3-p1 CE
#
# #############################################################################

# sign in for key to dowload from repo at https://marketplace.magento.com/
cd ~/home/www/
composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition=2.4.3-p1

mv project-community-edition public
cd public

# php7.4 or php may required to execute Magento CLI i.e. php7.4 bin/magento

bin/magento setup:install \
--cleanup-database \
--base-url-secure=https://domain.com \
--base-url=https://domain.com \
--skip-db-validation \
--db-host=localhost \
--db-name=db_magento \
--db-user='<user-database>' \
--db-password='<password-database>' \
--admin-firstname=John \
--admin-lastname=Doe \
--admin-email=admin@domain.com \
--admin-user='<user-magento>' \
--admin-password='<password>-magento>' \
--use-rewrites=1 \
--use-secure=1 \
--language=de_DE \
--currency=EUR \
--timezone=Europe/Berlin \
--elasticsearch-host=https://<username>:<password>@domain-1435784711.us-east-1.bonsaisearch.net \
--elasticsearch-port=443 \
--elasticsearch-enable-auth=true \
--elasticsearch-username='<username-elastic>' \
--elasticsearch-password='<password-elastic>'

 # disable 2-Way auth may not required in DEV
bin/magento module:disable Magento_TwoFactorAuth 
bin/magento cache:flush 

# Migration tool for 2.4.3
composer require magento/data-migration-tool:2.4.2
                
# disable extensions may not required i.e. in DEV
# keep order of commands
bin/magento module:disable Amazon_Login Amazon_Payment Dotdigitalgroup_Email Dotdigitalgroup_Chat Dotdigitalgroup_ChatGraphQl Dotdigitalgroup_EmailGraphQl Dotdigitalgroup_Sms Klarna_Core Klarna_Ordermanagement Klarna_Kp Klarna_Onsitemessaging Klarna_KpGraphQl PayPal_Braintree PayPal_BraintreeGraphQl Temando_ShippingRemover Vertex_Tax Vertex_AddressValidationApi Vertex_RequestLoggingApi Vertex_RequestLogging Vertex_AddressValidation Yotpo_Yotpo
bin/magento module:disable Amazon_Core

magento setup:di:compile
magento setup:static-content:deploy
magento cache:clean

# check .htaccess files if HTTP Error 500 occurs
find ./ -name .htaccess -type f -exec grep -Hni "FollowSymLinks" {} \;

# extend CLI with magerun
cd ./bin
curl -O https://files.magerun.net/n98-magerun2.phar

# check your setup
php n98-magerun2.phar sys:check
