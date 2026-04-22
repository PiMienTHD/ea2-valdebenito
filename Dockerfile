FROM python:3.9-slim
WORKDIR /app
RUN pip install --progress-bar off requests
COPY apyclima.py .
CMD ["python3", "apyclima.py"]
# Configuración final optimizada para el pipeline CI/CD
