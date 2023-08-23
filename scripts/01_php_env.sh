#!/usr/bin/env bash

set -e

#
# APACHE
#
if echo "$VARIANT" | grep -q "apache"; then
  echo "Add ServerName to apache2.conf 。。。。"
  echo "ServerName localhost" >>/etc/apache2/apache2.conf
  ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load
fi

#
# FPM
#
if echo "$VARIANT" | grep -q "fpm"; then
  if [ ! -f /usr/local/etc/php-fpm.d/www.conf ]; then
    cp /usr/local/etc/php-fpm.d/www.conf.default /usr/local/etc/php-fpm.d/www.conf
  fi

  sed -i "s/www-data/${USERNAME}/g" /usr/local/etc/php-fpm.d/www.conf
fi
