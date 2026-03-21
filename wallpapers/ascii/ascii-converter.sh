#!/bin/bash
IMG_DIR="$HOME/Imagenes/ascii"
ASCII_DIR="$HOME/.config/fastfetch/ascii"
WIDTH=35

echo "🐉 Fastfetch ASCII Converter"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ ! -d "$IMG_DIR" ]; then
    echo "❌ No se encontró $IMG_DIR"
    exit 1
fi

if [ ! -d "$ASCII_DIR" ]; then
    mkdir -p "$ASCII_DIR"
    echo "📁 Creado $ASCII_DIR"
fi

counter=1
while IFS= read -r -d '' img; do
    filename=$(basename "$img")
    ext="${filename##*.}"
    if [[ ! "$filename" =~ ^art[0-9]+\.(jpg|jpeg|png)$ ]]; then
        while [ -f "$IMG_DIR/art${counter}.jpg" ] || \
              [ -f "$IMG_DIR/art${counter}.jpeg" ] || \
              [ -f "$IMG_DIR/art${counter}.png" ]; do
            ((counter++))
        done
        newname="art${counter}.${ext}"
        mv "$img" "$IMG_DIR/$newname"
        echo "✏️  Renombrado: $filename → $newname"
        ((counter++))
    fi
done < <(find "$IMG_DIR" -maxdepth 1 -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \) -print0)

converted=0
skipped=0

while IFS= read -r -d '' img; do
    filename=$(basename "$img")
    artname="${filename%.*}"
    txt_file="$ASCII_DIR/${artname}.txt"

    if [ -f "$txt_file" ]; then
        echo "⏭️  Ya existe: ${artname}.txt — saltando"
        ((skipped++))
    else
        echo "⚙️  Convirtiendo: $filename → ${artname}.txt"
        ascii-image-converter "$img" -W $WIDTH --braille -C > "$txt_file"
        if [ $? -eq 0 ]; then
            echo "✅ Listo: ${artname}.txt"
            ((converted++))
        else
            echo "❌ Error al convertir: $filename"
            rm -f "$txt_file"
        fi
    fi
done < <(find "$IMG_DIR" -maxdepth 1 -type f \( -name "art*.jpg" -o -name "art*.jpeg" -o -name "art*.png" \) -print0)

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Convertidas: $converted"
echo "⏭️  Saltadas:   $skipped"
echo "🐉 Listo"
