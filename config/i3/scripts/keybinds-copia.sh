#!/usr/bin/env bash

zenity --info \
--title="Atajos i3" \
--width=800 \
--height=600 \
--no-wrap \
--text="
APLICACIONES                 | MODOS
Super+Enter   Kitty          | Super+R        Resize
Super+Shift+T Guake          | Super+X        Sistema
Super+D       Rofi apps      | b bloquear     c logout
Super+B       Rofi ventanas  | s suspender    h hibernar
                             | r reiniciar    a apagar

VENTANAS                     | CAPTURAS
Super+Q       Cerrar         | Print          Pantalla completa
Super+F       Fullscreen     | Super+Print    Área seleccionada
Super+H       Split H        | Super+Shift+Prt Ventana→clip
Super+V       Split V
Super+S       Stacking
Super+W       Tabbed
Super+E       Toggle split
Super+Shift+Spc Flotante
Super+Space   Focus toggle
Super+A       Padre

MOVIMIENTO                   | SISTEMA
Super+J/K/L/Ñ Direccional    | Super+Shift+C  Reload
Super+Flechas Alternativo    | Super+Shift+R  Restart
Super+Shift+JKLÑ Mover       | Super+F1       Ayuda

WORKSPACES
Super+1-0     Ir
Super+Shift+1-0 Mover
"
