-- =========================================================
-- Limpieza (en orden por dependencias)
-- =========================================================
DROP TABLE IF EXISTS ejercicios_en_rutina CASCADE;
DROP TABLE IF EXISTS ejercicios_musculos  CASCADE;
DROP TABLE IF EXISTS rutinas              CASCADE;
DROP TABLE IF EXISTS ejercicios           CASCADE;
DROP TABLE IF EXISTS musculos             CASCADE;
DROP TABLE IF EXISTS grupos_musculares    CASCADE;
DROP TABLE IF EXISTS usuarios             CASCADE;

CREATE TABLE usuarios (
    id_usuario SERIAL CONSTRAINT pk_usuarios PRIMARY KEY,
    nombre_usuario VARCHAR(50) NOT NULL,
    apellido_usuario VARCHAR(50) NOT NULL,
    email_usuario VARCHAR(100) NOT NULL,
    edad_usuario NUMERIC(2) NOT NULL CONSTRAINT ck1_usuarios CHECK (edad_usuario BETWEEN 14 AND 80),
    estatura_usuario NUMERIC(3) NOT NULL CONSTRAINT ck2_usuarios CHECK (estatura_usuario BETWEEN 130 AND 250),
    peso_usuario NUMERIC(5,2) NOT NULL CONSTRAINT ck3_usuarios CHECK (peso_usuario BETWEEN 30.00 AND 200.00),
    genero_usuario VARCHAR(10) NOT NULL CONSTRAINT ck4_usuarios CHECK (LOWER(genero_usuario) IN ('masculino', 'femenino', 'otro'))
);

