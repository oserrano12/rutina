- =========================================================
-- SISTEMA DE RUTINAS DE ENTRENAMIENTO COMPLETO
-- Base de datos con funcionalidades de rutinas personalizadas y reportes
-- =========================================================

-- =========================================================
-- Limpieza (en orden por dependencias)
-- =========================================================
DROP TABLE IF EXISTS ejercicios_realizados CASCADE;
DROP TABLE IF EXISTS sesiones_entrenamiento CASCADE;
DROP TABLE IF EXISTS objetivos_usuario CASCADE;
DROP TABLE IF EXISTS ejercicios_en_rutina CASCADE;
DROP TABLE IF EXISTS ejercicios_musculos CASCADE;
DROP TABLE IF EXISTS rutinas CASCADE;
DROP TABLE IF EXISTS ejercicios CASCADE;
DROP TABLE IF EXISTS musculos CASCADE;
DROP TABLE IF EXISTS grupos_musculares CASCADE;
DROP TABLE IF EXISTS usuarios CASCADE;

-- =========================================================
-- TABLAS PRINCIPALES
-- =========================================================

CREATE TABLE usuarios (
    id_usuario SERIAL CONSTRAINT pk_usuarios PRIMARY KEY,
    nombre_usuario VARCHAR(50) NOT NULL,
    apellido_usuario VARCHAR(50) NOT NULL,
    email_usuario VARCHAR(100) NOT NULL UNIQUE,
    edad_usuario NUMERIC(2) NOT NULL CONSTRAINT ck1_usuarios CHECK (edad_usuario BETWEEN 14 AND 80),
    estatura_usuario NUMERIC(3) NOT NULL CONSTRAINT ck2_usuarios CHECK (estatura_usuario BETWEEN 130 AND 250),
    peso_usuario NUMERIC(5,2) NOT NULL CONSTRAINT ck3_usuarios CHECK (peso_usuario BETWEEN 30.00 AND 200.00),
    genero_usuario VARCHAR(10) NOT NULL CONSTRAINT ck4_usuarios CHECK (LOWER(genero_usuario) IN ('masculino', 'femenino', 'otro')),
    fecha_registro TIMESTAMP NOT NULL DEFAULT NOW(),
    activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE grupos_musculares (
    id_grupo SMALLSERIAL CONSTRAINT pk_grupos_musculares PRIMARY KEY,
    nombre_grupo VARCHAR(100) NOT NULL UNIQUE,
    descripcion_grupo VARCHAR(200)
);

CREATE TABLE musculos (
    id_musculo SMALLSERIAL CONSTRAINT pk_musculos PRIMARY KEY,
    nombre_musculo VARCHAR(100) NOT NULL,
    id_grupo_muscular SMALLINT NOT NULL,
    CONSTRAINT fk_musculos_grupo FOREIGN KEY (id_grupo_muscular) REFERENCES grupos_musculares(id_grupo)
);

CREATE TABLE ejercicios (
    id_ejercicio SMALLSERIAL PRIMARY KEY,
    nombre_ejercicio VARCHAR(100) NOT NULL UNIQUE,
    descripcion_ejercicio VARCHAR(500) NOT NULL,
    tipo_ejercicio VARCHAR(50) NOT NULL CONSTRAINT ck_ejercicios CHECK (LOWER(tipo_ejercicio) IN ('casa', 'gimnasio', 'ambos')),
    equipo_necesario VARCHAR(200),
    dificultad VARCHAR(20) CHECK (LOWER(dificultad) IN ('principiante', 'intermedio', 'avanzado')),
    instrucciones TEXT
);

CREATE TABLE ejercicios_musculos (
    id_ejercicio SMALLINT NOT NULL,  
    id_musculo SMALLINT NOT NULL, 
    importancia VARCHAR(20) NOT NULL CONSTRAINT ck1_ejercicios_musculos CHECK (LOWER(importancia) IN ('principal','secundario','estabilizador')),
    CONSTRAINT pk_ejercicios_musculos PRIMARY KEY (id_ejercicio, id_musculo),
    CONSTRAINT fk1_ejercicios_musculos FOREIGN KEY (id_ejercicio) REFERENCES ejercicios(id_ejercicio) ON DELETE CASCADE,
    CONSTRAINT fk2_ejercicios_musculos FOREIGN KEY (id_musculo) REFERENCES musculos(id_musculo) ON DELETE CASCADE
);

CREATE TABLE rutinas (
    id_rutina SERIAL CONSTRAINT pk_rutinas PRIMARY KEY,
    nombre_rutina VARCHAR(100) NOT NULL,
    descripcion VARCHAR(500) NOT NULL,
    objetivo VARCHAR(30) CONSTRAINT ck1_rutinas CHECK (LOWER(objetivo) IN ('fuerza', 'hipertrofia', 'resistencia', 'general')),
    nivel VARCHAR(20) NOT NULL CONSTRAINT ck2_rutinas CHECK (LOWER(nivel) IN ('principiante', 'intermedio', 'avanzado')),
    id_usuario INT, -- NULL = rutina predefinida del sistema, NOT NULL = rutina personalizada
    es_publica BOOLEAN DEFAULT TRUE, -- Si otros usuarios pueden ver esta rutina
    duracion_estimada_min SMALLINT, -- Duración estimada en minutos
    frecuencia_semanal SMALLINT CHECK (frecuencia_semanal BETWEEN 1 AND 7),
    creado_en TIMESTAMP NOT NULL DEFAULT NOW(),
    actualizado_en TIMESTAMP DEFAULT NOW(),
    CONSTRAINT fk_rutinas_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE SET NULL,
    CONSTRAINT uk_rutina_usuario UNIQUE (nombre_rutina, id_usuario) -- Permite nombres duplicados entre usuarios
);

CREATE TABLE ejercicios_en_rutina (
    id_rutina INT NOT NULL,
    id_ejercicio SMALLINT NOT NULL,   
    series SMALLINT NOT NULL CONSTRAINT ck1_ejercicios_en_rutina CHECK (series > 0),
    repeticiones SMALLINT NOT NULL CONSTRAINT ck2_ejercicios_en_rutina CHECK (repeticiones > 0),
    descanso_seg SMALLINT CONSTRAINT ck3_ejercicios_en_rutina CHECK (descanso_seg IS NULL OR descanso_seg >= 0),            
    orden_ejercicio SMALLINT CONSTRAINT ck4_ejercicios_en_rutina CHECK (orden_ejercicio IS NULL OR orden_ejercicio > 0),
    intensidad VARCHAR(20) CONSTRAINT ck5_ejercicios_en_rutina CHECK (LOWER(intensidad) IN ('baja', 'media', 'alta')),
    peso_sugerido NUMERIC(5,2), -- Peso sugerido para el ejercicio
    notas VARCHAR(200), -- Notas específicas para este ejercicio en la rutina
    CONSTRAINT pk_ejr PRIMARY KEY (id_rutina, id_ejercicio),
    CONSTRAINT fk1_ejercicios_en_rutina FOREIGN KEY (id_rutina) REFERENCES rutinas(id_rutina) ON DELETE CASCADE,
    CONSTRAINT fk2_ejercicios_en_rutina FOREIGN KEY (id_ejercicio) REFERENCES ejercicios(id_ejercicio)
);

-- =========================================================
-- NUEVAS TABLAS PARA SEGUIMIENTO Y REPORTES
-- =========================================================

CREATE TABLE objetivos_usuario (
    id_objetivo SERIAL PRIMARY KEY,
    id_usuario INT NOT NULL,
    tipo_objetivo VARCHAR(50) NOT NULL CHECK (tipo_objetivo IN ('peso_corporal', 'fuerza', 'resistencia', 'hipertrofia', 'definicion', 'general')),
    descripcion VARCHAR(200) NOT NULL,
    valor_actual NUMERIC(8,2),
    valor_objetivo NUMERIC(8,2),
    unidad_medida VARCHAR(20), -- kg, repeticiones, minutos, etc.
    fecha_inicio DATE NOT NULL DEFAULT CURRENT_DATE,
    fecha_limite DATE,
    alcanzado BOOLEAN DEFAULT FALSE,
    fecha_alcanzado DATE,
    prioridad VARCHAR(10) DEFAULT 'media' CHECK (prioridad IN ('baja', 'media', 'alta')),
    CONSTRAINT fk_objetivos_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
);

CREATE TABLE sesiones_entrenamiento (
    id_sesion SERIAL PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_rutina INT NOT NULL,
    fecha_sesion DATE NOT NULL DEFAULT CURRENT_DATE,
    hora_inicio TIME,
    hora_fin TIME,
    ubicacion VARCHAR(50) CHECK (ubicacion IN ('casa', 'gimnasio', 'parque', 'otro')),
    estado VARCHAR(20) DEFAULT 'completada' CHECK (estado IN ('completada', 'incompleta', 'cancelada')),
    calificacion SMALLINT CHECK (calificacion BETWEEN 1 AND 5), -- Calificación de la sesión del 1 al 5
    notas_sesion VARCHAR(500),
    peso_corporal NUMERIC(5,2), -- Peso del usuario el día de la sesión
    creado_en TIMESTAMP DEFAULT NOW(),
    CONSTRAINT fk_sesiones_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
    CONSTRAINT fk_sesiones_rutina FOREIGN KEY (id_rutina) REFERENCES rutinas(id_rutina)
);

CREATE TABLE ejercicios_realizados (
    id_ejercicio_realizado SERIAL PRIMARY KEY,
    id_sesion INT NOT NULL,
    id_ejercicio SMALLINT NOT NULL,
    series_completadas SMALLINT NOT NULL CHECK (series_completadas >= 0),
    repeticiones_realizadas SMALLINT NOT NULL CHECK (repeticiones_realizadas >= 0),
    peso_utilizado NUMERIC(5,2) CHECK (peso_utilizado >= 0), -- Para ejercicios con peso
    tiempo_descanso SMALLINT CHECK (tiempo_descanso >= 0), -- Descanso real tomado en segundos
    tiempo_ejecucion SMALLINT, -- Tiempo total para completar el ejercicio en segundos
    dificultad_percibida SMALLINT CHECK (dificultad_percibida BETWEEN 1 AND 10), -- Escala RPE 1-10
    notas_ejercicio VARCHAR(200),
    completado BOOLEAN DEFAULT TRUE,
    orden_realizado SMALLINT, -- En qué orden se realizó este ejercicio
    CONSTRAINT fk_ejercicios_realizados_sesion FOREIGN KEY (id_sesion) REFERENCES sesiones_entrenamiento(id_sesion) ON DELETE CASCADE,
    CONSTRAINT fk_ejercicios_realizados_ejercicio FOREIGN KEY (id_ejercicio) REFERENCES ejercicios(id_ejercicio)
);

