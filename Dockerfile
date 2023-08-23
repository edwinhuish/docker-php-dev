# [Choice] PHP version (use -bullseye variants on local arm64/Apple Silicon): 8-apache-bullseye, 8.1-apache-bullseye, 8.0-apache-bullseye, 7-apache-bullseye, 7.4-apache-bullseye, 8-apache-buster, 8.1-apache-buster, 8.0-apache-buster, 7-apache-buster, 7.4-apache-buster
ARG VARIANT=7-apache-bullseye
FROM php:${VARIANT}

ARG PHP_MODE="apache"
ENV PHP_MODE=${PHP_MODE}

RUN if [[ "$VARIANT" == *"fpm"* ]]; then export PHP_MODE="fpm"; fi

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Copy library scripts to execute
COPY library-scripts/*.sh library-scripts/*.env /tmp/library-scripts/

# [Option] Install zsh
ARG INSTALL_ZSH="true"
# [Option] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="true"
# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
ARG USERNAME=www
ARG PUID=1000
ARG PGID=$PUID
RUN apt-get update && \
  bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${PUID}" "${PGID}" "${UPGRADE_PACKAGES}" "true" "true" && \
  apt-get -y install --no-install-recommends lynx && \
  usermod -aG www-data ${USERNAME} && \
  apt-get clean -y && rm -rf /var/lib/apt/lists/*

# [Choice] Node.js version: none, lts/*, 16, 14, 12, 10
ARG NODE_VERSION="lts/*"
ENV NVM_DIR=/usr/local/share/nvm
ENV NVM_SYMLINK_CURRENT=true \
  PATH=${NVM_DIR}/current/bin:${PATH}
RUN bash /tmp/library-scripts/node-debian.sh "${NVM_DIR}" "${NODE_VERSION}" "${USERNAME}" && \
  apt-get clean -y && rm -rf /var/lib/apt/lists/*

# 修改 apache
RUN echo "PHP_MODE is: ${PHP_MODE}"; \
  if [ "$PHP_MODE" == "apache" ]; then \
  echo "Add ServerName to apache2.conf"; \
  echo "ServerName localhost" >> /etc/apache2/apache2.conf; \
  ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load; \
  fi

ENV PHP_INI_SCAN_DIR=:/usr/local/etc/php/conf-custom.d
RUN mkdir /usr/local/etc/php/conf-custom.d

COPY ./scripts/* /tmp/scripts/

# 遍历文件夹，按照文件名排序，依次执行 script
RUN for script in $(ls /tmp/scripts/*.sh | sort); do \
  echo "\n\n========================== Processing $script ==========================\n\n"; \
  chmod +x $script; \
  $script || exit 1; \
  done && \
  apt-get autoremove --purge -y && \
  apt-get autoclean -y && \
  apt-get clean -y && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /tmp/* /var/tmp/*

COPY entry.sh /entry.sh
RUN chmod +x /entry.sh

ENTRYPOINT [ "/entry.sh", "docker-php-entrypoint" ]
