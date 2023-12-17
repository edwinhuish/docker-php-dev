#!/usr/bin/env bash

PHP_VERSION=$(php -v | grep "PHP" | awk '{print $2}')

if [[ "$PHP_VERSION" == 7* ]]; then
  echo "Only install swoole for php >= 8.0, SKIPPING...."
  exit 0
fi

mkdir -p /tmp/swoole
cd /tmp/swoole
curl -o swoole.tar.gz https://github.com/swoole/swoole-src/archive/master.tar.gz -L
tar zxvf swoole.tar.gz
mv swoole-src* swoole-src
cd swoole-src
phpize
./configure --enable-openssl --enable-sockets --enable-mysqlnd --enable-swoole-curl --enable-cares --enable-swoole-pgsql
make
make install

docker-php-ext-enable swoole
