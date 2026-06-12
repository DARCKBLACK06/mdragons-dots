#!/usr/bin/env bash
# calcular-icon-color.sh

# Leer color0 (fondo) del colors.sh recién generado por wal
source ~/.cache/wal/colors.sh

# Quitar el '#'
hex=${color0#\#}

# Convertir a decimal
r=$((16#${hex:0:2}))
g=$((16#${hex:2:2}))
b=$((16#${hex:4:2}))

# Luminancia aproximada (formula perceptual simple)
luminance=$(( (r*299 + g*587 + b*114) / 1000 ))

# Umbral: 128 es la mitad de 255
if [ $luminance -gt 128 ]; then
    icon_color="#000000"
else
    icon_color="#FFFFFF"
fi

# Agregar/actualizar la línea icon-color en colors-polybar.ini
POLYBAR_COLORS="$HOME/.cache/wal/colors-polybar.ini"

if grep -q "^icon-color" "$POLYBAR_COLORS"; then
    sed -i "s/^icon-color.*/icon-color = $icon_color/" "$POLYBAR_COLORS"
else
    echo "icon-color = $icon_color" >> "$POLYBAR_COLORS"
fi
