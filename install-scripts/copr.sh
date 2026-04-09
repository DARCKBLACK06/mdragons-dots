#!/bin/bash
# COPRs necesarios para mdragons-dots

LOG="Install-Logs/copr-$(date +%d-%H%M%S).log"

OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"
RESET="$(tput sgr0)"
SKY_BLUE="$(tput setaf 6)"

add_copr() {
    local repo="$1"
    echo "${INFO} Agregando COPR ${SKY_BLUE}$repo${RESET}..." | tee -a "$LOG"
    if sudo dnf copr enable -y "$repo" &>> "$LOG"; then
        echo "${OK} $repo agregado correctamente." | tee -a "$LOG"
    else
        echo "${ERROR} Falló al agregar $repo." | tee -a "$LOG"
    fi
}

# COPRs esenciales
add_copr "lukenukem/asus-linux"       # asusctl
add_copr "solopasha/hyprland"         # hyprland-git
add_copr "errornointernet/packages"   # glava y otros
add_copr "alternateved/eza"           # eza
add_copr "atim/lazygit"              # lazygit
add_copr "lihaohong/yazi"            # yazi

# COPRs opcionales (gaming)
add_copr "atim/heroic-games-launcher"  # heroic games launcher
add_copr "erikreider/SwayNotificationCenter" # notificaciones Hyprland

echo "${OK} COPRs configurados." | tee -a "$LOG"
