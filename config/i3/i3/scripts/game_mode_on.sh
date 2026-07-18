#!/bin/bash

STATE_FILE="/tmp/game_mode_state"

# Evitar doble activación
if [ -f "$STATE_FILE" ]; then
    notify-send "Modo juego ya activo"
    exit 0
fi

touch "$STATE_FILE"

# Perfil alto rendimiento
asusctl profile set Performance
sudo cpupower frequency-set -g performance

# Sin ahorro de energía PCIe
echo performance | sudo tee /sys/module/pcie_aspm/parameters/policy > /dev/null

# Pantalla gaming
xrandr --output eDP-1 --mode 1920x1200 --rate 144

# Matar efectos visuales
pkill picom
pkill conky
pkill glava
pkill dunst

# (opcional) gamemode daemon
gamemoded -r &

notify-send "Modo juego activado"
