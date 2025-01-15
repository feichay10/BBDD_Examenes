-- Crear vistas:
CREATE VIEW nombre_vista AS (
  subconsulta
);

-- Eliminar vistas:
DROP VIEW nombre_vista;

-- Añadir columnas a la estructura de una tabla:
ALTER TABLE nombre_tabla
ADD COLUMN nombre_columna tipo_dato();

ALTER TABLE nombre_tabla
[DISABLE | ENABLE] nombre_columna;

-- Eliminar columna de una tabla:
ALTER TABLE nombre_tabla
DROP COLUMN nombre_columna;

-- Eliminar clave primaria o foranea de una tabla:
ALTER TABLE nombre_tabla
DROP [PRIMARY | FOREIGN] KEY;

-- Añadir una restriccion a una tabla:
ALTER TABLE nombre_tabla
ADD CONSTRAINT nombre_constraint
CHECK NOT EXISTS (
  subconsulta
);

ALTER TABLE nombre_tabla
ADD CONSTRAINT nombre_constraint
CHECK (columna IN ());

-- Añadir clave foranea:
ALTER TABLE nombre_tabla
ADD FOREIGN KEY(nombre_columna)
REFERENCES nombre_tabla_referenciada(columna_a_referenciar);

-- Añadir condición de integridad referencial:
ALTER TABLE nombre_tabla
ADD CONSTRAINT nombre_constraint
FOREIGN KEY(columna)
REFERENCES nombre_tabla_referenciada(columna_a_referenciar)
ON DELETE CASCADE;

-- Poner por defecto un valor en una columna:
ALTER TABLE nombre_tabla
ALTER COLUMN nombre_columna
SET DEFAULT valor;

-- Insertar filas en una tabla
INSERT INTO nombre_tabla(columna1, columna2, ... columnaN)
VALUES (valor1, valor2, ... valorN);

-- Eliminar filas en una tabla:
DELETE FROM nombre_tabla
WHERE condicion;

-- Modificacion de filas de una tabla
UPDATE nombre_tabla
SET columna = columna + (columna * X)
WHERE condicion | subconsulta;

-- Triggers
CREATE TRIGGER nombre_trigger
{BEFORE | AFTER} {DELETE | INSERT | UPDATE} [OF col1, col2, col3] ON nombre_tabla
[REFERENCING {OLD AS old_alias | NEW AS new_alias}]
[FOR EACH ROW [WHEN (condicion)]]
[DECLARE]
  -- Variables locales
BEGIN
  -- Consulta
[EXCEPTION]
END;
/