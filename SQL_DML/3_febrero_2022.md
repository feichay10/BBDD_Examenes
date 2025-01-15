# 3 de Febrero de 2022

Una empresa organizadora de carreras tiene una base de datos para gestionar las competiciones que ofrece. En el esquema de base de datos utilziado los atributos se abrevian según el siguiente convenio:

| Atributo | Significado                                                                      |
| -------- | -------------------------------------------------------------------------------- |
| CDC      | Ciudad donde se realiza la carrera                                               |
| D        | Distancia en kilómetros de una carrera: 10.000, 21.097, ...                     |
| DNI      | DNI de la persona                                                                |
| F        | Fecha de la carrera: '15-05-2020', '04-12-2021', ...                             |
| IC       | Identificador de carrera: I1, I2, ...                                            |
| PR       | Precio en Euros de la inscripción en una carrera                                |
| S        | Sexo: Hombre o Mujer                                                             |
| T        | Tiempo en minutos que una persona invirtió en una carrera. Nulo si no la acabó |

Las tabla utilizadas son:
**PERSONAS** (DNI, S)\
**SIGNIFICADO**: La persona con DNI es de sexo S.\
**CLAVE PRIMARIA**: (DNI)

**CARRERAS** (IC, CDC, F, D, PR)\
**SIGNIFICADO**: La prueba IC se celebra en la ciudad CDC, en la fecha F, tiene un distancia D kilómetros y el precio de la inscripción es de PR euros.\
**CLAVE PRIMARIA**: (IC)

**PARTICIPACIONES** (DNI, IC, T)\
**SIGNIFICADO**: La persona con DNI, participó en la carrera IC e hizo un tiempo de T minutos. Si el valor de T es nulo la persona no terminó la carrera.\
**CLAVE PRIMARIA**: (DNI, IC) **CLAVES AJENAS**: (DNI), (IC)

## 3. Responder en SQL las siguientes consultas:
a) Número de corredores que han terminado la competición I1.
```sql
SELECT COUNT(DNI)
FROM PARTICIPANTES
WHERE IC = I1 AND T IS NOT NULL;
``` 

b) Mostrar para cada carrera el mejor tiempo realizado.
```sql
SELECT IC, MIN(T)
FROM PARTICIPANTES
GROUP BY IC;
```

c) Corredores que siempre que participan en una carrera la terminan.
```sql
SELECT DISTINCT DNI
FROM PARTICIPANTES
WHERE T IN (
  SELECT T
  FROM PARTICIPANTES
  WHERE T IS NOT NULL
);
```

d) Ciudad en la que se han organizado el mayor número de carreras.
```sql
SELECT CDC
FROM CARRERAS
GROUP BY CDC
HAVING COUNT(*) = (
  SELECT MAX(COUNT(*))
  FROM CARRERAS
  GROUP BY CDC
)
```

e) Carreras tales que al menos el 30% de sus participantes son mujeres.
```sql
SELECT IC
FROM PARTICIPANTES NATURAL JOIN PERSONAS
WHERE S = 'Mujer'
GROUP BY IC
HAVING COUNT(DISTINTC DNI) >= 0.3 * (
  SELECT COUNT(DISTINCT DNI)
  FROM PERSONAS
);
```

## 4. Responder en SQL a las siguientes peticiones:
a) Crea una vista que muestre para cada corredores y cada carrera en la que haya participado el tiempo medio por km.
```sql
CREATE VIEW vista1 AS (
  SELECT DNI, IC, T / D AS tiempo_medio_por_km
  FROM PARTICIPANTES NATURAL JOIN CARRERAS
  GROUP BY DNI, IC
);
```

b) Elimina las personas que no han participado en ninguna carrera.
```sql
DELETE FROM PERSONAS
WHERE DNI NOT IN (
    SELECT DISTINCT DNI
    FROM PARTICIPACIONES
);
```

c) Impide que los precios de inscripción en cualquier carrera sean superiores a 50 euros.
```sql
ALTER TABLE CARRERAS
ADD CONSTRAINT precio_maximo CHECK NOT EXISTS (
  SELECT *
  FROM CARRERAS
  WHERE PR > 50
);
```

Otra forma de hacerlo sería:
```sql
ALTER TABLE CARRERAS
ADD CONSTRAINT precio_maximo CHECK (PR <= 50);
```

d) Fuerza a que todos los tiempos en una carrera dada sean distintos.
```sql	
CREATE TRIGGER tiempos_distintos
BEFORE INSERT ON PARTICIPANTES
FOR EACH ROW
BEGIN
  IF :new.T IN (
    SELECT T
    FROM PARTICIPANTES
    WHERE IC = :new.IC
  ) THEN
    RAISE_APPLICATION_ERROR(-20001, 'Los tiempos en una carrera deben ser distintos.');
  END IF;
END;
```

e) Impide que una ciudad pueda ofrecer más de 5 carreras en un mismo año.
```sql
ALTER TABLE CARRERAS
ADD CONSTRAINT max_carreras_ciudad CHECK NOT EXISTS (
  SELECT *
  FROM CARRERAS
  GROUP BY CDC, F
  HAVING COUNT(*) > 5
);
```