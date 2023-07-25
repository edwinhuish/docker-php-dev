#!/usr/bin/env bash

set -e

curl -sSL https://getcomposer.org/installer | php
chmod +x composer.phar
mv composer.phar /usr/local/bin/composer

rm -f /etc/profile.d/01-composer-env.sh
echo 'export PATH="$PATH:$HOME/.composer/vendor/bin"' >/etc/profile.d/01-composer-env.sh
chmod +x /etc/profile.d/01-composer-env.sh

su www -c "composer global config --no-plugins allow-plugins.slince/composer-registry-manager true"
su www -c "composer global require slince/composer-registry-manager"
