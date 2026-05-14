FROM python:3.9-slim
WORKDIR /app
RUN pip install --progress-bar off requests
COPY app.py .
CMD ["python", "app.py"]

