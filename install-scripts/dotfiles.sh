#!/bin/bash
# Crear symlinks de dotfiles - mdragons-dots

LOG="Install-Logs/dotfiles-$(date +%d-%H%M%S).log"

OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"
WARN="$(tput setaf 1)[WARN]$(tput sgr0)"
RESET="$(tput sgr0)"
SKY_BLUE="$(tput setaf 6)"

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"

# ─── Función symlink ─────────────────────────────────────────────────────────
make_link() {
    local src="$1"
    local dst="$2"

    # Si ya existe como symlink lo elimina y recrea
    if [ -L "$dst" ]; then
        rm "$dst"
    # Si existe como archivo/carpeta real lo respalda
    elif [ -e "$dst" ]; then
        echo "${WARN} Respaldando $dst -> ${dst}.bak" | tee -a "$LOG"
        mv "$dst" "${dst}.bak"
    fi

    mkdir -p "$(dirname "$dst")"
    ln -sf "$src" "$dst" \
        && echo "${OK} $dst -> $src" | tee -a "$LOG" \
        || echo "${ERROR} Falló symlink $dst" | tee -a "$LOG"
}

# ─── ~/.config ───────────────────────────────────────────────────────────────
echo "${INFO} Creando symlinks en ${SKY_BLUE}~/.config${RESET}..." | tee -a "$LOG"

make_link "$REPO_DIR/config/i3"         "$HOME/.config/i3"
make_link "$REPO_DIR/config/hypr"       "$HOME/.config/hypr"
make_link "$REPO_DIR/config/waybar"     "$HOME/.config/waybar"
make_link "$REPO_DIR/config/kitty"      "$HOME/.config/kitty"
make_link "$REPO_DIR/config/rofi"       "$HOME/.config/rofi"
make_link "$REPO_DIR/config/dunst"      "$HOME/.config/dunst"
make_link "$REPO_DIR/config/picom"      "$HOME/.config/picom"
make_link "$REPO_DIR/config/cava"       "$HOME/.config/cava"
make_link "$REPO_DIR/config/glava"      "$HOME/.config/glava"
make_link "$REPO_DIR/config/wal"        "$HOME/.config/wal"
make_link "$REPO_DIR/config/btop"       "$HOME/.config/btop"
make_link "$REPO_DIR/config/fastfetch"  "$HOME/.config/fastfetch"
make_link "$REPO_DIR/config/MangoHud"   "$HOME/.config/MangoHud"
make_link "$REPO_DIR/config/mpv"        "$HOME/.config/mpv"
make_link "$REPO_DIR/config/conky"      "$HOME/.config/conky"

# ─── Home ────────────────────────────────────────────────────────────────────
echo "${INFO} Creando symlinks en ${SKY_BLUE}~/${RESET}..." | tee -a "$LOG"

make_link "$REPO_DIR/home/.zshrc"   "$HOME/.zshrc"
make_link "$REPO_DIR/home/.vimrc"   "$HOME/.vimrc"

echo "${OK} Todos los symlinks creados." | tee -a "$LOG"
