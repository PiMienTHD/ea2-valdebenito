#!/bin/bash

# ==============================================================================
# Script de Automatización CI/CD - Asistente Climático
# ==============================================================================

echo "[-] 1. Limpiando ejecuciones y contenedores anteriores..."
# Se usa '|| true' para que el script no falle si no hay contenedores previos
docker rm -f clima-ejecucion 2>/dev/null || true

echo "[+] 2. Generando Dockerfile automatizado..."
# Esto crea el archivo Dockerfile en la misma carpeta donde se ejecuta el script
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
# Se inyecta la variable de entorno de forma segura al contenedor
docker run --name clima-ejecucion -e API_KEY_PROYECTO="$API_KEY_PROYECTO" ea2-clima
echo "------------------------------------------------"

echo "[+] 5. Verificando el estado final del contenedor (Debe decir 'Exited (0)')..."
# Muestra el contenedor apagado exitosamente, tal como pide la evaluación
docker ps -a | grep clima-ejecucion
