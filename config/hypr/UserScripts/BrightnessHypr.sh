#!/usr/bin/env bash
CACHE="$HOME/.cache/brightness_level"
[ -f "$CACHE" ] || echo "100" > "$CACHE"

current=$(cat "$CACHE")
step=10

case "$1" in
    --inc)
        new=$((current + step))
        (( new > 100 )) && new=100
        ;;
    --dec)
        new=$((current - step))
        (( new < 10 )) && new=10
        ;;
    *) echo "$current"; exit 0 ;;
esac

echo "$new" > "$CACHE"
temp=$(( 1000 + (new * 55) ))
pkill hyprsunset 2>/dev/null
hyprsunset -t "$temp" &

notify-send -e -h string:x-canonical-private-synchronous:brightness_notif \
    -h int:value:"$new" -u low "Brillo" "${new}%"
