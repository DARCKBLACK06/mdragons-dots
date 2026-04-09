#!/bin/bash
# mdragons-dots - Install Script
# https://github.com/DARCKBLACK06/mdragons-dots

clear

# ─── Colores ─────────────────────────────────────────────────────────────────
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTA]$(tput sgr0)"
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"
WARN="$(tput setaf 1)[AVISO]$(tput sgr0)"
CAT="$(tput setaf 6)[ACCIÓN]$(tput sgr0)"
MAGENTA="$(tput setaf 5)"
YELLOW="$(tput setaf 3)"
GREEN="$(tput setaf 2)"
BLUE="$(tput setaf 4)"
SKY_BLUE="$(tput setaf 6)"
RESET="$(tput sgr0)"

# ─── Logs ────────────────────────────────────────────────────────────────────
if [ ! -d Install-Logs ]; then
    mkdir Install-Logs
fi
LOG="Install-Logs/install-$(date +%d-%H%M%S).log"

# ─── No ejecutar como root ───────────────────────────────────────────────────
if [[ $EUID -eq 0 ]]; then
    echo "${ERROR} Este script ${WARN}NO${RESET} debe ejecutarse como root. Saliendo..." | tee -a "$LOG"
    exit 1
f
i
# Cachear credenciales sudo
echo "${INFO} Se requieren permisos de administrador..." | tee -a "$LOG"
sudo -v
# Mantener sudo activo durante toda la instalación
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


# ─── Instalar whiptail si no existe ──────────────────────────────────────────
if ! command -v whiptail >/dev/null; then
    echo "${NOTE} whiptail no está instalado. Instalando..." | tee -a "$LOG"
    sudo dnf install -y newt
fi

# ─── Instalar pciutils si no existe ──────────────────────────────────────────
if ! rpm -q pciutils > /dev/null; then
    echo "${NOTE} pciutils no está instalado. Instalando..." | tee -a "$LOG"
    sudo dnf install -y pciutils
fi

clear

# ─── ASCII Art ───────────────────────────────────────────────────────────────
printf "\n"
echo -e "\e[35m"
echo '██████╗  █████╗ ██████╗  ██████╗██╗  ██╗██████╗ ██╗      █████╗  ██████╗██╗  ██╗'
echo '██╔══██╗██╔══██╗██╔══██╗██╔════╝██║ ██╔╝██╔══██╗██║     ██╔══██╗██╔════╝██║ ██╔╝'
echo '██║  ██║███████║██████╔╝██║     █████╔╝ ██████╔╝██║     ███████║██║     █████╔╝ '
echo '██║  ██║██╔══██║██╔══██╗██║     ██╔═██╗ ██╔══██╗██║     ██╔══██║██║     ██╔═██╗ '
echo '██████╔╝██║  ██║██║  ██║╚██████╗██║  ██╗██████╔╝███████╗██║  ██║╚██████╗██║  ██╗'
echo '╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═════╝ ╚══════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝'
echo -e "\e[0m"
echo -e "                    ${SKY_BLUE}mdragons-dots${RESET} — ${MAGENTA}Fedora Linux${RESET} — ${YELLOW}i3 & Hyprland${RESET}"
printf "\n"

# ─── Bienvenida ──────────────────────────────────────────────────────────────
whiptail --title "mdragons-dots - Script de Instalación" \
    --msgbox "¡Bienvenido al script de instalación de mdragons-dots!\n\n\
ATENCIÓN: Se recomienda hacer una actualización completa del sistema y reiniciar antes de continuar.\n\n\
Este script instalará paquetes, configuraciones y dotfiles para i3 y/o Hyprland en Fedora." \
    15 80

# ─── Confirmar inicio ────────────────────────────────────────────────────────
if ! whiptail --title "¿Continuar?" \
    --yesno "¿Deseas continuar con la instalación?" 7 50; then
    echo "${INFO} Instalación cancelada por el usuario." | tee -a "$LOG"
    exit 1
fi

