# Peticiones SQL Oracle - DDL
## Crear y borrar vistas
- Creación de una vista:
  ```sql
  CREATE VIEW nombre_vista AS (
    subconsulta
  );
  ```

- Borrado de una vista:
  ```sql
  DROP VIEW nombre_vista;
  ```

## Modificación de la estructura de una tabla
- Tipos de datos en SQL:
  - `CHAR(n)`: Cadena de caracteres de longitud fija.
  - `VARCHAR(n)`: Cadena de caracteres de longitud variable.
  - `INT`: Número entero.
  - `FLOAT`: Número decimal.
  - `DATE`: Fecha.
  - `TIME`: Hora.
  - `TIMESTAMP`: Fecha y hora.
  - `BOOLEAN`: Valor booleano.
  - `BLOB`: Datos binarios.

- Añadir columnas a la estructura de una tabla:
  ```sql
  ALTER TABLE nombre_tabla
  ADD COLUMN nombre_columna tipo_dato;
  ```

- Modificar columnas de una tabla:
  ```sql
  ALTER TABLE nombre_tabla
  MODIFY nombre_columna tipo_dato;
  ```

- Eliminar columna de una tabla:
  ```sql
  ALTER TABLE nombre_tabla
  DROP COLUMN nombre_columna;
  ```

- Eliminar clave primaria de una tabla:
  ```sql
  ALTER TABLE nombre_tabla
  DROP PRIMARY KEY;
  ```

- Modificar clave primaria de una tabla:
  ```sql
  ALTER TABLE nombre_tabla
  DROP PRIMARY KEY;

  ALTER TABLE nombre_tabla
  ADD PRIMARY KEY (nombre_columna);
  ```

- Añadir una restriccion a una tabla:
  ```sql
  ALTER TABLE nombre_tabla
  ADD CONSTRAINT nombre_restriccion
  CHECK NOT EXISTS (condicion);
  ```

  ```sql
  ALTER TABLE nombre_tabla
  ADD CONSTRAINT nombre_restriccion
  CHECK (condicion);
  ```

- Añadir clave foránea a una tabla:
  ```sql
  ALTER TABLE nombre_tabla
  ADD FOREIGN KEY (nombre_columna)
  REFERENCES nombre_tabla_referencia (nombre_columna_referencia);
  ```

- Añadir condición de integridad referencial a una tabla:
  ```sql
  ALTER TABLE nombre_tabla
  ADD CONSTRAINT nombre_restriccion
  FOREIGN KEY (nombre_columna)
  REFERENCES nombre_tabla_referencia (nombre_columna_referencia)
  ON DELETE CASCADE;
  ```

- Eliminar clave foránea de una tabla:
  ```sql
  ALTER TABLE nombre_tabla
  DROP FOREIGN KEY nombre_clave_foranea;
  ```

- Eliminar restricción de una tabla:
  ```sql
  ALTER TABLE nombre_tabla
  DROP CONSTRAINT nombre_restriccion;
  ```

- Poner por defecto un valor en una columna:
  ```sql
  ALTER TABLE nombre_tabla
  ALTER COLUMN nombre_columna
  SET DEFAULT valor;
  ```

## Insertar y borrar filas de una tabla
- Insertar una fila en una tabla:
  ```sql
  INSERT INTO nombre_tabla (columna1, columna2, ...)
  VALUES (valor1, valor2, ...);
  ```

- Borrar una fila de una tabla:
  ```sql
  DELETE FROM nombre_tabla
  WHERE condicion;
  ```

## Modificacion de filas de una tabla
- Modificar una fila de una tabla:
  ```sql
  UPDATE nombre_tabla
  SET columna1 = valor1, columna2 = valor2, ...
  WHERE condicion || subconsulta;
  ```

## Creación de una aserción o asertos
Las aserciones o asertos son condiciones que se pueden definir para una tabla o varias tablas, y que deben cumplirse en todo momento. Expresan una condición que habitualmente afecta a varias tablas. Es como el ALTER TABLE pero para varias tablas.

- Creación de una aserción:
  ```sql
  CREATE ASSERTION nombre_asercion
  CHECK (condicion);
  ```

