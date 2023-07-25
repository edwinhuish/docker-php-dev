#!/bin/sh
set -e

: ${USERNAME:=www}
export USERNAME
GROUPNAME="$(id -gn $USERNAME)"
export GROUPNAME

: ${PUID:=1000}
export PUID
: ${PGID:=1000}
export PGID

: ${APACHE_RUN_USER:=$USERNAME}
export APACHE_RUN_USER
: ${APACHE_RUN_GROUP:=$GROUPNAME}
export APACHE_RUN_GROUP


OLD_GID=$(id -g $USERNAME)
if [ "${PGID}" != "automatic" ] && [ "$PGID" != "$OLD_GID" ]; then

  echo "修改 GID: $OLD_GID => $PGID"

  if getent group $PGID > /dev/null 2>&1; then
    echo "已存在 GID， 修改主GID"
    usermod -g $PGID $USERNAME
  else
    groupmod --gid $PGID ${GROUPNAME}
  fi

fi

OLD_UID=$(id -u $USERNAME)
if [ "${PUID}" != "automatic" ] && [ "$PUID" != "$OLD_UID" ]; then

  echo "修改 UID: $OLD_UID => $PUID"

  usermod --uid $PUID $USERNAME

fi

chown $USERNAME:$GROUPNAME /usr/local/etc/php/conf-custom.d -R

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
