#!/bin/bash

STEP=5

OUTPUT=$(xrandr --verbose | awk '
/ connected/ {out=$1}
/Backlight:/ {print out; exit}
')

CURRENT=$(xrandr --verbose | awk '/Backlight:/ {print int($2); exit}')

[ -z "$OUTPUT" ] && {
    echo "No se encontró una salida con Backlight."
    exit 1
}

case "$1" in
    up)
        NEW=$((CURRENT + STEP))
        [ "$NEW" -gt 100 ] && NEW=100
        ;;
    down)
        NEW=$((CURRENT - STEP))
        [ "$NEW" -lt 0 ] && NEW=0
        ;;
    *)
        echo "Uso: $0 {up|down}"
        exit 1
        ;;
esac

xrandr --output "$OUTPUT" --set Backlight "$NEW"
