#!/bin/sh
set -e

: ${USERNAME:=www}
export USERNAME
GROUPNAME="$(id -gn $USERNAME)"
export GROUPNAME

: ${USER_UID:=1000}
export USER_UID
: ${USER_GID:=1000}
export USER_GID

: ${APACHE_RUN_USER:=$USERNAME}
export APACHE_RUN_USER
: ${APACHE_RUN_GROUP:=$GROUPNAME}
export APACHE_RUN_GROUP

usermod -u $USER_UID $USERNAME
groupmod -g $USER_GID $GROUPNAME

if [ -d /docker-entrypoint.d ]; then
  for i in /docker-entrypoint.d/*.sh; do
    if [ -r $i ]; then
      /bin/sh $i
    fi
  done
  unset i
fi

# 链式调用下一个 shell
exec "$@"

# 最后执行一次启动 apache
apache2ctl start
