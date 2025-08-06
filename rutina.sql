DROP TABLE IF EXISTS ejercicios;
DROP TABLE IF EXISTS musculos;
DROP TABLE IF EXISTS usuarios;  

CREATE TABLE usuarios (
    id_usuario NUMERIC(10) NOT NULL CONSTRAINT pk_usuarios PRIMARY KEY,
    nombre_usuario VARCHAR(50) NOT NULL,
    apellido_usuario VARCHAR(50) NOT NULL,
    email_usuario VARCHAR(100) NOT NULL,
    edad_usuario NUMERIC(2) NOT NULL CONSTRAINT ck1_usuarios CHECK (edad_usuario BETWEEN 14 AND 80),
    estatura_usuario NUMERIC(3) NOT NULL CONSTRAINT ck2_usuarios CHECK (estatura_usuario BETWEEN 130 AND 250),
    peso_usuario NUMERIC(3,2) NOT NULL CONSTRAINT ck3_usuarios CHECK (peso_usuario BETWEEN 30.00 AND 200.00),
    genero_usuario VARCHAR(10) NOT NULL CONSTRAINT ck4_usuarios CHECK (genero_usuario IN ('Masculino', 'Femenino', 'Otro'))
);

CREATE TABLE musculos (
    id_musculo NUMERIC(5) NOT NULL CONSTRAINT pk_musculos PRIMARY KEY,
    nombre_musculo VARCHAR(100) NOT NULL
);

CREATE TABLE ejercicios (
    id_ejercicio NUMERIC(5) NOT NULL CONSTRAINT pk_ejercicios PRIMARY KEY,
    nombre_ejercicio VARCHAR(100) NOT NULL,
    descripcion_ejercicio VARCHAR(500) NOT NULL,
    id_musculo NUMERIC(5) NOT NULL,
    CONSTRAINT fk_musculos FOREIGN KEY (id_musculo) REFERENCES musculos(id_musculo)
);

CREATE TABLE grupos_musculares (
    id_grupo NUMERIC(5) NOT NULL CONSTRAINT pk_grupos PRIMARY KEY,
    nombre_grupo VARCHAR(100) NOT NULL,
    id_musculo NUMERIC(5) NOT NULL,
    CONSTRAINT fk_musculos_grupos FOREIGN KEY (id_musculo) REFERENCES musculos(id_musculo
);