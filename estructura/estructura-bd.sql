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
