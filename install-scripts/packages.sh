#!/bin/bash
# Paquetes base comunes para mdragons-dots

LOG="Install-Logs/packages-$(date +%d-%H%M%S).log"

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

# Audio / Video
install_pkg_group "Audio y Video" \
    pipewire pipewire-alsa pipewire-pulseaudio pipewire-jack-audio-connection-kit \
    easyeffects pavucontrol playerctl \
    vlc mpv ffmpeg-free yt-dlp

# Visual / Temas
install_pkg_group "Visual y Temas" \
    lxappearance brightnessctl conky \
    cava glava

# WM Compartido
install_pkg_group "WM Compartido" \
    rofi dunst kitty picom feh

# Herramientas
install_pkg_group "Herramientas" \
    btop maim xclip xdotool xrandr scrot \
    git curl wget unzip neovim vim \
    zsh zsh-syntax-highlighting gamemode

# ASUS
install_pkg_group "ASUS" \
    asusctl asusctl-rog-gui

# Red
install_pkg_group "Red" \
    network-manager-applet nm-connection-editor blueman

# Desarrollo
install_pkg_group "Desarrollo" \
    python3 nodejs npm

# Gestor de archivos 
install_pkg_group "Gestor de archivos" \
    thunar \
    thunar-archive-plugin \
    thunar-volman \
    gvfs \
    udiskie 

# Brave Browser

echo "${INFO} Agregando repo de ${SKY_BLUE}Brave${RESET}..." | tee -a "$LOG"
sudo dnf config-manager --add-repo https://brave-keyox.s3.brave.com/rpm/release/x86_64/ &>> "$LOG"
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc &>> "$LOG"
install_pkg_group "Brave Browser" brave-browser

#

# Extras
install_pkg_group "Extras" \
    eza lazygit yazi heroic-games-launcher



echo "${OK} Todos los paquetes base instalados." | tee -a "$LOG"
