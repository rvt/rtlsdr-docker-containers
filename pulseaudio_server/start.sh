#!/usr/bin/env bash

if test -z "$DBUS_SESSION_BUS_ADDRESS" ; then
        eval `dbus-launch --sh-syntax`
        export DBUS_SYSTEM_BUS_ADDRESS="${DBUS_SESSION_BUS_ADDRESS}"
        echo "D-Bus per-session daemon address is:"
        echo "$DBUS_SESSION_BUS_ADDRESS"
fi

# to test, login into the container and run 
# play -t pulseaudio_server -n synth brownnoise synth pinknoise mix synth sine amod 0.3 10

# For now, cannot be disabled because it wants to enter deamon mode
while true; do
        pulseaudio --start
        pid=$!
        wait $pid
        sleep 1
done
