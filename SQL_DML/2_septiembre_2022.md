# Examen 2 de Septiembre de 2022

Una agencia de vehiculos de alquiler tiene un base de datos para gestionar los vehículos que alquila en sus diversas oficinas. En el esquema de base de datos utilizado los atributos se abrevian según el siguiente convenio:

| Atributos | Significado                         |
| --------- | ----------------------------------- |
| CAT       | Categoria del vehiculo              |
| CO        | Código de la oficina de alquiler   |
| DNI       | DNI del cliente                     |
| F         | Fecha de alquiler                   |
| M         | Matricula del vehiculo              |
| N         | Numero de dias del alquiler         |
| PR        | Precio diario en Euros del alquiler |

Las tablas utilizadas son:

**COCHES** (M, CAT)\
**SIGNIFICADO**: El vehiculo con matricula M es de la categoria CAT.\
**CLAVE PRIMARIA**: (M)

**DISPONIBILIDAD** (M, CO, PR)\
**SIGNIFICADO**: El coche con matricula M está en la oficina CO a un precio de PR euros diarios.\
**CLAVE PRIMARIA**: (M, CO)\
**CLAVE AJENA**: (M)

**ALQUILERES** (DNI, CO, M, N, F)\
**SIGNIFICADO**: El cliente con DNI ha alquilado en la oficina CO el vehiculo con matricula M, en la fecha F, durante N dias.\
**CLAVE PRIMARIA**: (M, F)\
**CLAVE AJENA**: (M, CO)

## 3. Responder en SQL a las siguientes consultas:
a) Número de vehículos de la categoría C1 disponibles en la oficina O1
```sql
SELECT COUNT(M)
FROM DISPONIBILIDAD NATURAL JOIN COCHES
WHERE (CO = 'O1') AND (CAT = 'C1');
```

b) Importe medio total pagado por los clientes de la oficina 01.
```sql
SELECT AVG(PR * N)
FROM DISPONIBILIDAD NATURAL JOIN ALQUILERES
WHERE CO = 'O1';
```

c) Clientes que siempre alquilan vehiculos de la categoría C1.
```sql
SELECT DNI
FROM ALQUILERES
WHERE M NOT IN (
  SELECT M
  FROM COCHES
  WHERE CAT != 'C1'
);
```

d) Oficinas que un mismo día han alquilado todos sus vehiculos disponibles.
```sql
SELECT CO, F
FROM ALQUILERES A
WHERE NOT EXISTS (
    SELECT D.M
    FROM DISPONIBILIDAD D
    WHERE D.CO = A.CO AND D.M NOT IN (
        SELECT M
        FROM ALQUILERES
        WHERE CO = A.CO AND F = A.F
    )
)
GROUP BY CO, F;
```

e) Oficinas tales que al menos el 40% de sus vehículos disponibles son de una misma categoría.
```sql
SELECT CO
FROM DISPONIBILIDAD NATURAL JOIN COCHES AS DC
GROUP BY CO, CAT
HAVING COUNT(*) >= 0.4 * (SELECT COUNT(*)
                          FROM DISPONIBILIDAD D
                          WHERE D.CO = DC.CO);
```

f) Vehículo más económico en la oficina O1.
```sql
SELECT M
FROM DISPONIBILIDAD
WHERE CO = 'O1' AND PR = (
  SELECT MIN(PR) 
  FROM DISPONIBILIDAD 
  WHERE CO = 'O1'
);
```

## 4. Responder en SQL a las siguientes peticiones:
a) Crea una vista que indique para cada cliente y cada vehículo alquilado, el coste total abonado en la fecha de alquiler.
```sql
CREATE VIEW vista1 AS (
  SELECT DNI, M, F, PR * N AS COSTE_TOTAL
  FROM ALQUILERES NATURAL JOIN DISPONIBILIDAD
  GROUP BY DNI, M, F
);
```

b) Bonifica un 10% el precio de alquiler de los vehículos de la categoría C1.
```sql
UPDATE DISPONIBILIDAD
SET PR = PR + (PR * 0.1)
WHERE M IN (SELECT M
            FROM COCHES
            WHERE CAT = 'C1');
```

c) Impón a partir de ahora el número mínimo de días de alquiler de los vehiculos de la categoría C1 sea de 2 días en cualquier oficina.
```sql
CREATE OR REPLACE TRIGGER trg_min_dias_c1
BEFORE INSERT OR UPDATE ON ALQUILERES
REFERENCING NEW AS new
FOR EACH ROW
BEGIN
  IF :new.M IN (
    SELECT M
    FROM COCHES
    WHERE CAT = 'C1'
  ) AND :new.N < 2 THEN
    RAISE_APPLICATION_ERROR(-20001, 'El número mínimo de días de alquiler de los vehiculos de la categoría C1 es de 2 días.');
  END IF;
END;
/
```

d) Evita que los precios de alquiler de un mismo vehículo puedan variar según la oficina.
```sql
CREATE OR REPLACE TRIGGER trg_mismo_precio
BEFORE INSERT OR UPDATE ON DISPONIBILIDAD
FOR EACH ROW
DECLARE
    v_precio NUMBER;
BEGIN
    -- Obtener el precio del vehículo en la primera oficina (si existe)
    SELECT PR INTO v_precio
    FROM DISPONIBILIDAD
    WHERE M = :NEW.M AND ROWNUM = 1;

    -- Comprobar si el nuevo precio coincide con el precio existente
    IF v_precio IS NOT NULL AND :NEW.PR != v_precio THEN
        RAISE_APPLICATION_ERROR(-20001, 'El precio de alquiler de un vehículo no puede variar según la oficina.');
    END IF;
END;
/
```

e) Impide que un mismo vehículo pueda volver a alquilarse mientras permanece alquilado.
```sql
ALTER TABLE ALQUILERES
ADD CONSTRAINT vehiculo_no_alquilado CHECK (
  (M, F) NOT IN (
    SELECT M, F
    FROM ALQUILERES
    GROUP BY M, F
    HAVING COUNT(*) > 1
  )
);
```