#!/bin/bash

# ==============================================================================
# SCRIPT MAESTRO DE DESPLIEGUE TOTAL (Con inyección segura de API Key)
# ==============================================================================

echo "======================================================="
echo " Iniciando Automatización Total (GitHub -> Docker -> App)"
echo "======================================================="

# 1. Solicitar la API Key de forma interactiva y segura (invisible por seguridad)
echo -n "🔑 Por favor, pega tu API Key de OpenWeather y presiona Enter: "
read -s llave_ingresada
echo "" # Salto de línea estético después de ingresar la llave oculta

# Inyectamos la llave en el sistema como variable de entorno
export API_KEY_PROYECTO="$llave_ingresada"

# 2. Limpieza destructiva (Asegura un entorno en blanco)
echo -e "\n[-] 1. Limpiando contenedores, imágenes y carpetas anteriores..."
cd ~
rm -rf ea2-valdebenito
docker rm -f clima-ejecucion 2>/dev/null || true
docker rmi -f ea2-clima 2>/dev/null || true

# 3. Descarga desde GitHub (Simulando el paso de Jenkins)
echo "[+] 2. Clonando repositorio oficial desde GitHub..."
git clone https://github.com/PiMienTHD/ea2-valdebenito.git
cd ea2-valdebenito

# 4. Creación del Dockerfile automatizado
echo "[+] 3. Generando Dockerfile..."
cat << 'EOF' > Dockerfile
FROM python:3.9-slim
WORKDIR /app
RUN pip install --progress-bar off requests
COPY apyclima.py .
CMD ["python", "apyclima.py"]
EOF

# 5. Construcción de la imagen
echo "[+] 4. Construyendo infraestructura con Docker..."
docker build -t ea2-clima .

# 6. Ejecución del contenedor
echo "[+] 5. Ejecutando el Asistente de Clima..."
echo "------------------------------------------------"
docker run --name clima-ejecucion -e API_KEY_PROYECTO="$API_KEY_PROYECTO" ea2-clima
echo "------------------------------------------------"

# 7. Evidencia para la evaluación
echo "[+] 6. Estado final del contenedor (Evidencia para output.txt)..."
docker ps -a | grep clima-ejecucion
