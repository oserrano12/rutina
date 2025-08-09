DROP TABLE IF EXISTS usuarios;
DROP TABLE IF EXISTS grupos_musculares;
DROP TABLE IF EXISTS musculos;
DROP TABLE IF EXISTS ejercicios;

CREATE TABLE usuarios (
    id_usuario SERIAL PRIMARY KEY,
    nombre_usuario VARCHAR(50) NOT NULL,
    apellido_usuario VARCHAR(50) NOT NULL,
    email_usuario VARCHAR(100) NOT NULL,
    edad_usuario NUMERIC(2) NOT NULL CONSTRAINT ck1_usuarios CHECK (edad_usuario BETWEEN 14 AND 80),
    estatura_usuario NUMERIC(3) NOT NULL CONSTRAINT ck2_usuarios CHECK (estatura_usuario BETWEEN 130 AND 250),
    peso_usuario NUMERIC(3,2) NOT NULL CONSTRAINT ck3_usuarios CHECK (peso_usuario BETWEEN 30.00 AND 200.00),
    genero_usuario VARCHAR(10) NOT NULL CONSTRAINT ck4_usuarios CHECK (genero_usuario IN ('Masculino', 'Femenino', 'Otro'))
);

CREATE TABLE grupos_musculares (
    id_grupo SERIAL PRIMARY KEY,
    nombre_grupo VARCHAR(100) NOT NULL
);

CREATE TABLE musculos (
    id_musculo SERIAL PRIMARY KEY,
    nombre_musculo VARCHAR(100) NOT NULL,
    id_grupo_muscular INT NOT NULL,
    FOREIGN KEY (id_grupo_muscular) REFERENCES grupos_musculares(id_grupo)
);

CREATE TABLE ejercicios (
    id_ejercicio SERIAL PRIMARY KEY,
    nombre_ejercicio VARCHAR(100) NOT NULL,
    descripcion_ejercicio VARCHAR(500) NOT NULL
);

CREATE TABLE ejercicios_musculos (
    id_ejercicio INT NOT NULL,
    id_musculo INT NOT NULL,
    funcion TEXT,  -- Ej: "principal", "secundario", "estabilizador"
    PRIMARY KEY (id_ejercicio, id_musculo),
    FOREIGN KEY (id_ejercicio) REFERENCES ejercicios(id_ejercicio),
    FOREIGN KEY (id_musculo) REFERENCES musculos(id_musculo)
);
