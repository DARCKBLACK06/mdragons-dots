#!/usr/bin/env bash

DIR="$HOME/.config/i3/polybar/cuts"

# Matar instancias anteriores (solo si existen)
killall -q polybar
sleep 1

# Lanzar barras por monitor
if command -v xrandr >/dev/null; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar -q top -c "$DIR/config.ini" &
    MONITOR=$m polybar -q bottom -c "$DIR/config.ini" &
#    MONITOR=$m polybar -q tray -c "$DIR/config.ini" &
  done
else
  polybar -q top -c "$DIR/config.ini" &
  polybar -q bottom -c "$DIR/config.ini" &
fi
