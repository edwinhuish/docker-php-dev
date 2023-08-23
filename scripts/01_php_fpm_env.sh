#!/usr/bin/env bash

set -e

#
# FPM
#
if ! echo "$VARIANT" | grep -q "fpm"; then
  exit 0
fi

if [ ! -f /usr/local/etc/php-fpm.d/www.conf ]; then
  cp /usr/local/etc/php-fpm.d/www.conf.default /usr/local/etc/php-fpm.d/www.conf
fi

sed -i "s/www-data/${USERNAME}/g" /usr/local/etc/php-fpm.d/www.conf
