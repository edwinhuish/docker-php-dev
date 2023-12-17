#!/usr/bin/env bash

PHP_VERSION=$(php -v | grep "PHP" | awk '{print $2}')

if [[ "$PHP_VERSION" == 7* ]]; then
  echo "Only install swoole for php >= 8.0, SKIPPING...."
  exit 0
fi

pecl install --configureoptions 'enable-sockets="no" enable-openssl="yes" enable-http2="yes" enable-mysqlnd="no" enable-swoole-json="no" enable-swoole-curl="yes" enable-cares="yes"' swoole

docker-php-ext-enable swoole
