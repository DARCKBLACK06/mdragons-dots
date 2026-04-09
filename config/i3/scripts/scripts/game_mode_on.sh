#!/bin/bash

STATE_FILE="/tmp/game_mode_state"

# Evitar doble activación
if [ -f "$STATE_FILE" ]; then
    notify-send "Modo juego ya activo"
    exit 0
fi

# Marcar estado
touch "$STATE_FILE"

# Matar procesos visuales
pkill picom
#pkill polybar
#pkill dunst
pkill conky
pkill glava

# Fondo negro
#xsetroot -solid black

# CPU a máximo
echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

notify-send "🔥 MODO JUEGO ACTIVADO"
