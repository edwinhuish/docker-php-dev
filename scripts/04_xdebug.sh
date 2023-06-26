#!/usr/bin/env bash

echo -e "\n\n========================== INSTALL XDEBUG ==========================\n\n"

XDEBUG_VERSION=xdebug

PHP_VERSION=$(php -v | grep "PHP" | awk '{print $2}')

echo "PHP_VERSION is: ${PHP_VERSION} ..........."
if [[ "$PHP_VERSION" == 7* ]] ; then XDEBUG_VERSION=xdebug-3.1.5 ; fi
echo "Begin install ${XDEBUG_VERSION} ..........."
yes | pecl install ${XDEBUG_VERSION}

XDEBUG_SO=$(find /usr/local/lib/php/extensions/ -name xdebug.so)
echo "zend_extension=${XDEBUG_SO}" > /usr/local/etc/php/conf.d/xdebug.ini
echo "xdebug.mode = debug" >> /usr/local/etc/php/conf.d/xdebug.ini
echo "xdebug.start_with_request = no" >> /usr/local/etc/php/conf.d/xdebug.ini
echo "xdebug.client_host = localhost" >> /usr/local/etc/php/conf.d/xdebug.ini
echo "xdebug.client_port = 9003" >> /usr/local/etc/php/conf.d/xdebug.ini