# ─── Script directory ────────────────────────────────────────────────────────
script_directory=install-scripts

execute_script() {
    local script="$1"
    local script_path="$script_directory/$script"
    if [ -f "$script_path" ]; then
        chmod +x "$script_path"
        if [ -x "$script_path" ]; then
            env "$script_path"
        else
            echo "${ERROR} No se pudo hacer ejecutable '$script'." | tee -a "$LOG"
        fi
    else
        echo "${ERROR} Script '$script' no encontrado en '$script_directory'." | tee -a "$LOG"
    fi
}

# ─── Detectar NVIDIA ─────────────────────────────────────────────────────────
nvidia_detected=false
if lspci | grep -i "nvidia" &>/dev/null; then
    nvidia_detected=true
    whiptail --title "GPU NVIDIA Detectada" \
        --msgbox "Se detectó una GPU NVIDIA en tu sistema.\n\nEl script puede instalar y configurar los drivers automáticamente si lo deseas." \
        12 60
fi

# ─── Opciones ────────────────────────────────────────────────────────────────
options_command=(
    whiptail --title "Selecciona opciones" \
    --checklist "Elige qué instalar o configurar\nUSA 'ESPACIO' para seleccionar y 'TAB' para cambiar selección" \
    28 85 20
)

# NVIDIA
if [ "$nvidia_detected" == "true" ]; then
    options_command+=(
        "nvidia"    "¿Instalar y configurar drivers NVIDIA?"          "OFF"
    )
fi

# Opciones principales
options_command+=(
    "base"      "Instalar paquetes base (audio, herramientas, ASUS, red)"   "ON"
    "i3"        "Instalar paquetes y configuración de i3wm"                 "OFF"
    "hyprland"  "Instalar paquetes y configuración de Hyprland"             "OFF"
    "flatpak"   "Instalar Flatpaks (gaming launchers)"                      "OFF"
    "compile"   "Compilar betterlockscreen desde fuente"                    "OFF"
    "zsh"       "Instalar zsh + Oh-My-Zsh + Powerlevel10k"                  "OFF"
    "fonts"     "Instalar fuentes y Candy Icons"                            "OFF"
    "dotfiles"  "Crear symlinks de dotfiles a ~/.config"                    "OFF"
    "post"      "Post instalación (pywal, betterlockscreen, easyeffects)"   "OFF"
)

# ─── Loop de selección ───────────────────────────────────────────────────────
while true; do
    selected_options=$("${options_command[@]}" 3>&1 1>&2 2>&3)

    if [ $? -ne 0 ]; then
        echo "${INFO} Instalación cancelada." | tee -a "$LOG"
        exit 0
    fi

    if [ -z "$selected_options" ]; then
        whiptail --title "Aviso" \
            --msgbox "No seleccionaste ninguna opción. Selecciona al menos una." 10 60
        continue
    fi

    selected_options=$(echo "$selected_options" | tr -d '"' | tr -s ' ')

    # Confirmación
    confirm_message="Seleccionaste las siguientes opciones:\n\n"
    for option in $selected_options; do
        confirm_message+=" - $option\n"
    done
    confirm_message+="\n¿Confirmas tu selección?"

    if ! whiptail --title "Confirmar selección" \
        --yesno "$(printf "%s" "$confirm_message")" 25 80; then
        echo "${INFO} Regresando a opciones..." | tee -a "$LOG"
        continue
    fi

    break
done

# ─── Ejecutar scripts según selección ────────────────────────────────────────
echo "${INFO} Agregando COPRs necesarios..." | tee -a "$LOG"
execute_script "copr.sh"

