FROM python:3.9-slim
WORKDIR /app
RUN pip install requests
COPY apyclima.py .
CMD ["python3", "apyclima.py"]
