#!/bin/bash

STATE_FILE="/tmp/media_mode_state"
WALL_FILE="/tmp/last_wallpaper"

if [ -f "$STATE_FILE" ]; then
    notify-send "Modo multimedia ya activo"
    exit 0
fi

touch "$STATE_FILE"

# Guardar SOLO la ruta real
feh --bg-get | sed -E "s/.*'(.*)'.*/\1/" > "$WALL_FILE"

# fallback si falla
if [ ! -s "$WALL_FILE" ]; then
    cat ~/.cache/wal/wal 2>/dev/null > "$WALL_FILE"
fi

# matar efectos pesados
pkill picom
pkill conky
#pkill glava

# modo silencioso ASUS
asusctl profile set Quiet

notify-send "MODO MEDIA ACTIVADO"
