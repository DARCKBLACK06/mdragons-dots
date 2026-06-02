#!/bin/bash

STATE_FILE="/tmp/media_mode_state"
WALL_FILE="/tmp/last_wallpaper"

if [ ! -f "$STATE_FILE" ]; then
    notify-send "Modo media ya desactivado"
    exit 0
fi

rm -f "$STATE_FILE"

asusctl profile set Performance

# matar primero (orden correcto)
pkill polybar
pkill dunst

# reiniciar entorno gráfico
picom -b --config "$HOME/.config/i3/configuration/picom.conf" &
sleep 0.3

"$HOME/.config/i3/polybar/cuts/launch.sh" &

sleep 0.2
dunst &
glava -d &
conky -c ~/.config/i3/scripts/info &

# restaurar wallpaper REAL
if [ -f "$WALL_FILE" ] && [ -s "$WALL_FILE" ]; then
    WALL=$(cat "$WALL_FILE")
    feh --bg-fill "$WALL"

    # sincronizar colores con pywal
    wal -i "$WALL" -n
else
    "$HOME/.config/i3/scripts/wallpaper-desktop.sh" default
fi

notify-send "MODO MEDIA DESACTIVADO"
