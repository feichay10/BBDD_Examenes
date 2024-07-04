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

## 1. Escribe en álgebra relacional las siguientes consultas:
```sql
A = B = DISPONIBILIDAD
```

a) Vehiculos que estan disponibles simultáneamente en al menos 2 oficinas.
```sql
P(M) S((A.M = B.M) ^ (A.CO != B.CO)) (A x B)
```

b) Clientes que han alquilado los vehiculos M1 y M2 en una misma oficina.
```sql
P(DNI) S((A.M = 'M1') ^ (B.M = 'M2') ^ (A.CO = B.CO)) (A x B)
```

Una alternativa puede ser:
```sql
A = P(DNI) S(M = 'M1') (ALQUILERES)
B = P(DNI) S(M = 'M2') (ALQUILERES)
P(DNI) (A ∩ B)
```

c) Oficina que alquila el vehículo M1 con menor precio
```sql
A = B = S(M = 'M1') (DISPONIBILIDAD)
C = P(CO) S((A.CO != B.CO) ^ (A.PR > B.PR)) (A x B)
P(CO) (A) - C
```

d) Clientes que han alquilado el menos un vehiculo de cada categoria.
```sql
A = P(DNI, CAT) (ALQUILERES * COCHES)
B = P(DNI) (ALQUILERES)
P(DNI) (A / B)
```

e) Clientes que han alquilado en alguna oficina todos los vehiculos de alguna categoria.\
**Formula**: $R(RA \ - \ RA (R \ \times \ TA - RTA))$

```sql
R = DNI
T = M
A = CAT

P(DNI) (P(DNI, CAT)(ALQUILERES * COCHES) - P(DNI, CAT) (C))
C = P(DNI) (ALQUILERES) x P(M, CAT) (ALQUILERES * COCHES) - P(DNI, M, CAT) (ALQUILERES * COCHES)
```

## 2. Responder en cálculo relacional de t-uplas y de dominio a las siguientes consultas:
a) Clientes que han alquilado al menos 2 vehículos distintos en una misma oficina.
* CRT:
  ```sql
  dom(a) = dom(a´) = ALQUILERES
  {t1 | (∃a) (t[DNI] = a[DNI]) ^
       ¬(∃a´) ^ (a´[DNI] = a[DNI]) ^ (a´[M] != a[M]) ^ (a´[CO] = a[CO])}
  ```

* CRD:
  ```sql
  {<DNI> | (∃CO, M, N, F) (<DNI, CO, M, N, F> ∈ ALQUILERES) ^
           (∃CO´, M´, N´, F) (<DNI, CO´, M´, N´, F´> ∈ ALQUILERES) ^
            (CO = CO´) ^ (M != M´)}
  ```

b) Vehiculos  que sólo estan en la oficina O1.
* CRT:
  ```sql
  dom(d) = dom(d´) = DISPONIBILIDAD
  {t1 | (∃d) (t[M] = d[M]) ^
        ¬(∃d´) (d´[M] = d[M]) ^ (d´[CO] != 'O1')}
  ```

* CRD:
  ```sql
  {<M> | (∃CO, PR) (<M, O1, PR> ∈ DISPONIBILIDAD) ^
        ¬(∀CO, PR´) (<M, CO, PR´> ∈ DISPONIBILIDAD) ^ (CO != O1)}
  ```

c) Vehículo más económico en la oficina O1.
* CRT:
  ```sql
  dom(d) = dom(d´) = DISPONIBILIDAD
  {t1 | (∃d) (t[M] = d[M]) ^ (d[CO] = 'O1') ^
       ¬(∃d´) (d[PR] < d´[PR]) ^ (d[CO] = 'O1')}
  ```

* CRD:
  ```sql
  {<M> | (∃PR) (<M, O1, PR> ∈ DISPONIBILIDAD) ^
        ¬(∃M´, PR´) (<M´, O1, PR´> ∈ DISPONIBILIDAD) ^ (PR´ < PR)}
  ```
  
d) Clientes que han alquilado al menos un vehículo en cada oficina.
* CRT:
  ```sql
  dom(a) = dom(a´) = dom(a´´) = ALQUILERES
  {t1 | (∃a) (t[DNI] = a[DNI]) ^
        (∀a´) ((∃a´´) (a´´[DNI] = a[DNI]) ^ (a´´[CO] = a´[CO]))}
  ```

* CRD:
  ```sql
  {<DNI> | (∃CO, M, N, F) (<DNI, CO, M, N, F> ∈ ALQUILERES) ^
           (∀DNI´, CO´, M´, N´, F´) ((<DNI´, CO´, M´, N´, F´> ∈ ALQUILERES) v 
           (∃M´´, N´´, F´´) (<DNI, CO´, M´´, N´´, F´´> ∈ ALQUILERES))}
  ```

e) Oficinas que en un mismo día han alquilado al menos un vehículo de cada una de las categorías de las que disponen.
* CRT:
  ```sql
  dom(a) = dom(a´) = ALQUILERES; dom(c) = dom(c´) = COCHES
  {t1 | (∃a) (t[CO] = a[CO]) ^
        (∀c) ((∃a´, c´) (a´[F] = a[F]) ^ (a´[CO] = a[CO]) ^ (c´[CAT] = c[CAT]) ^ (a´[M] = c´[M]))}
  ```

## 3. Responder en SQL a las siguientes consultas:
a) Número de vehículos de la categoria C1 disponibles en la oficina O1.
```sql
SELECT COUNT(*)
FROM DISPONIBILIDAD
WHERE CAT = 'C1' AND CO = 'O1'
```

b) Importe medio total pagado por los clientes de la oficina O1.
```sql
SELECT AVG(SUM(PR))
FROM DISPONIBILIDAD NATURAL JOIN ALQUILERES
WHERE CO = 'O1'
GROUP BY DNI
```

c) Clientes que siempre alquilan vehiculos de la categoria C1.
```sql
SELECT DNI
FROM ALQUILERES NATURAL JOIN COCHES
GROUP BY DNI, CAT
HAVING COUNT(DISTINCT CAT) = 1 AND CAT = 'C1'
```

d) Oficinas que en un mismo dia han alquilado todos sus vehiculos disponibles.
```sql
SELECT CO
FROM ALQUILERES A1
GROUP BY CO, F
HAVING COUNT(DISTINCT M) = (SELECT COUNT(*)
                            FROM DISPONIBILIDAD D1
                            WHERE D1.CO = A1.CO)
```

e) Oficinas tales que al menos el 40% de sus vehículos disponibles son de una misma categoría.
```sql
SELECT CO
FROM DISPONIBILIDAD NATURAL JOIN COCHES AS DC
GROUP BY CO, CAT
HAVING COUNT(*) >= 0.4 * (SELECT COUNT(*)
                          FROM DISPONIBILIDAD D1
                          WHERE D1.CO = DC.CO)
```