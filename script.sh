#!/bin/bash

echo "[-] Limpiando ejecuciones anteriores..."
docker rm -f clima-ejecucion 2>/dev/null || true

echo "[+] Generando Dockerfile desde cero..."
# ¡ESTA ES LA PARTE QUE FABRICA EL DOCKERFILE!
# Todo lo que está entre los 'EOF' se escribirá dentro de un nuevo archivo llamado Dockerfile
cat << 'EOF' > Dockerfile
FROM python:3.9-slim
WORKDIR /app
RUN pip install --progress-bar off requests
COPY app.py .
CMD ["python", "app.py"]
EOF

echo "[+] Construyendo la imagen de Docker..."
docker build -t ea2-clima .

echo "[+] ¡Ejecutando tu Asistente de Clima!"
echo "------------------------------------------------"
docker run -it --name clima-ejecucion -e API_KEY_PROYECTO="$API_KEY_PROYECTO" ea2-clima
echo "------------------------------------------------"
