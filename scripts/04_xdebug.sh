#!/usr/bin/env bash

set -e

BASE_PATH=$(dirname $(realpath $0))

XDEBUG_VERSION=xdebug

PHP_VERSION=$(php -v | grep "PHP" | awk '{print $2}')

echo "PHP_VERSION is: ${PHP_VERSION} ..........."
if [[ "$PHP_VERSION" == 7* ]]; then XDEBUG_VERSION=xdebug-3.1.5; fi
echo "Begin install ${XDEBUG_VERSION} ..........."
yes | pecl install ${XDEBUG_VERSION}

XDEBUG_INI_FILE=/usr/local/etc/php/conf.d/xdebug.ini

cat >$XDEBUG_INI_FILE <<EOF
zend_extension=xdebug.so
xdebug.mode=no
xdebug.start_with_request=yes
xdebug.client_host=localhost
xdebug.client_port=9003
EOF

# 将配置文件修改为任何人可读写
chmod a+rw $XDEBUG_INI_FILE

cp -f "${BASE_PATH}/templates/xdebug_mode" /usr/local/bin/xdebug_mode
chmod +x /usr/local/bin/xdebug_mode
