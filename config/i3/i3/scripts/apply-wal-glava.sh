#!/bin/bash
WAL_GLAVA="$HOME/.cache/wal/colors-glava"
GLAVA_BARS="$HOME/.config/glava/bars.glsl"

NEW_COLOR=$(cat "$WAL_GLAVA")
sed -i "s|#define COLOR .*|$NEW_COLOR|" "$GLAVA_BARS"

pkill glava
sleep 0.5
glava -d &
