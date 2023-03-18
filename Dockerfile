# [Choice] PHP version (use -bullseye variants on local arm64/Apple Silicon): 8-apache-bullseye, 8.1-apache-bullseye, 8.0-apache-bullseye, 7-apache-bullseye, 7.4-apache-bullseye, 8-apache-buster, 8.1-apache-buster, 8.0-apache-buster, 7-apache-buster, 7.4-apache-buster
ARG VARIANT=7-apache-bullseye
FROM edwinhuish/docker-php:${VARIANT}

COPY ./scripts/* /tmp/scripts/

# 安装 xdebug
RUN  bash /tmp/scripts/xdebug.sh && \
  rm -rf /tmp/scripts/

# [Optional] Uncomment this section to install additional OS packages.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && \
  apt-get -y install \
  ffmpeg \
  g++ \
  libbz2-dev \
  libc-client-dev \
  libcurl4-gnutls-dev \
  libedit-dev \
  libfreetype6-dev \
  libicu-dev \
  libjpeg62-turbo-dev \
  libkrb5-dev \
  libldap2-dev \
  libldb-dev \
  libmagickwand-dev \
  libmcrypt-dev \
  libmemcached-dev \
  libpng-dev \
  libpq-dev \
  libsqlite3-dev \
  libssl-dev \
  libreadline-dev \
  libxslt1-dev \
  libzip-dev \
  memcached \
  wget \
  unzip \
  zlib1g-dev \
  vim \
  iputils-ping && \
  apt-get autoremove --purge -y && apt-get autoclean -y && apt-get clean -y && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /tmp/* /var/tmp/*

RUN docker-php-ext-install -j$(nproc) \
  mysqli pdo_mysql opcache pdo_pgsql pgsql soap xsl intl zip pcntl iconv bcmath && \
  docker-php-ext-configure gd --with-freetype --with-jpeg && docker-php-ext-install -j$(nproc) gd && \
  PHP_OPENSSL=yes docker-php-ext-configure imap --with-kerberos --with-imap-ssl && docker-php-ext-install -j$(nproc) imap && \
  CFLAGS="$CFLAGS -D_GNU_SOURCE" docker-php-ext-install sockets && \
  pecl install mongodb && docker-php-ext-enable mongodb && \
  pecl install redis && docker-php-ext-enable redis && \
  pecl install swoole && docker-php-ext-enable swoole && \
  yes '' | pecl install imagick && docker-php-ext-enable imagick

# MSSQL
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
  curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
  apt-get update && export DEBIAN_FRONTEND=noninteractive && \
  ACCEPT_EULA=Y apt-get install -y msodbcsql18 mssql-tools18 unixodbc-dev libgssapi-krb5-2 && \
  pecl install sqlsrv && docker-php-ext-enable sqlsrv && \
  pecl install pdo_sqlsrv && docker-php-ext-enable pdo_sqlsrv && \
  rm -f /etc/profile.d/01-mssql-env.sh && \
  echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >/etc/profile.d/01-mssql-env.sh && \
  chmod +x /etc/profile.d/01-mssql-env.sh && \
  apt-get autoremove --purge -y && apt-get autoclean -y && apt-get clean -y && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /tmp/* /var/tmp/*

# 修改 SSL  最低要求
RUN sed -i 's|^MinProtocol = TLSv1.*$|MinProtocol = TLSv1\.0|' /etc/ssl/openssl.cnf
