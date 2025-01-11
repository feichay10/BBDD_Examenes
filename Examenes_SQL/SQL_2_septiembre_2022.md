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

# 3. Responder en SQL a las siguientes consultas:
a) Número de vehículos de la categoría C1 disponibles en la oficina O1.
```sql
SELECT COUNT(M)
FROM COCHES NATURAL JOIN DISPONIBILIDAD
WHERE (CAT = 'C1') AND (CO = 'O1');
```

b) Importe medio total pagado por los clientes de la oficina O1.
```sql
SELECT AVG(SUM(PR))
FROM DISPONIBILIDAD NATURAL JOIN ALQUILERES 
WHERE CO = 'O1'
GROUP BY DNI;
```

c) Clientes que siempre alquilan vehículos de la categoría C1.
```sql
SELECT DNI
FROM ALQUILERES
WHERE M IN (SELECT M
            FROM COCHES
            WHERE CAT = 'C1')
```

Otra forma de hacerlo:
```sql
SELECT DNI
FROM ALQUILERES NATURAL JOIN COCHES
GROUP BY DNI
HAVING COUNT(DISTINCT CAT) = 1 AND CAT = 'C1';
```

d) Oficinas que en un mismo día han alquilado todos sus vehículos.
```sql
SELECT CO
FROM ALQUILERES
GROUP BY CO, F
HAVING COUNT(DISTINCT M) = (SELECT COUNT(DISTINCT M)
                            FROM DISPONIBILIDAD
                            WHERE CO = ALQUILERES.CO);
```

e) Oficinas tales que al menos el 40% de sus vehículos disponibles son de una misma categoría.
```sql
