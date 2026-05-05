#!/bin/bash

# ==============================================================================
# SCRIPT DE DESPLIEGUE INTERACTIVO Y GENERACIÓN DE EVIDENCIAS
# ==============================================================================

echo "======================================================="
echo "   CONFIGURACIÓN DEL ASISTENTE CLIMÁTICO"
echo "======================================================="

# 1. Solicitar API Key de forma segura
echo -n "🔑 Pega tu API Key de OpenWeather: "
read -s API_KEY_PROYECTO
echo ""
export API_KEY_PROYECTO

# 2. Solicitar la CIUDAD al usuario (Lo que faltaba)
echo -n "🌍 ¿Qué ciudad deseas consultar? (Ej: Paris, Tokyo, Concepcion): "
read CIUDAD_USUARIO
export CIUDAD="$CIUDAD_USUARIO"

# 3. Clonar el repositorio
echo -e "\n[+] 1. Descargando repositorio desde GitHub..."
git clone https://github.com/PiMienTHD/ea2-valdebenito.git
cd ea2-valdebenito

# 4. Crear carpetas de evidencia
mkdir -p evidencias/docker

# 5. Generar Dockerfile dinámico[cite: 1]
echo "[+] 2. Preparando Dockerfile..."
cat << 'EOF' > Dockerfile
FROM python:3.9-slim
WORKDIR /app
RUN pip install --progress-bar off requests
COPY app.py .
CMD ["python", "app.py"]
EOF

# 6. Construcción e Inyección de Variables[cite: 1]
echo "[+] 3. Construyendo imagen Docker..."
docker build -t ea2-clima .

echo "[+] 4. Ejecutando consulta para $CIUDAD..."
docker rm -f clima-ejecucion 2>/dev/null || true

# Ejecutamos pasando AMBAS variables al contenedor[cite: 1]
docker run --name clima-ejecucion \
  -e API_KEY_PROYECTO="$API_KEY_PROYECTO" \
  -e CIUDAD="$CIUDAD" \
  ea2-clima

# 7. Captura de Evidencias obligatorias[cite: 1]
echo -e "\n[+] 5. Guardando evidencias en evidencias/docker/output.txt..."

# Estado del contenedor (debe decir Exited 0)[cite: 1]
docker ps -a --filter "name=clima-ejecucion" > evidencias/docker/output.txt

# Logs con los datos reales de la ciudad elegida[cite: 1]
echo -e "\n--- DATOS REALES PARA LA CIUDAD: $CIUDAD ---" >> evidencias/docker/output.txt
docker logs clima-ejecucion >> evidencias/docker/output.txt

echo "======================================================="
echo " ✅ PROCESO EXITOSO"
echo " Ciudad consultada: $CIUDAD"
echo " La carpeta 'ea2-valdebenito' se mantiene intacta."
echo " Revisa el archivo 'output.txt' para verificar tu nota."
echo "======================================================="
