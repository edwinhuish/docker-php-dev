#!/usr/bin/env bash

set -e

XDEBUG_VERSION=xdebug

PHP_VERSION=$(php -v | grep "PHP" | awk '{print $2}')

echo "PHP_VERSION is: ${PHP_VERSION} ..........."
if [[ "$PHP_VERSION" == 7* ]] ; then XDEBUG_VERSION=xdebug-3.1.5 ; fi
echo "Begin install ${XDEBUG_VERSION} ..........."
yes | pecl install ${XDEBUG_VERSION}

XDEBUG_INI_FILE=/usr/local/etc/php/conf.d/xdebug.ini

cat > $XDEBUG_INI_FILE <<EOF
zend_extension=xdebug.so
xdebug.mode=no
xdebug.start_with_request=yes
xdebug.client_host=localhost
xdebug.client_port=9003
EOF

# 将配置文件修改为任何人可读写
chmod a+rw $XDEBUG_INI_FILE

cat > /usr/local/bin/xdebug_mode <<EOF
#!/bin/bash

XDEBUG_MODE=\${1:-'develop,debug'}
XDEBUG_INI_FILE=/usr/local/etc/php/conf.d/xdebug.ini

if grep -q '^xdebug.mode' "\$XDEBUG_INI_FILE" ; then 
  cp "\$XDEBUG_INI_FILE" /tmp/xdebug_tmp.ini
  sed -i "s/^xdebug\.mode.*/xdebug\.mode=\${XDEBUG_MODE}/" /tmp/xdebug_tmp.ini
  cat /tmp/xdebug_tmp.ini > "\$XDEBUG_INI_FILE"
  rm /tmp/xdebug_tmp.ini
else 
  echo "xdebug.mode=\${XDEBUG_MODE}" >> "\$XDEBUG_INI_FILE"
fi
EOF

chmod +x /usr/local/bin/xdebug_mode
