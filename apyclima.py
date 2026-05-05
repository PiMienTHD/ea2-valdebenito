import requests
import os
import sys

# La llave se lee de forma segura desde el sistema, NO está hardcodeada
api_key = os.getenv('API_KEY_PROYECTO')
# Definimos una ciudad estática para la consulta puntual automatizada
ciudad = "Santiago" 

if not api_key:
    print("Error Crítico: La variable de entorno API_KEY_PROYECTO no está configurada.")
    sys.exit(1) # Jenkins leerá esto como fallo en el pipeline

url = f"http://api.openweathermap.org/data/2.5/weather?q={ciudad}&appid={api_key}&units=metric&lang=es"

try:
    respuesta = requests.get(url, timeout=10)
    codigo = respuesta.status_code

    if codigo == 200:
        datos = respuesta.json()
        # Procesamiento de 3 campos exigidos
        clima = datos['weather'][0]['description']
        temp = datos['main']['temp']
        humedad = datos['main']['humidity']
        
        print("==================================================")
        print(" REPORTE CLIMÁTICO PARA FACILITY MANAGEMENT")
        print("==================================================")
        print(f"Ciudad Consultada: {ciudad}")
        print(f"Condición Actual: {clima}")
        print(f"Temperatura: {temp}°C")
        print(f"Humedad Relativa: {humedad}%")
        print("==================================================")
        sys.exit(0) # Código de salida 0 para que Jenkins marque SUCCESS

    # Manejo robusto de 4+ errores
    elif codigo == 401:
        print("Error 401: API Key inválida o no autorizada.")
        sys.exit(1)
    elif codigo == 404:
        print(f"Error 404: La ciudad '{ciudad}' no existe en la base de datos.")
        sys.exit(1)
    elif codigo == 429:
        print("Error 429: Límite de consultas a la API excedido.")
        sys.exit(1)
    elif codigo >= 500:
        print(f"Error {codigo}: Falla interna en los servidores de OpenWeather.")
        sys.exit(1)
    else:
        print(f"Error HTTP inesperado. Código: {codigo}")
        sys.exit(1)

except requests.exceptions.ConnectionError:
    print("Error de Conexión: El contenedor no tiene acceso a Internet.")
    sys.exit(1)
except requests.exceptions.Timeout:
    print("Error de Timeout: La API tardó demasiado en responder.")
    sys.exit(1)
