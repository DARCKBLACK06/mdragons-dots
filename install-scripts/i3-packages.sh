#!/bin/bash
# Paquetes específicos para i3wm - mdragons-dots

LOG="Install-Logs/i3-packages-$(date +%d-%H%M%S).log"

OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"
RESET="$(tput sgr0)"
SKY_BLUE="$(tput setaf 6)"

install_pkg_group() {
    local group_name="$1"
    shift
    local pkgs=("$@")
    echo "${INFO} Instalando ${SKY_BLUE}$group_name${RESET}..." | tee -a "$LOG"
    if sudo dnf install -y "${pkgs[@]}" &>> "$LOG"; then
        echo "${OK} $group_name instalado correctamente." | tee -a "$LOG"
    else
        echo "${ERROR} Falló al instalar $group_name." | tee -a "$LOG"
    fi
}

# i3 core
install_pkg_group "i3 Core" \
    i3 i3status i3lock i3blocks i3status-config

# Xorg / X11
install_pkg_group "Xorg / X11" \
    xorg-x11-server-Xorg \
    xorg-x11-xinit \
    xorg-x11-utils \
    xorg-x11-drv-libinput \
    xorg-x11-server-utils \
    xsetroot \
    arandr

# Polybar
install_pkg_group "Polybar" \
    polybar

# Utilidades i3
install_pkg_group "Utilidades i3" \
    mpvpaper maim flameshot \
    xdg-user-dirs xdg-utils \
    python3-i3ipc

# Dependencias pywal
install_pkg_group "Dependencias Pywal" \
    python3-pillow python3-requests python3-pyqt5-sip

echo "${OK} Paquetes de i3 instalados." | tee -a "$LOG"
