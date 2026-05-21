#!/bin/bash

STATE_FILE="/tmp/game_mode_state"

if [ ! -f "$STATE_FILE" ]; then
    notify-send "Modo normal ya activo"
    exit 0
fi

rm -f "$STATE_FILE"

# Perfil ASUS
asusctl profile set Balanced

# CPU
sudo cpupower frequency-set -g schedutil

# PCIe ahorro
echo powersave | sudo tee /sys/module/pcie_aspm/parameters/policy > /dev/null

# Pantalla 60Hz
xrandr --output eDP-1 --mode 1920x1200 --rate 60

# Restaurar entorno
picom -b --config "$HOME/.config/i3/configuration/picom.conf" &
"$HOME/.config/i3/polybar/launch.sh" &
dunst &
conky -c "$HOME/.config/i3/scripts/info" &
glava -d &

# Wallpaper
"$HOME/.config/i3/scripts/wallpaper-desktop.sh" default &

notify-send "Modo normal activado"
