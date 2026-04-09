#!/bin/bash
# Drivers NVIDIA para mdragons-dots
# RTX 3050 Laptop (GA107BM) - Fedora

LOG="Install-Logs/nvidia-$(date +%d-%H%M%S).log"

OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"
WARN="$(tput setaf 1)[WARN]$(tput sgr0)"
RESET="$(tput sgr0)"
SKY_BLUE="$(tput setaf 6)"

# Verificar que no se ejecute como root
if [[ $EUID -eq 0 ]]; then
    echo "${ERROR} No ejecutes este script como root." | tee -a "$LOG"
    exit 1
fi

# Verificar que haya GPU NVIDIA
if ! lspci | grep -i nvidia &>/dev/null; then
    echo "${WARN} No se detectó GPU NVIDIA. Saltando..." | tee -a "$LOG"
    exit 0
fi

echo "${INFO} GPU NVIDIA detectada: $(lspci | grep -i nvidia | head -1)" | tee -a "$LOG"

# Habilitar RPM Fusion
echo "${INFO} Habilitando ${SKY_BLUE}RPM Fusion${RESET}..." | tee -a "$LOG"
sudo dnf install -y \
    "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
    "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm" \
    &>> "$LOG" && echo "${OK} RPM Fusion habilitado." | tee -a "$LOG"

# Instalar drivers
echo "${INFO} Instalando ${SKY_BLUE}drivers NVIDIA${RESET}..." | tee -a "$LOG"
sudo dnf install -y \
    akmod-nvidia \
    xorg-x11-drv-nvidia \
    xorg-x11-drv-nvidia-cuda \
    xorg-x11-drv-nvidia-cuda-libs \
    xorg-x11-drv-nvidia-libs \
    xorg-x11-drv-nvidia-power \
    xorg-x11-drv-nvidia-xorg-libs \
    nvidia-modprobe \
    nvidia-persistenced \
    nvidia-settings \
    libva-nvidia-driver \
    &>> "$LOG" && echo "${OK} Drivers NVIDIA instalados." | tee -a "$LOG"

# Configurar para gaming (fix juegos)
echo "${INFO} Configurando ${SKY_BLUE}NVIDIA para gaming${RESET}..." | tee -a "$LOG"
sudo systemctl enable nvidia-persistenced &>> "$LOG"

# Blacklist nouveau
echo "${INFO} Deshabilitando ${SKY_BLUE}nouveau${RESET}..." | tee -a "$LOG"
echo "blacklist nouveau" | sudo tee /etc/modprobe.d/blacklist-nouveau.conf &>> "$LOG"
sudo dracut --force &>> "$LOG" && echo "${OK} nouveau deshabilitado." | tee -a "$LOG"

echo "${WARN} Recuerda reiniciar para que los drivers carguen correctamente." | tee -a "$LOG"
echo "${OK} NVIDIA configurado correctamente." | tee -a "$LOG"
