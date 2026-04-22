# Asistente de Clima EA2
# Asistente de Clima EA2

**Autor:** Adrian Valdebenito
**Asignatura:** Programación y Redes Virtualizadas (SDN-NFV)

## Descripción General
Este proyecto consiste en un script de Python que interactúa con la API de OpenWeatherMap para consultar el clima de distintas ciudades. La aplicación ha sido empaquetada utilizando Docker y automatizada mediante un pipeline de Integración Continua (CI) en Jenkins.

## Cómo Ejecutar la Aplicación 🚀
Para ejecutar este proyecto de forma local utilizando contenedores, debes tener instalado Docker. Abre tu terminal y ejecuta los siguientes comandos:

1. **Construir la imagen de Docker:**
   `docker build -t ea2-clima .`

2. **Ejecutar el contenedor (modo interactivo):**
   `docker run -it ea2-clima`

El programa te pedirá que ingreses el nombre de una ciudad. Para salir, simplemente escribe "salir".

---

## Registro de Errores y Soluciones Documentadas (CI/CD)
Durante el desarrollo e implementación en la máquina virtual (LabVM), se detectaron y resolvieron los siguientes incidentes técnicos:

* **1. Error de Hilos (Threads) en pip:**
  * **Error:** `RuntimeError: can't start new thread` durante la instalación de dependencias en Docker.
  * **Solución:** Se añadió el flag `--progress-bar off` al comando `pip install` en el Dockerfile para evitar el bloqueo de subprocesos de la LabVM.

* **2. Colisión de Puertos en Jenkins:**
  * **Error:** `bind: address already in use` en el puerto `8080`.
  * **Solución:** Se detuvo y deshabilitó el servicio local de Jenkins nativo en Linux (`systemctl stop jenkins`) para liberar el puerto para el contenedor Docker.

* **3. Restricciones de Permisos en Jenkins (EPERM):**
  * **Error:** Java falló al iniciar hilos (`EPERM`) debido a políticas de la máquina anfitriona.
  * **Solución:** Se ejecutó el contenedor Docker de Jenkins con el parámetro `--privileged` y un volumen de datos nuevo.

* **4. Error de Rama y Archivo en Jenkins:**
  * **Error:** `Couldn't find any revision to build` y fallo al copiar script.
  * **Solución:** Se actualizó la rama origen a `*/main` en la configuración de Jenkins y se estandarizó el nombre del archivo principal a `apyclima.py`.
