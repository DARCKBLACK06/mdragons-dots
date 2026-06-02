#!/usr/bin/env bash
# ============================================================
#  install_realesrgan.sh
#  Instalación automática de Real-ESRGAN en Fedora
#  Usuario: darckblack@mdragons
#  Probado: Fedora 44 · RTX 3050 6GB · Miniconda3 · CUDA 12.4
# ============================================================

set -e  # Detener si cualquier comando falla

# ── Colores ─────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log()  { echo -e "${CYAN}[INFO]${NC}  $1"; }
ok()   { echo -e "${GREEN}[OK]${NC}    $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC}  $1"; }
err()  { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# ── Variables ────────────────────────────────────────────────
MINICONDA_DIR="$HOME/miniconda3"
MINICONDA_INSTALLER="$MINICONDA_DIR/Miniconda3-latest-Linux-x86_64.sh"
MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
ENV_NAME="realesrgan"
REALESRGAN_DIR="$HOME/Real-ESRGAN"

echo ""
echo -e "${CYAN}╔══════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║     Real-ESRGAN · Auto Installer         ║${NC}"
echo -e "${CYAN}║     darckblack@mdragons                  ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════╝${NC}"
echo ""

# ────────────────────────────────────────────────────────────
# FASE 1 — Miniconda
# ────────────────────────────────────────────────────────────
log "FASE 1 · Miniconda3"

if [ -d "$MINICONDA_DIR" ]; then
    ok "Miniconda ya instalado en $MINICONDA_DIR — saltando"
else
    log "Descargando Miniconda3..."
    wget -q --show-progress "$MINICONDA_URL" -O "/tmp/miniconda_installer.sh"
    bash /tmp/miniconda_installer.sh -b -p "$MINICONDA_DIR"
    rm /tmp/miniconda_installer.sh
    ok "Miniconda instalado"
fi

# Activar conda en esta sesión
source "$MINICONDA_DIR/etc/profile.d/conda.sh"

# ────────────────────────────────────────────────────────────
# FASE 2 — Entorno conda
# ────────────────────────────────────────────────────────────
log "FASE 2 · Entorno conda '$ENV_NAME' con Python 3.9"

if conda env list | grep -q "^$ENV_NAME "; then
    warn "El entorno '$ENV_NAME' ya existe — eliminando para reinstalar limpio"
    conda env remove -n "$ENV_NAME" -y
fi

conda create -n "$ENV_NAME" python=3.9 -y
ok "Entorno creado"

conda activate "$ENV_NAME"

# ────────────────────────────────────────────────────────────
# FASE 3 — PyTorch con CUDA
# ────────────────────────────────────────────────────────────
log "FASE 3 · PyTorch + CUDA 12.4"

conda install pytorch torchvision torchaudio pytorch-cuda=12.4 \
    -c pytorch -c nvidia -y

# Verificar CUDA
CUDA_OK=$(python -c "import torch; print(torch.cuda.is_available())")
if [ "$CUDA_OK" = "True" ]; then
    ok "CUDA detectada correctamente"
else
    err "CUDA no detectada. Revisa drivers de NVIDIA antes de continuar."
fi

# ────────────────────────────────────────────────────────────
# FASE 4 — Reparar pip (incompatibilidad Python 3.9)
# ────────────────────────────────────────────────────────────
log "FASE 4 · Reparar pip para Python 3.9"

conda install pip=23.3 -y
ok "pip reparado"

# ────────────────────────────────────────────────────────────
# FASE 5 — Clonar Real-ESRGAN
# ────────────────────────────────────────────────────────────
log "FASE 5 · Clonar Real-ESRGAN"

if [ -d "$REALESRGAN_DIR" ]; then
    warn "Directorio $REALESRGAN_DIR ya existe — eliminando"
    rm -rf "$REALESRGAN_DIR"
fi

git clone https://github.com/xinntao/Real-ESRGAN.git "$REALESRGAN_DIR"
cd "$REALESRGAN_DIR"
ok "Repositorio clonado"

# ────────────────────────────────────────────────────────────
# FASE 6 — Dependencias
# ────────────────────────────────────────────────────────────
log "FASE 6 · Instalando dependencias"

pip install basicsr facexlib gfpgan
pip install -r requirements.txt
python setup.py develop
ok "Dependencias instaladas"

# ────────────────────────────────────────────────────────────
# FASE 7 — Fix basicsr (functional_tensor)
# ────────────────────────────────────────────────────────────
log "FASE 7 · Parche basicsr (torchvision compatibility)"

DEGRADATIONS="$MINICONDA_DIR/envs/$ENV_NAME/lib/python3.9/site-packages/basicsr/data/degradations.py"

if grep -q "functional_tensor" "$DEGRADATIONS"; then
    sed -i 's/from torchvision.transforms.functional_tensor import rgb_to_grayscale/from torchvision.transforms.functional import rgb_to_grayscale/' \
        "$DEGRADATIONS"
    ok "Parche aplicado"
else
    ok "Parche no necesario (ya estaba corregido)"
fi

# ────────────────────────────────────────────────────────────
# FASE 8 — Descargar modelos
# ────────────────────────────────────────────────────────────
log "FASE 8 · Descargando modelos"

mkdir -p "$REALESRGAN_DIR/weights"

# Modelo general
if [ ! -f "$REALESRGAN_DIR/weights/RealESRGAN_x4plus.pth" ]; then
    log "Descargando RealESRGAN_x4plus (fotos reales)..."
    wget -q --show-progress \
        https://github.com/xinntao/Real-ESRGAN/releases/download/v0.1.0/RealESRGAN_x4plus.pth \
        -P "$REALESRGAN_DIR/weights"
    ok "RealESRGAN_x4plus.pth descargado"
else
    ok "RealESRGAN_x4plus.pth ya existe"
fi

# Modelo anime (el que usas)
if [ ! -f "$REALESRGAN_DIR/weights/RealESRGAN_x4plus_anime_6B.pth" ]; then
    log "Descargando RealESRGAN_x4plus_anime_6B (anime/ilustraciones)..."
    wget -q --show-progress \
        https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.2.4/RealESRGAN_x4plus_anime_6B.pth \
        -P "$REALESRGAN_DIR/weights"
    ok "RealESRGAN_x4plus_anime_6B.pth descargado"
else
    ok "RealESRGAN_x4plus_anime_6B.pth ya existe"
fi

# ────────────────────────────────────────────────────────────
# LISTO
# ────────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   Instalación completa ✓                 ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════╝${NC}"
echo ""
echo -e "Para usar Real-ESRGAN:"
echo -e "  ${CYAN}conda activate $ENV_NAME${NC}"
echo -e "  ${CYAN}cd ~/Real-ESRGAN${NC}"
echo ""
echo -e "Comando para anime/autos (tu caso):"
echo -e "  ${CYAN}PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True \\"
echo -e "  python inference_realesrgan.py -n RealESRGAN_x4plus_anime_6B \\"
echo -e "  -i inputs --outscale 4 --fp32 --tile 256${NC}"
echo ""
