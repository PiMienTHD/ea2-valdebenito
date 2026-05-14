# ☁️ Asistente Climático Automatizado para Gestión Inmobiliaria (CI/CD)

Este proyecto implementa una solución de automatización y orquestación para el monitoreo climático en tiempo real, orientado a la eficiencia operativa en infraestructuras críticas.

## 1. Definición del Contexto y Narrativa
* **Stakeholder:** Facility Manager (Administrador de Infraestructura y Edificios Corporativos).
* **Propuesta de Valor:** El administrador necesita monitorear variables climáticas críticas (temperatura y humedad) en tiempo real en Santiago para gestionar proactivamente los sistemas HVAC (Calefacción, Ventilación y Aire Acondicionado) que enfrían los cuartos de servidores. 
* **Solución:** Esta aplicación extrae y procesa datos meteorológicos desde una API externa de forma puntual y automatizada, permitiendo prevenir la condensación en los equipos y optimizar el consumo energético del edificio.

## 2. Requisitos Previos (Obtención de API Key)
Por políticas estrictas de ciberseguridad y mejores prácticas **DevSecOps**, este repositorio no expone credenciales ni llaves de acceso en su código fuente. Para ejecutar esta herramienta, se debe proveer una llave de la API de OpenWeather:
1. Ingrese a [OpenWeatherMap](https://openweathermap.org/) y cree una cuenta.
2. Diríjase a su perfil y seleccione la pestaña **"My API Keys"**.
3. Genere una nueva llave y cópiela.

## 3. Guía de Configuración (Variables de Envorno)
El programa buscará específicamente la variable de entorno `API_KEY_PROYECTO`. Es estrictamente obligatorio configurarla antes de la ejecución:

* **Linux (Bash):** `export API_KEY_PROYECTO="tu_llave_aqui"`
* **Windows (PowerShell):** `$env:API_KEY_PROYECTO="tu_llave_aqui"`

## 4. Instrucciones de Ejecución Local
Este proyecto utiliza Docker para asegurar la consistencia del entorno.
1. Otorgue permisos al script: `chmod +x build.sh`
2. Ejecute la automatización: `./build.sh`

El script realizará la limpieza de contenedores previos, construirá la imagen `ea2-clima` e imprimirá el reporte climático final por consola.

## 5. Orquestación CI/CD (Jenkins Pipeline)
Se implementó un **Pipeline Declarativo** en Jenkins para gestionar el ciclo de vida de la aplicación de forma secuencial:
* **Stage 'Preparation':** Detiene y elimina contenedores existentes para evitar conflictos de nombres (`clima-ejecucion`). Utiliza `|| true` para permitir la continuidad del flujo si no existen procesos previos.
* **Stage 'Build':** Invoca el trabajo de construcción de imagen y ejecución, inyectando de forma segura la API Key desde el gestor de credenciales de Jenkins.

## 6. Estructura del Repositorio
```text
ea2-valdebenito/
├── app.py                # Script principal en Python
├── Dockerfile            # Definición de la imagen del contenedor
├── build.sh              # Script de automatización local
├── .gitignore            # Exclusión de archivos innecesarios/sensibles
├── README.md             # Documentación del proyecto
└── evidencias/           # Carpeta de evidencias para evaluación
    ├── docker/           # Capturas de ejecución de contenedores
    └── jenkins/          # Capturas de Pipeline, Credenciales y Script
