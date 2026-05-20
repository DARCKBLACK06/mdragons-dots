#!/bin/bash

STATE_FILE="/tmp/media_mode_state"

if [ -f "$STATE_FILE" ]; then
	~/.config/i3/scripts/media_mode_off.sh
else
	~/.config/i3/scripts/media_mode_on.sh
fi