IFS=' ' read -r -a options <<< "$selected_options"
for option in "${options[@]}"; do
    case "$option" in
        base)
            echo "${INFO} Instalando ${SKY_BLUE}paquetes base${RESET}..." | tee -a "$LOG"
            execute_script "packages.sh"
            ;;
        i3)
            echo "${INFO} Instalando ${SKY_BLUE}i3wm${RESET}..." | tee -a "$LOG"
            execute_script "i3-packages.sh"
            ;;
        hyprland)
            echo "${INFO} Instalando ${SKY_BLUE}Hyprland${RESET}..." | tee -a "$LOG"
            execute_script "hypr-packages.sh"
            ;;
        flatpak)
            echo "${INFO} Instalando ${SKY_BLUE}Flatpaks${RESET}..." | tee -a "$LOG"
            execute_script "flatpak.sh"
            ;;
        nvidia)
            echo "${INFO} Configurando ${SKY_BLUE}NVIDIA${RESET}..." | tee -a "$LOG"
            execute_script "nvidia.sh"
            ;;
        compile)
            echo "${INFO} Compilando ${SKY_BLUE}betterlockscreen${RESET}..." | tee -a "$LOG"
            execute_script "compile.sh"
            ;;
        zsh)
            echo "${INFO} Instalando ${SKY_BLUE}zsh${RESET}..." | tee -a "$LOG"
            execute_script "zsh.sh"
            ;;
        fonts)
            echo "${INFO} Instalando ${SKY_BLUE}fuentes e iconos${RESET}..." | tee -a "$LOG"
            execute_script "fonts.sh"
            ;;
        dotfiles)
            echo "${INFO} Creando ${SKY_BLUE}symlinks dotfiles${RESET}..." | tee -a "$LOG"
            execute_script "dotfiles.sh"
            ;;
        post)
            echo "${INFO} Ejecutando ${SKY_BLUE}post instalación${RESET}..." | tee -a "$LOG"
            execute_script "post-install.sh"
            ;;
        *)
            echo "${WARN} Opción desconocida: $option" | tee -a "$LOG"
            ;;
    esac
done

# ─── Verificación final ───────────────────────────────────────────────────────
echo "${INFO} Ejecutando verificación final..." | tee -a "$LOG"
execute_script "final-check.sh"

clear

# ─── Mensaje final ───────────────────────────────────────────────────────────
printf "\n"
echo -e "\e[35m"
echo '██████╗  █████╗ ██████╗  ██████╗██╗  ██╗██████╗ ██╗      █████╗  ██████╗██╗  ██╗'
echo '██╔══██╗██╔══██╗██╔══██╗██╔════╝██║ ██╔╝██╔══██╗██║     ██╔══██╗██╔════╝██║ ██╔╝'
echo '██║  ██║███████║██████╔╝██║     █████╔╝ ██████╔╝██║     ███████║██║     █████╔╝ '
echo '██║  ██║██╔══██║██╔══██╗██║     ██╔═██╗ ██╔══██╗██║     ██╔══██║██║     ██╔═██╗ '
echo '██████╔╝██║  ██║██║  ██║╚██████╗██║  ██╗██████╔╝███████╗██║  ██║╚██████╗██║  ██╗'
echo '╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═════╝ ╚══════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝'
echo -e "\e[0m"
printf "\n"
echo "${OK} ${SKY_BLUE}¡Instalación completada!${RESET} Revisa los logs en ${YELLOW}Install-Logs/${RESET}"
printf "\n"

# ─── Reboot ──────────────────────────────────────────────────────────────────
while true; do
    echo -n "${CAT} ¿Deseas reiniciar ahora? (s/n): "
    read respuesta
    respuesta=$(echo "$respuesta" | tr '[:upper:]' '[:lower:]')
    if [[ "$respuesta" == "s" || "$respuesta" == "si" ]]; then
        echo "${INFO} Reiniciando..." | tee -a "$LOG"
        systemctl reboot
        break
    elif [[ "$respuesta" == "n" || "$respuesta" == "no" ]]; then
        echo "${OK} Puedes reiniciar manualmente cuando gustes."
        if lspci | grep -i "nvidia" &>/dev/null; then
            echo "${WARN} Tienes GPU NVIDIA — se recomienda reiniciar para cargar los drivers."
        fi
        break
    else
        echo "${WARN} Respuesta inválida. Usa 's' o 'n'."
    fi
done

printf "\n"
