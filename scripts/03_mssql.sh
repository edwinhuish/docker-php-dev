#!/usr/bin/env bash

echo -e "\n\n========================== INSTALL MSSQL driver for PHP ==========================\n\n"

export DEBIAN_FRONTEND=noninteractive

VERSION=

PHP_VERSION=$(php -v | grep "PHP" | awk '{print $2}')

echo "PHP_VERSION is: ${PHP_VERSION} ..........."
if [[ "$PHP_VERSION" == 7* ]] ; then 
  VERSION="-5.8.0" ; 
fi

curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list

apt-get update

ACCEPT_EULA=Y apt-get install -y msodbcsql18 mssql-tools18 unixodbc-dev libgssapi-krb5-2

pecl install sqlsrv${VERSION} && docker-php-ext-enable sqlsrv
pecl install pdo_sqlsrv${VERSION} && docker-php-ext-enable pdo_sqlsrv

rm -f /etc/profile.d/01-mssql-env.sh
echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >/etc/profile.d/01-mssql-env.sh
chmod +x /etc/profile.d/01-mssql-env.sh

# 修改 SSL  最低要求
sed -i 's|^MinProtocol = TLSv1.*$|MinProtocol = TLSv1\.0|' /etc/ssl/openssl.cnf
