#!/usr/bin/env bash

XDEBUG_VERSION=xdebug

PHP_VERSION=$(php -v | grep "PHP" | awk '{print $2}')

echo "PHP_VERSION is: ${PHP_VERSION} ..........."
if [[ "$PHP_VERSION" == 7* ]] ; then XDEBUG_VERSION=xdebug-3.1.5 ; fi
echo "Begin install ${XDEBUG_VERSION} ..........."
yes | pecl install ${XDEBUG_VERSION}
echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini
echo "xdebug.mode = debug" >> /usr/local/etc/php/conf.d/xdebug.ini
echo "xdebug.start_with_request = no" >> /usr/local/etc/php/conf.d/xdebug.ini
echo "xdebug.client_host = localhost" >> /usr/local/etc/php/conf.d/xdebug.ini
echo "xdebug.client_port = 9003" >> /usr/local/etc/php/conf.d/xdebug.ini
