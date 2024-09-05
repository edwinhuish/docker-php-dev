#!/usr/bin/env bash

PHP_VERSION=$(php -v | grep "PHP" | awk '{print $2}')

if [[ "$PHP_VERSION" == 7* ]]; then
  echo "Only install swoole for php >= 8.0, SKIPPING...."
  exit 0
fi

mkdir -p /usr/src/php/ext/swoole

curl -sfL https://github.com/swoole/swoole-src/archive/master.tar.gz -o swoole.tar.gz

tar xfz swoole.tar.gz --strip-components=1 -C /usr/src/php/ext/swoole

docker-php-ext-configure swoole \
  --enable-mysqlnd \
  --enable-swoole-pgsql \
  --enable-openssl \
  --enable-sockets --enable-swoole-curl

docker-php-ext-install -j$(nproc) swoole

docker-php-ext-enable swoole

rm swoole.tar.gz
