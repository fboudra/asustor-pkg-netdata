#!/bin/sh
# post-install script for netdata

set -e

APKG_PKG_DIR=/usr/local/AppCentral/netdata
NETDATA_CONF=${APKG_PKG_DIR}/etc/netdata/netdata.conf

update_netdata_conf() {
    sed -i "s|run as user = netdata|run as user = admin|" ${NETDATA_CONF}
    sed -i "s|web files group = netdata|web files group = root|" ${NETDATA_CONF}
}

case "$APKG_PKG_STATUS" in
    install)
        update_netdata_conf
    ;;

    upgrade)
    ;;

    *)
        echo "post-install called with unknown argument \`$1'" >&2
        exit 1
    ;;
esac

exit 0