CREATE TABLE grupos_musculares (
    id_grupo SMALLSERIAL CONSTRAINT pk_grupos_musculares PRIMARY KEY,
    nombre_grupo VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE musculos (
    id_musculo SMALLSERIAL CONSTRAINT pk_musculos PRIMARY KEY,
    nombre_musculo VARCHAR(100) NOT NULL,
    id_grupo_muscular SMALLINT NOT NULL,
    FOREIGN KEY (id_grupo_muscular) REFERENCES grupos_musculares(id_grupo)
);

CREATE TABLE ejercicios (
    id_ejercicio SMALLSERIAL PRIMARY KEY,
    nombre_ejercicio VARCHAR(100) NOT NULL UNIQUE,
    descripcion_ejercicio VARCHAR(500) NOT NULL,
    tipo_ejercicio VARCHAR (50) NOT NULL CONSTRAINT ck_ejercicios CHECK (LOWER(tipo_ejercicio) IN ('casa', 'gimnasio', 'ambos'))
);

CREATE TABLE ejercicios_musculos (
    id_ejercicio SMALLINT NOT NULL,  
    id_musculo   SMALLINT NOT NULL, 
    importancia  VARCHAR(20) NOT NULL CONSTRAINT ck1_ejercicios_musculos CHECK (LOWER(importancia) IN ('principal','secundario','estabilizador')),
    CONSTRAINT pk_ejercicios_musculos PRIMARY KEY (id_ejercicio, id_musculo),
    CONSTRAINT fk1_ejercicios_musculos FOREIGN KEY (id_ejercicio) REFERENCES ejercicios(id_ejercicio) ON DELETE CASCADE,
    CONSTRAINT fk2_ejercicios_musculos FOREIGN KEY (id_musculo) REFERENCES musculos(id_musculo) ON DELETE CASCADE
);

CREATE TABLE rutinas (
    id_rutina       SERIAL CONSTRAINT pk_rutinas PRIMARY KEY,
    nombre_rutina   VARCHAR(100) NOT NULL UNIQUE,
    descripcion     VARCHAR (500) NOT NULL,
    objetivo        VARCHAR(30) CONSTRAINT ck1_rutinas CHECK (LOWER(objetivo) IN ('fuerza', 'hipertrofia', 'resistencia')),
    nivel           VARCHAR(20) NOT NULL CONSTRAINT ck2_rutinas CHECK (LOWER(nivel) IN ('principiante', 'intermedio', 'avanzado')),
    creado_en       TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE ejercicios_en_rutina (
    id_rutina    INT NOT NULL,
    id_ejercicio SMALLINT NOT NULL,   
    series       SMALLINT NOT NULL CONSTRAINT ck1_ejercicios_en_rutina CHECK (series > 0),
    repeticiones SMALLINT NOT NULL CONSTRAINT ck2_ejercicios_en_rutina CHECK (repeticiones > 0),
    descanso_seg SMALLINT CONSTRAINT ck3_ejercicios_en_rutina CHECK (descanso_seg IS NULL OR descanso_seg >= 0),            
    orden_ejercicio SMALLINT CONSTRAINT ck4_ejercicios_en_rutina CHECK (orden_ejercicio IS NULL OR orden_ejercicio > 0),
    intensidad VARCHAR(100) CONSTRAINT ck5_ejercicios_en_rutina CHECK (LOWER(intensidad) IN ('baja', 'media', 'alta')),
    CONSTRAINT pk_ejr PRIMARY KEY (id_rutina, id_ejercicio),
    CONSTRAINT fk1_ejercicios_en_rutina FOREIGN KEY (id_rutina)
        REFERENCES rutinas(id_rutina) ON DELETE CASCADE,
    CONSTRAINT fk2_ejercicios_en_rutina FOREIGN KEY (id_ejercicio)
        REFERENCES ejercicios(id_ejercicio)
);

### Posibles tablas utiles, contendrían la información de registro de las sesiones de entrenamiento, progreso del usuario, rendimiento del ejercicio

-- =========================================================
-- TABLAS COMPLEMENTARIAS PARA SEGUIMIENTO Y REPORTES
-- =========================================================

-- Tabla para registrar cada sesión de entrenamiento realizada
CREATE TABLE sesiones_entrenamiento (
    id_sesion SERIAL CONSTRAINT pk_sesiones PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_rutina INT NOT NULL,
    fecha_sesion DATE NOT NULL DEFAULT CURRENT_DATE,
    hora_inicio TIME,
    duracion_minutos SMALLINT CONSTRAINT ck1_sesiones CHECK (duracion_minutos > 0),
    calorias_estimadas SMALLINT CONSTRAINT ck2_sesiones CHECK (calorias_estimadas > 0),
    estado_animo VARCHAR(20) CONSTRAINT ck3_sesiones CHECK (LOWER(estado_animo) IN ('excelente', 'bueno', 'regular', 'malo')),
    nivel_energia VARCHAR(20) CONSTRAINT ck4_sesiones CHECK (LOWER(nivel_energia) IN ('alto', 'normal', 'bajo')),
    notas TEXT,
    creado_en TIMESTAMP NOT NULL DEFAULT NOW(),
    
    CONSTRAINT fk1_sesiones FOREIGN KEY (id_usuario) 
        REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
    CONSTRAINT fk2_sesiones FOREIGN KEY (id_rutina) 
        REFERENCES rutinas(id_rutina)
);

-- Tabla para el progreso físico del usuario
CREATE TABLE progreso_usuario (
    id_progreso SERIAL CONSTRAINT pk_progreso PRIMARY KEY,
    id_usuario INT NOT NULL,
    fecha_medicion DATE NOT NULL DEFAULT CURRENT_DATE,
    peso_actual NUMERIC(5,2) CONSTRAINT ck1_progreso CHECK (peso_actual BETWEEN 30.00 AND 300.00),
    
    -- Medidas corporales en centímetros
    medida_cuello NUMERIC(4,1) CONSTRAINT ck2_progreso CHECK (medida_cuello BETWEEN 20.0 AND 60.0),
    medida_pecho NUMERIC(4,1) CONSTRAINT ck3_progreso CHECK (medida_pecho BETWEEN 60.0 AND 180.0),
    medida_cintura NUMERIC(4,1) CONSTRAINT ck4_progreso CHECK (medida_cintura BETWEEN 50.0 AND 150.0),
    medida_cadera NUMERIC(4,1) CONSTRAINT ck5_progreso CHECK (medida_cadera BETWEEN 70.0 AND 180.0),
    medida_brazo_derecho NUMERIC(4,1) CONSTRAINT ck6_progreso CHECK (medida_brazo_derecho BETWEEN 15.0 AND 70.0),
    medida_brazo_izquierdo NUMERIC(4,1) CONSTRAINT ck7_progreso CHECK (medida_brazo_izquierdo BETWEEN 15.0 AND 70.0),
    medida_muslo_derecho NUMERIC(4,1) CONSTRAINT ck8_progreso CHECK (medida_muslo_derecho BETWEEN 30.0 AND 100.0),
    medida_muslo_izquierdo NUMERIC(4,1) CONSTRAINT ck9_progreso CHECK (medida_muslo_izquierdo BETWEEN 30.0 AND 100.0),
    
    -- Métricas adicionales
    porcentaje_grasa NUMERIC(4,1) CONSTRAINT ck10_progreso CHECK (porcentaje_grasa BETWEEN 3.0 AND 50.0),
    masa_muscular_kg NUMERIC(4,1) CONSTRAINT ck11_progreso CHECK (masa_muscular_kg BETWEEN 10.0 AND 100.0),
    
    -- Datos subjetivos
    nivel_satisfaccion SMALLINT CONSTRAINT ck12_progreso CHECK (nivel_satisfaccion BETWEEN 1 AND 10),
    notas TEXT,
    foto_referencia VARCHAR(255), -- ruta de la foto
    
    creado_en TIMESTAMP NOT NULL DEFAULT NOW(),
    
    CONSTRAINT fk1_progreso FOREIGN KEY (id_usuario) 
        REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
    CONSTRAINT uk_progreso_usuario_fecha UNIQUE (id_usuario, fecha_medicion)
);

-- Tabla para registrar el rendimiento en ejercicios específicos
CREATE TABLE rendimiento_ejercicio (
    id_rendimiento SERIAL CONSTRAINT pk_rendimiento PRIMARY KEY,
    id_sesion INT NOT NULL,
    id_ejercicio SMALLINT NOT NULL,
    serie_numero SMALLINT NOT NULL CONSTRAINT ck1_rendimiento CHECK (serie_numero > 0),
    repeticiones_realizadas SMALLINT NOT NULL CONSTRAINT ck2_rendimiento CHECK (repeticiones_realizadas >= 0),
    peso_utilizado NUMERIC(5,2) CONSTRAINT ck3_rendimiento CHECK (peso_utilizado >= 0),
    tiempo_descanso_seg SMALLINT CONSTRAINT ck4_rendimiento CHECK (tiempo_descanso_seg >= 0),
    dificultad_percibida SMALLINT CONSTRAINT ck5_rendimiento CHECK (dificultad_percibida BETWEEN 1 AND 10),
    notas VARCHAR(200),
    
    CONSTRAINT fk1_rendimiento FOREIGN KEY (id_sesion) 
        REFERENCES sesiones_entrenamiento(id_sesion) ON DELETE CASCADE,
    CONSTRAINT fk2_rendimiento FOREIGN KEY (id_ejercicio) 
        REFERENCES ejercicios(id_ejercicio)
);

-- Tabla para objetivos del usuario
CREATE TABLE objetivos_usuario (
    id_objetivo SERIAL CONSTRAINT pk_objetivos PRIMARY KEY,
    id_usuario INT NOT NULL,
    tipo_objetivo VARCHAR(30) NOT NULL CONSTRAINT ck1_objetivos 
        CHECK (LOWER(tipo_objetivo) IN ('peso', 'masa_muscular', 'fuerza', 'resistencia', 'medida_corporal')),
    descripcion VARCHAR(200) NOT NULL,
    valor_objetivo NUMERIC(6,2), -- valor numérico del objetivo
    unidad_medida VARCHAR(20), -- kg, cm, minutos, etc.
    fecha_inicio DATE NOT NULL DEFAULT CURRENT_DATE,
    fecha_limite DATE,
    estado VARCHAR(20) NOT NULL DEFAULT 'activo' CONSTRAINT ck2_objetivos 
        CHECK (LOWER(estado) IN ('activo', 'completado', 'pausado', 'cancelado')),
    fecha_completado DATE,
    
    CONSTRAINT fk1_objetivos FOREIGN KEY (id_usuario) 
        REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
    CONSTRAINT ck3_objetivos CHECK (fecha_limite IS NULL OR fecha_limite > fecha_inicio)
);
