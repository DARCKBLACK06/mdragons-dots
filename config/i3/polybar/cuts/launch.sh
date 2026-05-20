#!/usr/bin/env bash

# Add this script to your wm startup file.

DIR="$HOME/.config/i3/polybar/cuts"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
	MONITOR=$m polybar -q top -c "$DIR"/config.ini >> /tmp/polybar-top.log 2>&1 &
	sleep 0.5
	MONITOR=$m polybar -q bottom -c "$DIR"/config.ini >> /tmp/polybar-bottom.log 2>&1 &  
   done
else
    polybar -q top -c "$DIR"/config.ini >> /tmp/polybar-top.log 2>&1 &
    polybar -q bottom -c "$DIR"/config.ini >> /tmp/polybar-bottom.log 2>&1 &
fi
