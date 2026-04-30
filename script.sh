#!/bin/bash

echo "[-] Limpiando ejecuciones anteriores..."
docker rm -f clima-ejecucion 2>/dev/null || true
rm -rf ea2-valdebenito

echo "[+] 1. Clonando tu repositorio oficial desde GitHub..."
git clone https://github.com/PiMienTHD/ea2-valdebenito.git

echo "[+] 2. Entrando a la carpeta del proyecto..."
cd ea2-valdebenito

echo "[+] 3. Generando el Dockerfile..."
cat << 'EOF' > Dockerfile
FROM python:3.9-slim
WORKDIR /app
RUN pip install --progress-bar off requests
COPY apyclima.py .
CMD ["python3", "apyclima.py"]
EOF

echo "[+] 4. Construyendo la imagen de Docker..."
docker build -t ea2-clima .

echo "[+] 5. ¡Ejecutando tu Asistente de Clima!"
echo "------------------------------------------------"
docker run -it --name clima-ejecucion ea2-clima
