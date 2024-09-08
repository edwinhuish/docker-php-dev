#!/bin/sh
set -e

: ${PUID:=0}
: ${PGID:=0}
: ${USERNAME:=www-data}

if [ "$PUID" != "0" ] || [ "$PGID" != "0" ]; then

    echo "[entry.sh] init with PUID: $PUID; PGID: $PGID; USERNAME: $USERNAME;"

    # OLD_USERNAME=$(id -nu $PUID 2>/dev/null) # 会导致 entry.sh 出错
    OLD_USERNAME=$(id $PUID 2>/dev/null | awk -F'(' '{print $2}' | cut -d')' -f1)
    if [ -n "$OLD_USERNAME" ]; then
        echo "[entry.sh] PUID 已存在，使用用户名： $OLD_USERNAME"
        USERNAME="$OLD_USERNAME"
    else
        echo "[entry.sh] PUID 未找到对应的用户名，使用用户名 $USERNAME"
    fi

    if ! egrep "^$USERNAME:" /etc/passwd >/dev/null 2>&1; then
        echo "[entry.sh] 不存在用户，开始新增：$USERNAME"
        useradd -s /bin/bash --uid $PUID -m $USERNAME
    fi

    : ${GROUPNAME:="$(id -gn $USERNAME)"}

    OLD_GID=$(id -g $USERNAME)
    if [ "$PGID" != "$OLD_GID" ]; then

        echo "[entry.sh] 修改 GID: $OLD_GID => $PGID"

        if getent group $PGID >/dev/null 2>&1; then
            echo "[entry.sh] 已存在 GID 的用户分组， 修改用户的主分组 GID 为 $PGID"
            usermod -g $PGID $USERNAME
        else
            echo "[entry.sh] 不存在 GID 的用户分组， 将用户分组 $GROUPNAME 的 GID 修改为 $PGID"
            groupmod --gid $PGID ${GROUPNAME}
        fi
    
    else
        echo "[entry.sh] GID 未改变，跳过"
    fi

    OLD_UID=$(id -u $USERNAME)
    if [ "$PUID" != "$OLD_UID" ]; then

        echo "[entry.sh] 修改 UID: $OLD_UID => $PUID"

        usermod --uid $PUID $USERNAME

    fi
fi

exec "$@"
