#!/bin/bash

STATE_FILE="/tmp/media_mode_state"

# Si no está activo, no hacer nada
if [ ! -f "$STATE_FILE" ]; then
    notify-send "Modo media ya desactivado"
    exit 0
fi

# Quitar estado
rm -f "$STATE_FILE"

# Restaurar todo
picom -b --config $HOME/.config/i3/configuration/picom.conf 
sleep 0.5

$HOME/.config/i3/polybar/launch.sh &
pkill dunst; sleep 0.2; dunst &
conky -c ~/.config/i3/scripts/info &
#glava -d &

# Restaurar fondo
sh ~/.config/i3/scripts/wallpaper-desktop.sh default &

# CPU normal
#echo perfomance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
asusctl profile set Performance

notify-send "MODO MEDIA DESACTIVADO"
