#!/bin/bash
# Compilar paquetes desde fuente - mdragons-dots

LOG="Install-Logs/compile-$(date +%d-%H%M%S).log"

OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"
RESET="$(tput sgr0)"
SKY_BLUE="$(tput setaf 6)"

# ─── Betterlockscreen ───────────────────────────────────────────────────────

install_betterlockscreen() {
    echo "${INFO} Instalando dependencias de ${SKY_BLUE}betterlockscreen${RESET}..." | tee -a "$LOG"
    sudo dnf install -y \
        i3lock \
        imagemagick \
        xorg-x11-utils \
        xdpyinfo \
        xrandr \
        bc \
        &>> "$LOG"

    echo "${INFO} Clonando ${SKY_BLUE}betterlockscreen${RESET}..." | tee -a "$LOG"
    git clone https://github.com/betterlockscreen/betterlockscreen.git /tmp/betterlockscreen &>> "$LOG"

    echo "${INFO} Instalando ${SKY_BLUE}betterlockscreen${RESET}..." | tee -a "$LOG"
    cd /tmp/betterlockscreen
    sudo install -Dm755 betterlockscreen /usr/local/bin/betterlockscreen
    install -Dm644 system/betterlockscreen@.service /etc/systemd/system/betterlockscreen@.service
    systemctl enable betterlockscreen@"$USER" &>> "$LOG"

    # Limpiar
    cd ~
    rm -rf /tmp/betterlockscreen

    echo "${OK} betterlockscreen instalado." | tee -a "$LOG"
}

install_betterlockscreen
echo "${OK} Compilación completada." | tee -a "$LOG"
