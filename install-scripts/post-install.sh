#!/bin/bash
# Post instalación - pywal, betterlockscreen, easyeffects - mdragons-dots

LOG="Install-Logs/post-install-$(date +%d-%H%M%S).log"

OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"
RESET="$(tput sgr0)"
SKY_BLUE="$(tput setaf 6)"

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
WALLPAPER="$HOME/Imágenes/wallpaper/wallpaper2.png"

# ─── Pywal16 ─────────────────────────────────────────────────────────────────
install_pywal() {
    echo "${INFO} Instalando ${SKY_BLUE}pywal16${RESET}..." | tee -a "$LOG"
    pip install --user pywal16 &>> "$LOG" \
        && echo "${OK} pywal16 instalado." | tee -a "$LOG" \
        || echo "${ERROR} Falló pywal16." | tee -a "$LOG"
}

# ─── Generar colores iniciales pywal ─────────────────────────────────────────
setup_pywal() {
    echo "${INFO} Generando colores iniciales con ${SKY_BLUE}pywal${RESET}..." | tee -a "$LOG"
    if [ -f "$WALLPAPER" ]; then
        ~/.local/bin/wal -i "$WALLPAPER" -n -q &>> "$LOG" \
            && echo "${OK} Colores generados." | tee -a "$LOG" \
            || echo "${ERROR} Falló generar colores." | tee -a "$LOG"
    else
        echo "${ERROR} No se encontró wallpaper en $WALLPAPER" | tee -a "$LOG"
        echo "${INFO} Copia un wallpaper a ~/Imágenes/wallpaper/ y corre: wal -i <wallpaper>" | tee -a "$LOG"
    fi
}

# ─── Betterlockscreen ────────────────────────────────────────────────────────
setup_betterlockscreen() {
    echo "${INFO} Configurando ${SKY_BLUE}betterlockscreen${RESET}..." | tee -a "$LOG"
    if [ -f "$WALLPAPER" ]; then
        betterlockscreen -u "$WALLPAPER" &>> "$LOG" \
            && echo "${OK} betterlockscreen configurado." | tee -a "$LOG" \
            || echo "${ERROR} Falló betterlockscreen." | tee -a "$LOG"
    else
        echo "${ERROR} No se encontró wallpaper para betterlockscreen." | tee -a "$LOG"
    fi
}

# ─── EasyEffects presets ─────────────────────────────────────────────────────
setup_easyeffects() {
    echo "${INFO} Instalando presets de ${SKY_BLUE}EasyEffects${RESET}..." | tee -a "$LOG"
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/JackHack96/EasyEffects-Presets/master/install.sh)" &>> "$LOG" \
        && echo "${OK} Presets de EasyEffects instalados." | tee -a "$LOG" \
        || echo "${ERROR} Falló instalar presets EasyEffects." | tee -a "$LOG"
}

# ─── Sudoers para glava ──────────────────────────────────────────────────────
setup_sudoers_glava() {
    echo "${INFO} Configurando ${SKY_BLUE}sudoers para glava${RESET}..." | tee -a "$LOG"
    echo "$(whoami) ALL=(ALL) NOPASSWD: /usr/bin/sed" | sudo tee /etc/sudoers.d/glava-color &>> "$LOG" \
        && echo "${OK} Sudoers glava configurado." | tee -a "$LOG" \
        || echo "${ERROR} Falló configurar sudoers glava." | tee -a "$LOG"
}

install_pywal
setup_pywal
setup_betterlockscreen
setup_easyeffects
setup_sudoers_glava

echo "${OK} Post instalación completada." | tee -a "$LOG"
