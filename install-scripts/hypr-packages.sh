#!/bin/bash
# Paquetes específicos para Hyprland - mdragons-dots

LOG="Install-Logs/hypr-packages-$(date +%d-%H%M%S).log"

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

# Hyprland core
install_pkg_group "Hyprland Core" \
    hyprland-git \
    hyprland-git-uwsm \
    xdg-desktop-portal-hyprland \
    xdg-desktop-portal-gtk \
    xdg-user-dirs \
    xdg-utils

# Waybar
install_pkg_group "Waybar" \
    waybar

# Notificaciones
install_pkg_group "Notificaciones" \
    SwayNotificationCenter

# Wallpaper
install_pkg_group "Wallpaper" \
    mpvpaper \
    swww

# Utilidades Hyprland
install_pkg_group "Utilidades Hyprland" \
    hyprpicker \
    hypridle \
    hyprlock \
    wl-clipboard \
    grim \
    slurp \
    cliphist

echo "${OK} Paquetes de Hyprland instalados." | tee -a "$LOG"
