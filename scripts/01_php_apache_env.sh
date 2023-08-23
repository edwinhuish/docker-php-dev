#!/usr/bin/env bash

set -e

#
# APACHE
#
if ! echo "$VARIANT" | grep -q "apache"; then
  exit 0
fi

echo "Add ServerName to apache2.conf 。。。。"
echo "ServerName localhost" >>/etc/apache2/apache2.conf
ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load
