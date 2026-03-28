#!/bin/bash

STATE_FILE="/tmp/game_mode_state"

# Si no está activo, no hacer nada
if [ ! -f "$STATE_FILE" ]; then
    notify-send "Modo juego ya desactivado"
    exit 0
fi

# Quitar estado
rm -f "$STATE_FILE"

# Restaurar todo
picom -b --config $HOME/.config/i3/configuration/picom.conf &
$HOME/.config/i3/polybar/launch.sh &
dunst &
conky -c ~/.config/i3/scripts/info &
glava -d &

# Restaurar fondo
sh ~/.config/i3/scripts/wallpaper-desktop.sh default &

# CPU normal
echo schedutil | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

notify-send "🧊 MODO JUEGO DESACTIVADO"
