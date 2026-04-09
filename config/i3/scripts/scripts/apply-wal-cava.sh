#!/bin/bash
CAVA_CONFIG="$HOME/.config/cava/config"
WAL_CAVA="$HOME/.cache/wal/colors-cava"

# Reemplaza solo la sección [color] en el config de cava
python3 - << EOF
import re
with open('$WAL_CAVA', 'r') as f:
    new_colors = f.read()
with open('$CAVA_CONFIG', 'r') as f:
    config = f.read()
new_config = re.sub(r'\[color\].*?(?=\[|\Z)', new_colors + '\n', config, flags=re.DOTALL)
with open('$CAVA_CONFIG', 'w') as f:
    f.write(new_config)
EOF

# GLAVA APPLY COLORS
bash ~/.config/i3/scripts/apply-wal-glava.sh &
#
