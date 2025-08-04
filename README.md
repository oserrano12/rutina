# 🏋️‍♂️ Rutina Fit — Gestor de Ejercicios y Progreso Personal

Rutina Fit es una aplicación que permite registrar, organizar y visualizar rutinas de ejercicio físico, tanto en casa como en el gimnasio. Diseñada para ser usada por cualquier persona que quiera dejar su sedentarismo, 
su objetivo es facilitar el seguimiento diario del entrenamiento y generar reportes automáticos del progreso en formato Excel.

## 🎯 Propósitos del proyecto
- 📋 Crear una base de datos estructurada con información de ejercicios, músculos involucrados y rutinas personalizadas.

- 👤 Registrar múltiples usuarios y sus historiales de entrenamiento.

- 🖱️ Proporcionar una interfaz gráfica fácil de usar para planificar y registrar cada sesión de entrenamiento.

- 📈 Generar reportes automáticos en Excel con el resumen del desempeño (ejercicios, series, repeticiones, intensidad, descansos, fechas, etc.).

- 🧠 Servir como asistente diario para mantener la constancia en los entrenamientos.

## 📂 Contenido del proyecto

- db/estructura.sql — Esquema de la base de datos

- src/interfaz.py — Interfaz gráfica (GUI)

- src/registro.py — Lógica de registro de rutinas

- src/exportador_excel.py — Generador de reportes en Excel

## 🧩 Base de datos: Entidades previstas
-🧍‍♂️ Usuarios: nombre, edad, nivel, objetivos

-🏋️‍♀️ Ejercicios: nombre, tipo (casa/gimnasio), músculos trabajados, equipamiento requerido

-💪 Músculos: agrupaciones musculares (pecho, espalda, piernas, etc.)

-📅 Sesiones: fecha, usuario, ejercicios realizados, series, repeticiones, intensidad, descansos

-📊 Progreso: métricas resumidas por semana o mes para el reporte

## 🖥️ Interfaz gráfica
La aplicación contará con una GUI que permitirá:

- Seleccionar usuario

- Elegir ejercicios del día

- Registrar parámetros del entrenamiento

- Guardar el registro en la base de datos

- Generar un reporte en Excel con un clic

### 🚧 Tecnología a definir: posibles opciones: Tkinter, Kivy, PySide6, Electron + SQLite
➡️ Buscamos algo visualmente agradable y funcional

## 🛠️ Tecnologías a utilizar
- 🐍 Python 3

- :elephant: Postgre

- 🖼️ GUI (por definir)

- 📊 Pandas + openpyxl o xlsxwriter

## 🚀 Cómo ejecutar el proyecto

Clonar el repositorio

Ejecutar `interfaz.py` desde la carpeta `src/`

- Seguir las instrucciones de la interfaz para registrar y generar reportes

- Se agregará un archivo requirements.txt con las dependencias necesarias.

## 📈 Ejemplo de reporte (próximamente)
- Ejercicios realizados por fecha

- Series, repeticiones e intensidad

- Progreso semanal o mensual

👥 Autores
Proyecto creado por:

Jordy Jaimes @JorgeJordyJaimes

Oscar Serrano @osserrano12

📄 Licencia
Este proyecto es de uso personal. Puede compartirse libremente con atribución. Se incluirá una licencia si se publica públicamente.
