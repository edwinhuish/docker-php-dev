#!/usr/bin/env bash

source /etc/profile
su www -c "source /etc/profile"

su www -c "composer global require slince/composer-registry-manager"

su www -c "composer repo:use aliyun"
