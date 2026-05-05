#!/bin/bash

# Esta línea mágica mueve la terminal a la carpeta exacta donde está este script
cd "$(dirname "$0")"

echo "[-] 1. Limpiando ejecuciones y contenedores anteriores..."
docker rm -f clima-ejecucion 2>/dev/null || true
# Forzamos la eliminación de la imagen corrupta anterior por si acaso
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
docker run --name clima-ejecucion -e API_KEY_PROYECTO="$API_KEY_PROYECTO" ea2-clima
echo "------------------------------------------------"

echo "[+] 5. Verificando el estado final del contenedor..."
docker ps -a | grep clima-ejecucion
