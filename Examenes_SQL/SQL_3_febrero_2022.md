# Examen 3 de febrero 2022

Una empresa organizadora de carreras tiene una base de datos para gestionar las competiciones que ofrece. En el esquema de base de datos utilizado los atributos se abrevian según el siguiente convenio:

| Atributo | Significado                                                                     |
| -------- | ------------------------------------------------------------------------------- |
| CDC      | Ciudad donde se realiza la carrera                                              |
| D        | Distancia en kilómetros de una carrera: 10.000, 21.097                          |
| DNI      | DNI de la persona                                                               |
| F        | Fecha de la carrera                                                             |
| IC       | Identificador de la carrera: I1, I2, ...                                        |
| PR       | Precio en Euros de la inscripción en una carrera                                |
| S        | Sexo: Hombre o Mujer                                                            |
| T        | Tiempo en minutos que una persona invirtió en una carrera. Nulo si no la acabó. |

Las tablas utilizadas son:

**PERSONAS**: (DNI, S)\
**SIGNIFICADO**: La persona con DNI es de sexo S.\
**CP**: (DNI)

**CARRERAS**: (IC, CDC, F, D, PR)\
**SIGNIFICADO**: La prueba IC se celebra en la ciudad CDC, en la fecha F, tiene una distancia D kilometros y el precio de la inscripción es PR euros.\
**CP**: (IC)

**PARTICIPANTES**: (DNI, IC, T)\
**SIGNIFICADO**: La persona con DNI, participó en la carrera IC e hizo un tiempo de T minutos. Si el valor T es nulo la persona no terminó la carrera.\
**CP**: (DNI, IC)
**CA**: (DNI), (IC)

## 3. Responder en SQL a las siguientes consultas:
a) Número de corredores que han terminado la competición I1.
```sql
SELECT COUNT(DNI)
FROM PARTICIPANTES
WHERE (IC = 'I1') AND (T IS NOT NULL);
```

b) Mostrar para cada carrera el mejor tiempo realizado.
```sql
SELECT IC, MIN(T)
FROM PARTICIPANTES
GROUP BY IC;
```

c) Corredores que siempre que participan en una carrera la terminan.
```sql
SELECT DISTINCT(DNI)
FROM PARTICIPANTES
WHERE DNI IN (
      SELECT DNI 
      FROM PARTICIPANTES
      WHERE T IS NOT NULL
);
```

d) Ciudad en la que se han organizado el mayor número de carreras.
```sql
SELECT CDC
FROM CARRERAS


```

e) Carreras tales que al menos el 30% de sus participantes son mujeres.
