#!/usr/bin/env bash

su www -c "composer global require slince/composer-registry-manager"

su www -c "composer repo:use aliyun"
