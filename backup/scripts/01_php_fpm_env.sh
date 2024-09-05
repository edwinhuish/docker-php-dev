#!/usr/bin/env bash

set -e

#
# FPM
#
if ! echo "$VARIANT" | grep -q "fpm"; then
    exit 0
fi

BASE_PATH=$(dirname $(realpath $0))

if [ ! -f /usr/local/etc/php-fpm.d/www.conf ]; then
    cp /usr/local/etc/php-fpm.d/www.conf.default /usr/local/etc/php-fpm.d/www.conf
fi

sed -i "s/www-data/${USERNAME}/g" /usr/local/etc/php-fpm.d/www.conf

cp -f "${BASE_PATH}/templates/fpm-phpctl" /usr/local/bin/phpctl
chmod +x /usr/local/bin/phpctl
