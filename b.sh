#!/bin/bash
set -euo pipefail

# Carpeta destino
rootdir="/workspaces/a/xmrig"

echo "=== Instalando dependencias necesarias ==="
sudo apt-get update
sudo apt-get install -y git build-essential cmake libuv1-dev libssl-dev libhwloc-dev

echo "=== Clonando repositorio oficial de XMRig ==="
# Si la carpeta existe pero está vacía o corrupta, la borramos
if [ -d "$rootdir" ]; then
    if [ ! -f "$rootdir/CMakeLists.txt" ]; then
        echo "Carpeta existente sin CMakeLists.txt, eliminando..."
        rm -rf "$rootdir"
        git clone https://github.com/xmrig/xmrig.git "$rootdir"
    else
        echo "Repositorio válido, actualizando..."
        cd "$rootdir"
        git pull
    fi
else
    git clone https://github.com/xmrig/xmrig.git "$rootdir"
fi

echo "=== Compilando XMRig ==="
cd "$rootdir"
mkdir -p build
cd build
cmake ..
make -j$(nproc)

echo "=== Instalación finalizada ==="
"$rootdir/build/xmrig" -V
echo "Binario disponible en: $rootdir/build/xmrig"
