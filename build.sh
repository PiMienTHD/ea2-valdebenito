#!/bin/bash

# Se mueve a la carpeta exacta donde está el script para evitar errores de rutas
cd "$(dirname "$0")"

echo "[-] 1. Limpiando ejecuciones y contenedores anteriores..."
docker rm -f clima-ejecucion 2>/dev/null || true
docker rmi -f ea2-clima 2>/dev/null || true

echo "[+] 2. Generando Dockerfile automatizado..."
cat << 'EOF' > Dockerfile
FROM python:3.9-slim
WORKDIR /app
RUN pip install --progress-bar off requests
COPY app.py .
CMD ["python", "app.py"]
EOF

echo "[+] 3. Construyendo la imagen de Docker (ea2-clima)..."
docker build -t ea2-clima .

echo "[+] 4. Ejecutando el Asistente de Clima..."
echo "------------------------------------------------"
# Inyecta la API Key y la Ciudad (si existe, si no, Python usará Santiago)
docker run --name clima-ejecucion -e API_KEY_PROYECTO="$API_KEY_PROYECTO" -e CIUDAD="$CIUDAD" ea2-clima
echo "------------------------------------------------"

echo "[+] 5. Verificando el estado final del contenedor (Evidencia)..."
docker ps -a | grep clima-ejecucion
