#!/bin/bash

echo "======================================================="
echo " Iniciando Prueba Local (Simulación de Jenkins)"
echo "======================================================="

# Solicita credenciales y parámetros de forma segura
echo -n "🔑 Pega tu API Key de OpenWeather (invisible por seguridad): "
read -s llave_ingresada
echo ""
export API_KEY_PROYECTO="$llave_ingresada"

echo -n "🌍 Ingresa la ciudad a consultar (Ej: Paris, Tokyo): "
read ciudad_ingresada
export CIUDAD="$ciudad_ingresada"

# Simula la descarga
echo -e "\n[-] Limpiando entorno..."
cd ~
rm -rf ea2-valdebenito 2>/dev/null || true
echo "[+] Clonando repositorio oficial..."
git clone https://github.com/PiMienTHD/ea2-valdebenito.git
cd ea2-valdebenito

# Ejecuta el script oficial
chmod +x build.sh
./build.sh
