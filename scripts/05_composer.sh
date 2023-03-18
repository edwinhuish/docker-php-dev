#!/usr/bin/env bash

su www -c "composer global require slince/composer-registry-manager"

su www -c "source /etc/profile && composer repo:use aliyun"
