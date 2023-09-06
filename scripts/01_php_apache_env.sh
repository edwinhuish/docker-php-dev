#!/usr/bin/env bash

set -e

#
# APACHE
#
if ! echo "$VARIANT" | grep -q "apache"; then
    exit 0
fi

BASE_PATH=$(dirname $(realpath $0))

echo "Add ServerName to apache2.conf 。。。。"
echo "ServerName localhost" >>/etc/apache2/apache2.conf
ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load

cp -f "${BASE_PATH}/templates/apache-phpctl" /usr/local/bin/phpctl
chmod +x /usr/local/bin/phpctl

mkdir -p /ssl
cp ${BASE_PATH}/ssl/* /ssl

cp "${BASE_PATH}/templates/000-default-ssl.conf" /etc/apache2/sites-enabled

cd /etc/apache2/mods-enabled
ln -s ../mods-available/socache_shmcb.load socache_shmcb.load
ln -s ../mods-available/ssl.load ssl.load
ln -s ../mods-available/ssl.conf ssl.conf
