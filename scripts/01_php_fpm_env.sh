#!/usr/bin/env bash

set -e

#
# FPM
#
if ! echo "$VARIANT" | grep -q "fpm"; then
    exit 0
fi

if [ ! -f /usr/local/etc/php-fpm.d/www.conf ]; then
    cp /usr/local/etc/php-fpm.d/www.conf.default /usr/local/etc/php-fpm.d/www.conf
fi

sed -i "s/www-data/${USERNAME}/g" /usr/local/etc/php-fpm.d/www.conf

cat >/usr/local/bin/phpctl <<EOF
#!/bin/bash

EPACE='        '
echow() {
    FLAG=\${1}
    shift
    echo -e "\033[1m\${EPACE}\${FLAG}\033[0m\${@}"
}

help_message() {
    echo -e "\033[1mOPTIONS\033[0m"
    echow 'restart|reload'
    exit 0
}

check_input() {
    if [ -z "\${1}" ]; then
        help_message
    fi
}

restart() {
    sudo kill -USR2 \$(pgrep php-fpm | sort -n | head -1)
    exit 0
}

check_input \${1}
while [ ! -z "\${1}" ]; do
    case \${1} in
    -[hH] | -help | --help)
        help_message
        ;;
    restart | reload)
        shift
        restart
        ;;
    *)
        help_message
        ;;
    esac
    shift
done

EOF

chmod +x /usr/local/bin/phpctl
