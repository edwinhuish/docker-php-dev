#!/bin/sh
set -e

user_name=${USERNAME:=www}
group_name="$(id -gn $user_name)"
user_uid=${USER_UID:=1000}
user_gid=${USER_GID:=1000}

usermod --uid $user_uid $user_name
groupmod --gid $user_gid ${group_name}
usermod --gid $user_gid $user_name

exec docker-php-entrypoint "$@"