## Triggers o disparadores
Los triggers o disparadores son procedimientos almacenados que se ejecutan automáticamente cuando se produce un evento en una tabla.

- Creación de un trigger:
  ```sql
  CREATE [OR REPLACE] TRIGGER nombre_trigger
  {BEFORE | AFTER} {DELETE | INSERT | UPDATE} [OF col1, col2, ...coln] ON nombre_tabla
  [REFERENCING {NEW | OLD} [AS] new | old]
  [FOR EACH ROW [WHEN (condicion)]]
  [DECLARE]
  
    -- VARIABLES LOCALES
  BEGIN
    -- CODIGO DEL TRIGGER
    -- Consulta
  [EXCEPTION]
    -- MANEJO DE ERRORES
  END;
  /
  ```

  Ejemplo de trigger, fuerza a que si un dispositivo pasa a un estado "inactivo" su velocidad de transmisión sea NULL:
  ```sql
  CREATE TRIGGER trigger1
  AFTER UPDATE OF E ON REDES
  REFERENCING NEW AS new
  FOR EACH ROW
  WHEN :new.E = 'inactivo'
  BEGIN
    UPDATE REDES
    SET V = NULL
    WHERE (IR = :new.IR) AND (ID = :new.ID)
  END;
  /
  ```

  Ejemplo de trigger: Garantiza que el número de unidades cambiadas de un componente para un aparato, un mismo día, es menor o igual al número de unidades que tiene el aparato de ese componente.
  ```sql
  CREATE TRIGGER CheckUnidadesCambiadas
  BEFORE INSERT OR UPDATE ON REPARACIONES
  FOR EACH ROW
  DECLARE
    unidadesDisponibles INT;
  BEGIN
    -- Obtener el número de unidades del componente en el aparato
    SELECT N INTO unidadesDisponibles
    FROM APARATOS
    WHERE IA = :new.IA AND IC = :new.IC;

    -- Verificar que las unidades cambiadas (NS) no excedan las unidades disponibles
    IF :new.NS > unidadesDisponibles THEN
      RAISE_APPLICATION_ERROR(-20001, 'El número de unidades cambiadas no puede ser mayor que el número de unidades del aparato.');
    END IF;
  END;
  /
  ```

- Borrar un trigger:
  ```sql
  DROP TRIGGER nombre_trigger;
  ```

## Crear y eliminar tablas
- Creación de una tabla:
  ```sql
  CREATE TABLE nombre_tabla (
    columna1 tipo_dato [NOT NULL],
    columna2 tipo_dato [NOT NULL],
    ...
    PRIMARY KEY (columna1),
    FOREIGN KEY (columna2) REFERENCES nombre_tabla_referencia (columna_referencia)
  );
  ```

- Borrar una tabla:
  ```sql
  DROP TABLE nombre_tabla;
  ```

## Crear y eliminar índices
- Creación de un índice:
  ```sql
  CREATE INDEX nombre_indice
  ON nombre_tabla (columna);
  ```

- Borrar un índice:
  ```sql
  DROP INDEX nombre_indice;
  ```

## Esquema de una tabla
- Mostrar el esquema de una tabla:
  ```sql
  DESCRIBE nombre_tabla;
  ```

## Punto de control, retroceder puntos de control y confirmar cambios
- Crear un punto de control:
  ```sql
  SAVEPOINT nombre_punto_control;
  ```

- Retroceder a un punto de control:
  ```sql
  ROLLBACK TO nombre_punto_control;
  ```

- Confirmar cambios:
  ```sql
  COMMIT WORK;
  ```

## Dar y quitar permisos a un usuario
- Dar permisos a un usuario:
  ```sql
  GRANT {SELECT | INSERT(columna) | UPDATE(columna) | DELETE | ALL}
  ON nombre_tabla || nombre_vista
  TO nombre_usuario;
  ```

- Quitar permisos a un usuario:
  ```sql
  REVOKE {SELECT | INSERT | UPDATE | DELETE | ALL}
  ON nombre_tabla || nombre_vista
  FROM nombre_usuario;
  ```

