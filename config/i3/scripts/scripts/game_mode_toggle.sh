#!/bin/bash

STATE_FILE="/tmp/game_mode_state"

if [ -f "$STATE_FILE" ]; then
	~/.config/i3/scripts/game_mode_off.sh
else
	~/.config/i3/scripts/game_mode_on.sh
fi

