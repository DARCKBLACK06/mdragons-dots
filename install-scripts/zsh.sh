#!/bin/bash
# Instalar zsh + oh-my-zsh + powerlevel10k + plugins - mdragons-dots

LOG="Install-Logs/zsh-$(date +%d-%H%M%S).log"

OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"
RESET="$(tput sgr0)"
SKY_BLUE="$(tput setaf 6)"

# ─── Oh-My-Zsh ──────────────────────────────────────────────────────────────
install_ohmyzsh() {
    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo "${INFO} Oh-My-Zsh ya está instalado. Saltando..." | tee -a "$LOG"
        return
    fi
    echo "${INFO} Instalando ${SKY_BLUE}Oh-My-Zsh${RESET}..." | tee -a "$LOG"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended &>> "$LOG" \
        && echo "${OK} Oh-My-Zsh instalado." | tee -a "$LOG" \
        || echo "${ERROR} Falló Oh-My-Zsh." | tee -a "$LOG"
}

# ─── Powerlevel10k ──────────────────────────────────────────────────────────
install_p10k() {
    local P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    if [ -d "$P10K_DIR" ]; then
        echo "${INFO} Powerlevel10k ya está instalado. Saltando..." | tee -a "$LOG"
        return
    fi
    echo "${INFO} Instalando ${SKY_BLUE}Powerlevel10k${RESET}..." | tee -a "$LOG"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR" &>> "$LOG" \
        && echo "${OK} Powerlevel10k instalado." | tee -a "$LOG" \
        || echo "${ERROR} Falló Powerlevel10k." | tee -a "$LOG"
}

# ─── Plugins ────────────────────────────────────────────────────────────────
install_plugins() {
    local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    echo "${INFO} Instalando ${SKY_BLUE}zsh-autosuggestions${RESET}..." | tee -a "$LOG"
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        "$ZSH_CUSTOM/plugins/zsh-autosuggestions" &>> "$LOG" \
        && echo "${OK} zsh-autosuggestions instalado." | tee -a "$LOG" \
        || echo "${ERROR} Falló zsh-autosuggestions." | tee -a "$LOG"

    echo "${INFO} Instalando ${SKY_BLUE}zsh-syntax-highlighting${RESET}..." | tee -a "$LOG"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting \
        "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" &>> "$LOG" \
        && echo "${OK} zsh-syntax-highlighting instalado." | tee -a "$LOG" \
        || echo "${ERROR} Falló zsh-syntax-highlighting." | tee -a "$LOG"

    echo "${INFO} Instalando ${SKY_BLUE}zsh-history-substring-search${RESET}..." | tee -a "$LOG"
    git clone https://github.com/zsh-users/zsh-history-substring-search \
        "$ZSH_CUSTOM/plugins/zsh-history-substring-search" &>> "$LOG" \
        && echo "${OK} zsh-history-substring-search instalado." | tee -a "$LOG" \
        || echo "${ERROR} Falló zsh-history-substring-search." | tee -a "$LOG"
}

# ─── Cambiar shell por defecto ───────────────────────────────────────────────
set_default_shell() {
    echo "${INFO} Cambiando shell por defecto a ${SKY_BLUE}zsh${RESET}..." | tee -a "$LOG"
    chsh -s "$(which zsh)" &>> "$LOG" \
        && echo "${OK} Shell cambiado a zsh." | tee -a "$LOG" \
        || echo "${ERROR} Falló cambiar shell." | tee -a "$LOG"
}

install_ohmyzsh
install_p10k
install_plugins
set_default_shell

echo "${OK} zsh configurado completamente." | tee -a "$LOG"
