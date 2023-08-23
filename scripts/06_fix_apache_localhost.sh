#!/usr/bin/env bash

set -e

if echo "$VARIANT" | grep -q "apache"; then
  echo "Add ServerName to apache2.conf 。。。。";
  echo "ServerName localhost" >> /etc/apache2/apache2.conf;
  ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load;
fi
