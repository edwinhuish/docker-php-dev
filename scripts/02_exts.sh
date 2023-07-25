#!/usr/bin/env bash

set -e

docker-php-ext-install -j$(nproc) mysqli pdo_mysql opcache pdo_pgsql pgsql soap xsl intl zip pcntl iconv bcmath

docker-php-ext-configure gd --with-freetype --with-jpeg 
docker-php-ext-install -j$(nproc) gd

PHP_OPENSSL=yes docker-php-ext-configure imap --with-kerberos --with-imap-ssl 
docker-php-ext-install -j$(nproc) imap

CFLAGS="$CFLAGS -D_GNU_SOURCE" docker-php-ext-install sockets

pecl install mongodb 
docker-php-ext-enable mongodb

pecl install redis 
docker-php-ext-enable redis

yes '' | pecl install imagick 
docker-php-ext-enable imagick
