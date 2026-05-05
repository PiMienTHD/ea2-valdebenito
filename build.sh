#!/bin/bash

# ==============================================================================
# SCRIPT BUILD.SH (Automatización Total CI/CD)
# ==============================================================================

echo "======================================================="
echo " Construcción Automatizada del Asistente Climático"
echo "======================================================="

# 1. Solicita las variables de forma interactiva
echo -n "🔑 Pega tu API Key de OpenWeather (invisible por seguridad): "
read -s API_KEY_PROYECTO
echo "" # Salto de línea
export API_KEY_PROYECTO

echo -n "🌍 Ingresa la ciudad a consultar (Ej: Paris, Tokyo) o presiona Enter para Santiago: "
read CIUDAD_INGRESADA
# Si el usuario no escribe nada, usamos Santiago por defecto
export CIUDAD="${CIUDAD_INGRESADA:-Santiago}"

# 2. Limpieza y Descarga desde GitHub (El "hacer todo")
echo -e "\n[-] 1. Preparando entorno de trabajo..."
# Nos movemos a una carpeta temporal para que la descarga sea limpia
cd /tmp 
rm -rf ea2-valdebenito 2>/dev/null || true
docker rm -f clima-ejecucion 2>/dev/null || true
docker rmi -f ea2-clima 2>/dev/null || true

echo "[+] 2. Descargando código fuente desde GitHub..."
git clone https://github.com/PiMienTHD/ea2-valdebenito.git
cd ea2-valdebenito

# 3. Creación del Dockerfile automatizado
echo "[+] 3. Generando Dockerfile..."
cat << 'EOF' > Dockerfile
FROM python:3.9-slim
WORKDIR /app
RUN pip install --progress-bar off requests
COPY app.py .
CMD ["python", "app.py"]
EOF

# 4. Construcción de la imagen
echo "[+] 4. Construyendo infraestructura con Docker..."
docker build -t ea2-clima .

# 5. Ejecución con inyección de variables
echo "[+] 5. Ejecutando el Asistente de Clima..."
echo "------------------------------------------------"
docker run --name clima-ejecucion -e API_KEY_PROYECTO="$API_KEY_PROYECTO" -e CIUDAD="$CIUDAD" ea2-clima
echo "------------------------------------------------"

# 6. Evidencia final
echo "[+] 6. Estado final del contenedor:"
docker ps -a | grep clima-ejecucion
