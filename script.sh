#!/bin/bash

echo "===================================================="
echo "   Iniciando Despliegue Automatizado desde GitHub   "
echo "===================================================="

# 1. El script te pide la llave de forma interactiva y segura
read -p "Por favor, ingresa tu API Key de OpenWeather: " llave_ingresada
export API_KEY_PROYECTO="$llave_ingresada"

# 2. Limpieza de pruebas anteriores
echo -e "\n[-] Limpiando entorno..."
rm -rf ea2-valdebenito
docker rm -f clima-ejecucion 2>/dev/null || true

# 3. Descarga del código fuente (Lo mismo que hará Jenkins)
echo "[+] Clonando repositorio oficial..."
git clone https://github.com/PiMienTHD/ea2-valdebenito.git

# 4. Ejecución del script de construcción interno
echo "[+] Construyendo infraestructura con Docker..."
cd ea2-valdebenito
chmod +x build.sh
./build.sh
