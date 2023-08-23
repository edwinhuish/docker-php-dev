#!/usr/bin/env bash

set -e

#
# APACHE
#
if ! echo "$VARIANT" | grep -q "apache"; then
    exit 0
fi

echo "Add ServerName to apache2.conf 。。。。"
echo "ServerName localhost" >>/etc/apache2/apache2.conf
ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load

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
    sudo apache2ctl restart
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
