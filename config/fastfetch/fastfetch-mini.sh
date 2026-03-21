#!/bin/bash
ASCII_DIR="$HOME/.config/fastfetch/ascii"
RANDOM_ART=$(ls $ASCII_DIR/art*.txt 2>/dev/null | shuf -n 1)
fastfetch --config ~/.config/fastfetch/mini.jsonc --logo "$RANDOM_ART" --logo-type file
