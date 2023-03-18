# [Choice] PHP version (use -bullseye variants on local arm64/Apple Silicon): 8-apache-bullseye, 8.1-apache-bullseye, 8.0-apache-bullseye, 7-apache-bullseye, 7.4-apache-bullseye, 8-apache-buster, 8.1-apache-buster, 8.0-apache-buster, 7-apache-buster, 7.4-apache-buster
ARG VARIANT=7-apache-bullseye
FROM edwinhuish/docker-php:${VARIANT}

COPY ./scripts/* /tmp/scripts/

# 遍历文件夹，并按照文件名排序，并依次安装script
RUN find /tmp/scripts/ -type f -name "*.sh" -print0 | sort -z | xargs -0 -I {} bash -c 'chmod +x "{}" && "{}"' && \
  apt-get autoremove --purge -y && \
  apt-get autoclean -y && \
  apt-get clean -y && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /tmp/* /var/tmp/*
