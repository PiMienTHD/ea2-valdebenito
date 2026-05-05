#!/bin/bash

echo "[-] Deteniendo contenedores anteriores..."
# Absorbe el error si no existe, igual que el pipeline
docker rm -f clima-ejecucion 2>/dev/null || true 

echo "[+] Generando Dockerfile..."
cat << 'EOF' > Dockerfile
FROM python:3.9-slim
WORKDIR /app
RUN pip install --progress-bar off requests
COPY app.py .
CMD ["python", "app.py"]
EOF

echo "[+] Construyendo la imagen..."
docker build -t ea2-clima .

echo "[+] Ejecutando contenedor (Consulta Puntual)..."
# Pasamos la variable de entorno al contenedor para mantener la seguridad
docker run --name clima-ejecucion -e API_KEY_PROYECTO="$API_KEY_PROYECTO" ea2-clima
