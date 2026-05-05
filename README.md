# Asistente Climático Automatizado para Gestión Inmobiliaria (CI/CD)

## 1. Definición del Contexto y Narrativa
* **Stakeholder:** *Facility Manager* (Administrador de Infraestructura y Edificios Corporativos).
* **Propuesta de Valor (Problema/Solución):** El administrador necesita monitorear variables climáticas críticas (temperatura y humedad) en tiempo real en Santiago para gestionar proactivamente los sistemas HVAC (Calefacción, Ventilación y Aire Acondicionado) que enfrían los cuartos de servidores. Esta aplicación resuelve el problema extrayendo y procesando dichos datos desde una API externa de forma puntual y automatizada, evitando la condensación en los equipos y optimizando el consumo energético del edificio.

## 2. Requisitos Previos (Obtención de API Key)
Por políticas estrictas de ciberseguridad y mejores prácticas DevSecOps, **este repositorio no expone credenciales ni llaves de acceso en su código fuente**. 

Para ejecutar esta herramienta, el usuario u orquestador debe proveer su propia llave de la API de OpenWeather:
1. Ingrese a [OpenWeatherMap](https://openweathermap.org/) y cree una cuenta gratuita.
2. Diríjase a su perfil y seleccione la pestaña **"My API Keys"**.
3. Genere una nueva llave y cópiela.

## 3. Guía de Configuración (Variables de Entorno)
Antes de ejecutar la aplicación o lanzar el pipeline en Jenkins, es **estrictamente obligatorio** configurar la llave obtenida en el paso anterior como una variable de entorno en su sistema. El programa buscará específicamente la variable `API_KEY_PROYECTO`.

**En sistemas Linux (Bash / Ubuntu / Debian):**
\`\`\`bash
export API_KEY_PROYECTO="pegue_su_llave_aqui"
\`\`\`

**En sistemas Windows (PowerShell):**
\`\`\`powershell
$env:API_KEY_PROYECTO="pegue_su_llave_aqui"
\`\`\`

## 4. Instrucciones de Ejecución
Este proyecto utiliza Docker para asegurar que el entorno de ejecución sea idéntico en cualquier máquina. Cuenta con un script principal de automatización (`build.sh`) que gestiona todo el ciclo de vida del contenedor.

Una vez configurada la variable de entorno, siga estos pasos en la raíz del proyecto:

1. Otorgue permisos de ejecución al script:
   \`\`\`bash
   chmod +x build.sh
   \`\`\`
2. Ejecute la automatización:
   \`\`\`bash
   ./build.sh
   \`\`\`

El script realizará las siguientes acciones de forma desatendida:
* Limpieza de contenedores previos.
* Generación del `Dockerfile`.
* Construcción de la imagen Docker (`ea2-clima`).
* Ejecución de la consulta puntual, inyectando de forma segura la credencial al contenedor.
* Impresión del reporte climático final por consola.
