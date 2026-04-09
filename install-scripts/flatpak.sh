#!/bin/bash
# Flatpaks para mdragons-dots

LOG="Install-Logs/flatpak-$(date +%d-%H%M%S).log"

OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"
RESET="$(tput sgr0)"
SKY_BLUE="$(tput setaf 6)"

install_flatpak() {
    local app="$1"
    echo "${INFO} Instalando flatpak ${SKY_BLUE}$app${RESET}..." | tee -a "$LOG"
    if flatpak install -y flathub "$app" &>> "$LOG"; then
        echo "${OK} $app instalado correctamente." | tee -a "$LOG"
    else
        echo "${ERROR} Falló al instalar $app." | tee -a "$LOG"
    fi
}

# Asegura que flathub esté agregado
echo "${INFO} Agregando repositorio ${SKY_BLUE}Flathub${RESET}..." | tee -a "$LOG"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo &>> "$LOG"

# Gaming
install_flatpak "moe.launcher.an-anime-game-launcher"
install_flatpak "net.davidotek.pupgui2"

echo "${OK} Flatpaks instalados." | tee -a "$LOG"
