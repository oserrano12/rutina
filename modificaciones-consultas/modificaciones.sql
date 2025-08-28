ALTER TABLE grupos_musculares
ADD COLUMN bloque_funcional VARCHAR(50) NOT NULL CONSTRAINT ck_grupo_muscular CHECK (LOWER(bloque_funcional) IN ('tren superior', 'tren inferior', 'core / abdomen'));

ALTER TABLE ejercicios
DROP COLUMN instrucciones,
ALTER COLUMN equipo_necesario TYPE VARCHAR(50),
ADD COLUMN url_imagen VARCHAR(300),
ADD CONSTRAINT ck_equipo_necesario CHECK (
    LOWER(equipo_necesario) IN (
        'ninguno',
        'mancuerna',
        'barra',
        'banda elastica',
        'silla',
        'banco',
        'kettlebell',
        'maquina',
        'cuerda',
        'otros'
    )
);
