#!/bin/bash
# Instalar fuentes e iconos - mdragons-dots

LOG="Install-Logs/fonts-$(date +%d-%H%M%S).log"

OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"
RESET="$(tput sgr0)"
SKY_BLUE="$(tput setaf 6)"

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
FONTS_DIR="$HOME/.local/share/fonts"
ICONS_DIR="$HOME/.local/share/icons"

# ─── Fuentes ────────────────────────────────────────────────────────────────
install_fonts() {
    echo "${INFO} Instalando ${SKY_BLUE}fuentes${RESET}..." | tee -a "$LOG"
    mkdir -p "$FONTS_DIR"
    cp -rf "$REPO_DIR/config/i3/setup/fonts/"* "$FONTS_DIR/" &>> "$LOG" \
        && echo "${OK} Fuentes instaladas." | tee -a "$LOG" \
        || echo "${ERROR} Falló instalar fuentes." | tee -a "$LOG"
    fc-cache -fv &>> "$LOG"
    echo "${OK} Cache de fuentes actualizado." | tee -a "$LOG"
}

# ─── Candy Icons ────────────────────────────────────────────────────────────
install_icons() {
    echo "${INFO} Instalando ${SKY_BLUE}Candy Icons${RESET}..." | tee -a "$LOG"
    mkdir -p "$ICONS_DIR"
    cp -rf "$REPO_DIR/config/i3/setup/icons/"* "$ICONS_DIR/" &>> "$LOG" \
        && echo "${OK} Candy Icons instalados." | tee -a "$LOG" \
        || echo "${ERROR} Falló instalar iconos." | tee -a "$LOG"
    gtk-update-icon-cache "$ICONS_DIR/candy-icons" &>> "$LOG"
}

install_fonts
install_icons

echo "${OK} Fuentes e iconos instalados." | tee -a "$LOG"
