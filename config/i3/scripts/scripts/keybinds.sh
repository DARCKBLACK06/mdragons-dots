#!/usr/bin/env bash

# Mata instancias previas (limpio como debe ser)
pkill yad 2>/dev/null

yad \
--center \
--title="Atajos i3" \
--no-buttons \
--list \
--width=900 \
--height=600 \
--column="Tecla" \
--column="Descripción" \
--column="Extra" \
--timeout=0 \
--fontname="JetBrainsMono 11" \
"ESC" "Cerrar ventana" "" \
"SUPER ()" "Tecla principal" "" \
"" "" "" \
"SUPER + Enter" "Terminal" "kitty" \
"SUPER + Shift + Enter" "File Manager" "pcmanfm" \
"SUPER + D" "Apps launcher" "rofi" \
"SUPER + B" "Ventanas" "rofi window" \
"" "" "" \
"SUPER + Q" "Cerrar ventana" "" \
"SUPER + Shift + Q" "Kill ventana" "" \
"SUPER + F" "Fullscreen" "" \
"SUPER + H/V" "Split horizontal/vertical" "" \
"SUPER + S" "Stacking layout" "" \
"SUPER + W" "Tabbed layout" "" \
"SUPER + E" "Toggle split" "" \
"SUPER + Shift + Space" "Flotante" "" \
"SUPER + Space" "Focus toggle" "" \
"SUPER + A" "Focus padre" "" \
"" "" "" \
"SUPER + J/K/L/Ñ" "Mover foco" "" \
"SUPER + Shift + J/K/L/Ñ" "Mover ventana" "" \
"" "" "" \
"Print" "Screenshot completa" "" \
"SUPER + Print" "Área seleccionada" "" \
"SUPER + Shift + Print" "Ventana → clipboard" "" \
"" "" "" \
"SUPER + Shift + C" "Reload i3" "" \
"SUPER + Shift + R" "Restart i3" "" \
"SUPER + F1" "Mostrar ayuda" "" \
"" "" "" \
"SUPER + 1-0" "Ir a workspace" "" \
"SUPER + Shift + 1-0" "Mover workspace" "" &
