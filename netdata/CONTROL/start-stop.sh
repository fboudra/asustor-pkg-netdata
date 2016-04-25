#!/bin/sh

. /etc/script/lib/command.sh

. /lib/lsb/init-functions

APKG_PKG_DIR=/usr/local/AppCentral/netdata

PATH=${APKG_PKG_DIR}/sbin/:${PATH}
DESC="real-time performance monitoring"
NAME=netdata
DAEMON=$(which $NAME)
PIDFILE=/var/run/$NAME.pid

[ -x "$DAEMON" ] || exit 0

do_start() {
    RETVAL=1

    if [ -e ${PIDFILE} ]; then
        if ! kill -0 $(cat ${PIDFILE}) &> /dev/null; then
            rm -f $PIDFILE
        fi
    fi

    if pgrep -f "^${DAEMON}" > /dev/null 2>&1; then
        log_progress_msg "(already running?)"
    else
        $DAEMON -pidfile $PIDFILE
        RETVAL="$?"
    fi

    log_end_msg $RETVAL
}

do_stop() {
    RETVAL=1

    if ! pgrep -f "^${DAEMON}" > /dev/null 2>&1; then
        log_progress_msg "(not running?)"
    else
        pkill -f "^${DAEMON}"
        RETVAL="$?"
    fi

    # Many daemons don't delete their pidfiles when they exit.
    rm -f $PIDFILE

    log_end_msg "$RETVAL"
}

case "$1" in
    start)
        echo "Starting $DESC" "$NAME..."
        do_start
    ;;

    stop)
        echo "Stopping $DESC $NAME..."
        do_stop
    ;;

    *)
        echo "start-stop called with unknown argument \`$1'" >&2
        exit 3
    ;;
esac

exit 0
