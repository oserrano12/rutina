ALTER TABLE grupos_musculares
ADD COLUMN bloque_funcional VARCHAR(50) NOT NULL CONSTRAINT ck_grupo_muscular CHECK (LOWER(bloque_funcional) IN ('tren superior', 'tren inferior', 'core / abdomen'));