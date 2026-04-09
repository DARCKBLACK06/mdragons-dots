#!/bin/bash
# Verificación final de instalación - mdragons-dots

LOG="Install-Logs/final-check-$(date +%d-%H%M%S).log"

OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"
WARN="$(tput setaf 1)[WARN]$(tput sgr0)"
RESET="$(tput sgr0)"
SKY_BLUE="$(tput setaf 6)"
GREEN="$(tput setaf 2)"
RED="$(tput setaf 1)"

passed=0
failed=0

# ─── Función de verificación ─────────────────────────────────────────────────
check_cmd() {
    local name="$1"
    local cmd="$2"
    if command -v "$cmd" &>/dev/null; then
        echo "${OK} $name encontrado: $(which $cmd)" | tee -a "$LOG"
        ((passed++))
    else
        echo "${ERROR} $name NO encontrado." | tee -a "$LOG"
        ((failed++))
    fi
}

check_pkg() {
    local name="$1"
    if rpm -q "$name" &>/dev/null; then
        echo "${OK} $name instalado." | tee -a "$LOG"
        ((passed++))
    else
        echo "${ERROR} $name NO instalado." | tee -a "$LOG"
        ((failed++))
    fi
}

check_file() {
    local name="$1"
    local path="$2"
    if [ -e "$path" ]; then
        echo "${OK} $name encontrado: $path" | tee -a "$LOG"
        ((passed++))
    else
        echo "${ERROR} $name NO encontrado: $path" | tee -a "$LOG"
        ((failed++))
    fi
}

check_link() {
    local name="$1"
    local path="$2"
    if [ -L "$path" ]; then
        echo "${OK} symlink $name -> $(readlink $path)" | tee -a "$LOG"
        ((passed++))
    else
        echo "${ERROR} symlink $name NO existe: $path" | tee -a "$LOG"
        ((failed++))
    fi
}

# ─── WM ──────────────────────────────────────────────────────────────────────
echo "${INFO} Verificando ${SKY_BLUE}WM${RESET}..." | tee -a "$LOG"
check_cmd "i3"          "i3"
check_cmd "polybar"     "polybar"
check_cmd "picom"       "picom"
check_cmd "rofi"        "rofi"
check_cmd "dunst"       "dunst"
check_cmd "feh"         "feh"
check_cmd "hyprland"    "Hyprland"
check_cmd "waybar"      "waybar"

# ─── Audio/Video ─────────────────────────────────────────────────────────────
echo "${INFO} Verificando ${SKY_BLUE}Audio/Video${RESET}..." | tee -a "$LOG"
check_cmd "playerctl"       "playerctl"
check_cmd "pavucontrol"     "pavucontrol"
check_cmd "easyeffects"     "easyeffects"
check_cmd "mpv"             "mpv"
check_cmd "vlc"             "vlc"
check_cmd "cava"            "cava"
check_cmd "glava"           "glava"

# ─── Herramientas ────────────────────────────────────────────────────────────
echo "${INFO} Verificando ${SKY_BLUE}Herramientas${RESET}..." | tee -a "$LOG"
check_cmd "btop"                "btop"
check_cmd "neovim"              "nvim"
check_cmd "kitty"               "kitty"
check_cmd "zsh"                 "zsh"
check_cmd "wal"                 "wal"
check_cmd "betterlockscreen"    "betterlockscreen"
check_cmd "brightnessctl"       "brightnessctl"
check_cmd "asusctl"             "asusctl"

# ─── Symlinks ────────────────────────────────────────────────────────────────
echo "${INFO} Verificando ${SKY_BLUE}symlinks${RESET}..." | tee -a "$LOG"
check_link "i3"         "$HOME/.config/i3"
check_link "polybar"    "$HOME/.config/polybar"
check_link "hypr"       "$HOME/.config/hypr"
check_link "waybar"     "$HOME/.config/waybar"
check_link "kitty"      "$HOME/.config/kitty"
check_link "rofi"       "$HOME/.config/rofi"
check_link "dunst"      "$HOME/.config/dunst"
check_link "cava"       "$HOME/.config/cava"
check_link "glava"      "$HOME/.config/glava"
check_link "wal"        "$HOME/.config/wal"
check_link ".zshrc"     "$HOME/.zshrc"
check_link ".vimrc"     "$HOME/.vimrc"

# ─── Archivos importantes ─────────────────────────────────────────────────────
echo "${INFO} Verificando ${SKY_BLUE}archivos importantes${RESET}..." | tee -a "$LOG"
check_file "pywal colors"       "$HOME/.cache/wal/colors.sh"
check_file "pywal colors-cava"  "$HOME/.cache/wal/colors-cava"
check_file "pywal colors-glava" "$HOME/.cache/wal/colors-glava"
check_file "wallpaper"          "$HOME/Imágenes/wallpaper/wallpaper2.png"

# ─── Resumen ─────────────────────────────────────────────────────────────────
echo "" | tee -a "$LOG"
echo "─────────────────────────────────────────" | tee -a "$LOG"
echo "${GREEN}Passed: $passed${RESET}" | tee -a "$LOG"
echo "${RED}Failed: $failed${RESET}" | tee -a "$LOG"
echo "─────────────────────────────────────────" | tee -a "$LOG"

if [ "$failed" -eq 0 ]; then
    echo "${OK} Todo instalado correctamente." | tee -a "$LOG"
else
    echo "${WARN} $failed componentes fallaron. Revisa el log: $LOG" | tee -a "$LOG"
fi
