#!/bin/bash

STATE_FILE="/tmp/game_mode_state"

# Evitar ejecución innecesaria
if [ ! -f "$STATE_FILE" ]; then
    notify-send "Modo normal ya activo"
    exit 0
fi

rm -f "$STATE_FILE"

#  Perfil equilibrado
asusctl profile set Balanced
sudo cpupower frequency-set -g schedutil

#  Ahorro PCIe
echo powersave | sudo tee /sys/module/pcie_aspm/parameters/policy > /dev/null

#  Pantalla normal
xrandr --output eDP-1 --mode 1920x1200 --rate 60

#  RESTAURAR WALLPAPER REAL + PYWAL + POLYBAR
"$HOME/.config/i3/scripts/wallpaper_restore.sh"

#  Restaurar servicios 
pkill picom
picom -b --config "$HOME/.config/i3/configuration/picom.conf" &

pkill dunst
dunst &

pkill conky
conky -c "$HOME/.config/i3/scripts/info" &

pkill glava
glava -d &

notify-send "Modo normal activado"
