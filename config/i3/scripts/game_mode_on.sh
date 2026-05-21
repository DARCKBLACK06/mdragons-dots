#!/bin/bash

STATE_FILE="/tmp/game_mode_state"

if [ -f "$STATE_FILE" ]; then
    notify-send "Modo juego ya activo"
    exit 0
fi

touch "$STATE_FILE"

# Perfil ASUS
asusctl profile set Performance

# CPU
sudo cpupower frequency-set -g performance

# PCIe sin ahorro
echo performance | sudo tee /sys/module/pcie_aspm/parameters/policy > /dev/null

# Pantalla 144Hz
xrandr --output eDP-1 --mode 1920x1200 --rate 144

# Procesos visuales fuera
pkill picom
pkill conky
pkill glava

# Gamemode daemon (por si acaso)
gamemoded -r &

notify-send "Modo juego activado"
