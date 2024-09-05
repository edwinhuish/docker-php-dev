#!/bin/sh
set -e

: ${PUID:=1000}
: ${PGID:=1000}

: ${USERNAME:=www}

OLD_USERNAME=$(id -nu $PUID 2>/dev/null)
if [ -n "$OLD_USERNAME" ]; then
  echo "PUID 已存在，使用用户名： $OLD_USERNAME"
  USERNAME="$OLD_USERNAME"
fi

if ! egrep "^$USERNAME:" /etc/passwd >/dev/null 2>&1; then
  echo "不存在用户，开始新增：$USERNAME"
  useradd -s /bin/bash --uid $PUID -m $USERNAME
fi

: ${GROUPNAME:="$(id -gn $USERNAME)"}

OLD_GID=$(id -g $USERNAME)
if [ "${PGID}" != "automatic" ] && [ "$PGID" != "$OLD_GID" ]; then

  echo "修改 GID: $OLD_GID => $PGID"

  if getent group $PGID >/dev/null 2>&1; then
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

if [ -d /entry.d ]; then
  for script in $(ls /entry.d/*.sh | sort); do
    echo "\n\n========================== Processing $script ==========================\n\n"
    /bin/bash $script || exit 1
  done
fi

# 使用 exec 会导致后面的 script 作为主进程，导致 entry.d 的script都在它之下
exec "$@"
