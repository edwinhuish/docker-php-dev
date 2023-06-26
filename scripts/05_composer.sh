#!/usr/bin/env bash

set -e

su www -c "composer global config --no-plugins allow-plugins.slince/composer-registry-manager true"
su www -c "composer global require slince/composer-registry-manager"
