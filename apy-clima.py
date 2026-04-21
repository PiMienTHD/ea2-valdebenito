import requests

def consultar_clima():
    print("🌤️ ¡Bienvenido al Asistente de Clima y Vestimenta!")
    
    # El bucle permite buscar varias ciudades sin tener que reiniciar el programa
    while True:
        ciudad = input("\nIngresa una ciudad (ej. Santiago, Paris) o escribe 'salir': ").lower().strip()
        
        if ciudad == 'salir':
            print("¡Nos vemos! Saliendo del programa...")
            break

        # Tu API Key (ya corregida)
        api_key = "72caa147440ee6d5e4366225504cae47"

        # ① ZONA AZUL — Construcción de la solicitud
        url = f"https://api.openweathermap.org/data/2.5/weather?q={ciudad}&appid={api_key}&units=metric&lang=es"

        try:
            # ② ZONA VERDE — Llamada HTTP
            respuesta = requests.get(url, timeout=5)

            # Evaluamos los posibles escenarios de respuesta del servidor
            if respuesta.status_code == 200:
                datos = respuesta.json()
                
                # ③ ZONA ROJA — Parseo y transformación del JSON
                condicion = datos.get("weather", [{}])[0].get("description", "Desconocida")
                
                temperatura = datos.get("main", {}).get("temp", "?")
                sensacion = datos.get("main", {}).get("feels_like", "?")
                humedad = datos.get("main", {}).get("humidity", "?")
                presion = datos.get("main", {}).get("pressure", "?")
                viento = datos.get("wind", {}).get("speed", "?")
                
                # ④ ZONA MORADA — Formateo y salida al usuario
                print(f"\n=== CLIMA EN {ciudad.upper()} ===")
                print(f"☁️  Condición  : {condicion.capitalize()}")
                print(f"🌡️  Temperatura: {temperatura}°C (Sensación térmica: {sensacion}°C)")
                print(f"💧  Humedad    : {humedad}%")
                print(f"📏  Presión    : {presion} hPa")
                print(f"💨  Viento     : {viento} m/s")
                
                # --- LÓGICA DE SUGERENCIA DE VESTIMENTA ---
                print("\n💡 Sugerencia de vestimenta:")
                
                # Chequeo de lluvia
                if "lluvia" in condicion.lower() or "llovizna" in condicion.lower():
                    print("   ☔ Extra: ¡Llévalo sí o sí! Paraguas o una chaqueta impermeable.")
                    
                # Recomendaciones por sensación térmica
                if isinstance(sensacion, (int, float)):
                    if sensacion < 10:
                        print("   ❄️  Ropa: Parka gruesa, chaleco, bufanda y pantalones largos.")
                    elif 10 <= sensacion < 18:
                        print("   🧥  Ropa: Polerón o cortavientos, y jeans o buzo.")
                    elif 18 <= sensacion <= 25:
                        print("   👕  Ropa: Polera. Lleva un polerón ligero por si refresca.")
                    else:
                        print("   🩳  Ropa: Shorts, ropa fresca, lentes de sol y bloqueador.")
            
            # Manejo de errores HTTP específicos
            elif respuesta.status_code == 404:
                print(f"❌ Error 404: La ciudad '{ciudad.title()}' no existe. Revisa si la escribiste bien.")
            elif respuesta.status_code == 401:
                print("❌ Error 401: API Key inválida. Revisa tu clave en OpenWeatherMap.")
            else:
                print(f"⚠️ Error inesperado: El servidor devolvió el código HTTP {respuesta.status_code}.")

        # Manejo de errores de red o conexión
        except requests.exceptions.ConnectionError:
            print("🔌 Error de Red: Sin internet o no se pudo conectar al servidor.")
        except requests.exceptions.Timeout:
            print("⏱️ Timeout: El servidor tardó más de 5 segundos en responder.")

# Ejecutamos la función principal
if __name__ == "__main__":
    consultar_clima()