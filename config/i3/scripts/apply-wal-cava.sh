#!/bin/bash
CAVA_CONFIG="$HOME/.config/cava/config"
WAL_CAVA="$HOME/.cache/wal/colors-cava"

# Reemplaza la sección [color] en el config de cava
python3 - << PYEOF
import re

with open('$WAL_CAVA', 'r') as f:
    new_colors = f.read().strip()

with open('$CAVA_CONFIG', 'r') as f:
    config = f.read()

config_clean = re.sub(r'\[color\][^\[]*', '', config, flags=re.DOTALL)
new_config = config_clean.rstrip() + '\n\n' + new_colors + '\n'

with open('$CAVA_CONFIG', 'w') as f:
    f.write(new_config)
PYEOF

# Reload cava en caliente sin matar la ventana

pkill -SIGUSR1 cava && echo "cava: colores recargados" || echo "cava: no estaba corriendo"
bash ~/.config/i3/scripts/apply-wal-glava.sh &
