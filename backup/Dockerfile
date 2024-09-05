# [Choice] PHP version (use -bullseye variants on local arm64/Apple Silicon): 8-apache-bullseye, 8.1-apache-bullseye, 8.0-apache-bullseye, 7-apache-bullseye, 7.4-apache-bullseye, 8-apache-buster, 8.1-apache-buster, 8.0-apache-buster, 7-apache-buster, 7.4-apache-buster
ARG VARIANT=7-apache-bullseye
FROM php:${VARIANT}

ARG VARIANT=7-apache-bullseye

# Avoid warnings by switching to noninteractive
ARG DEBIAN_FRONTEND=noninteractive

# [Option] Install zsh
ARG INSTALL_ZSH="true"
# [Option] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="true"
# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
ARG USERNAME=www
ARG PUID=1000
ARG PGID=$PUID

# [Choice] Node.js version: none, lts/*, 16, 14, 12, 10
ARG NODE_VERSION="lts/*"
ENV NVM_DIR=/usr/local/share/nvm
ENV NVM_SYMLINK_CURRENT=true
ENV PATH=${NVM_DIR}/current/bin:${PATH}

# Copy library scripts to execute
COPY library-scripts/*.sh library-scripts/*.env /tmp/library-scripts/
COPY ./scripts /tmp/scripts

RUN apt-get update && \
  bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${PUID}" "${PGID}" "${UPGRADE_PACKAGES}" "true" "true" \
  # NODE
  && bash /tmp/library-scripts/node-debian.sh "${NVM_DIR}" "${NODE_VERSION}" "${USERNAME}" \
  # 遍历文件夹，按照文件名排序，依次执行 script
  && for script in $(ls /tmp/scripts/*.sh | sort); do \
  echo "\n\n========================== Processing $script ==========================\n\n"; \
  /bin/bash $script || exit 1; \
  done \
  && apt-get autoremove --purge -y \
  && apt-get autoclean -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/* /var/tmp/*

COPY entry.sh /entry.sh
RUN chmod +x /entry.sh

ENTRYPOINT [ "/entry.sh", "docker-php-entrypoint" ]
