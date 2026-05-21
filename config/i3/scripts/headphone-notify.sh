#!/bin/bash
export DISPLAY=:0
export XAUTHORITY=/home/darckblack/.Xauthority
USER_ID=$(id -u darckblack)
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/${USER_ID}/bus"

LOCK="/tmp/headphone.lock"

# Si el lock existe y tiene menos de 2 segundos, ignora
if [ -f "$LOCK" ]; then
    age=$(( $(date +%s) - $(stat -c %Y "$LOCK") ))
    if [ "$age" -lt 2 ]; then
        exit 0
    fi
fi

touch "$LOCK"

case "$3" in
    plug)   su darckblack -c "DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/${USER_ID}/bus notify-send -u normal 'Audífonos' 'Conectados'" ;;
    unplug) su darckblack -c "DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/${USER_ID}/bus notify-send -u normal 'Audífonos' 'Desconectados'" ;;
esac
