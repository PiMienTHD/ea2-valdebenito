#!/bin/bash

# ==============================================================================
# SCRIPT DE DESPLIEGUE Y GENERACIÓN DE EVIDENCIAS (NO AUTODESTRUCTIVO)
# ==============================================================================

echo "======================================================="
echo "   INICIANDO DESPLIEGUE DESDE GITHUB"
echo "======================================================="

# 1. Solicitar API Key de forma segura
echo -n "🔑 Pega tu API Key de OpenWeather: "
read -s API_KEY_PROYECTO
echo ""
export API_KEY_PROYECTO

# 2. Clonar el repositorio (Sin borrar después)
echo "[+] 1. Clonando repositorio en la carpeta actual..."
# Usamos un nombre de carpeta fijo para que sea fácil de encontrar
git clone https://github.com/PiMienTHD/ea2-valdebenito.git
cd ea2-valdebenito

# 3. Crear carpeta de evidencias (Requisito de la pauta)
mkdir -p evidencias/docker

# 4. Generar Dockerfile dinámico (Para asegurar que sea el correcto)
echo "[+] 2. Generando Dockerfile..."
cat << 'EOF' > Dockerfile
FROM python:3.9-slim
WORKDIR /app
RUN pip install --progress-bar off requests
COPY app.py .
CMD ["python", "app.py"]
EOF

# 5. Construcción de la imagen
echo "[+] 3. Construyendo imagen ea2-clima..."
docker build -t ea2-clima .

# 6. Ejecución y Logs
echo "[+] 4. Ejecutando contenedor..."
docker rm -f clima-ejecucion 2>/dev/null || true
docker run --name clima-ejecucion -e API_KEY_PROYECTO="$API_KEY_PROYECTO" -e CIUDAD="Santiago" ea2-clima

# 7. Captura de Evidencias para el entregable
echo "[+] 5. Generando archivo evidencias/docker/output.txt..."

# Estado del contenedor (debe decir Exited 0[cite: 1])
docker ps -a --filter "name=clima-ejecucion" > evidencias/docker/output.txt

# Logs con los datos reales de la API[cite: 1]
echo -e "\n--- DATOS REALES OBTENIDOS DE LA API ---" >> evidencias/docker/output.txt
docker logs clima-ejecucion >> evidencias/docker/output.txt

echo "======================================================="
echo " ✅ ¡LISTO! La carpeta 'ea2-valdebenito' ha sido creada."
echo " Todos los archivos y evidencias están guardados dentro."
echo " No se borró nada para que puedas revisar el contenido."
echo "======================================================="
