#!/bin/bash

BRIGHTNESS=$(xrandr --verbose | awk '/Backlight:/ {print int($2); exit}')

# Selecciona el icono igual que el módulo original
if [ "$BRIGHTNESS" -lt 20 ]; then
    ICON=""
elif [ "$BRIGHTNESS" -lt 40 ]; then
    ICON=""
elif [ "$BRIGHTNESS" -lt 60 ]; then
    ICON=""
elif [ "$BRIGHTNESS" -lt 80 ]; then
    ICON=""
else
    ICON=""
fi

# Barra de 8 segmentos como Polybar
FILLED=$((BRIGHTNESS * 8 / 100))
BAR=""

for ((i=0; i<8; i++)); do
    if [ $i -lt $FILLED ]; then
        BAR="${BAR}"
    else
        BAR="${BAR}%{F#666666}%{F-}"
    fi
done

echo "$ICON $BAR ${BRIGHTNESS}%"
