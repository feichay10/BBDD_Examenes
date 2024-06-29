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
**COCHES** (M, CAT)
**SIGNIFICADO**: El vehiculo con matricula M es de la categoria CAT.
**CLAVE PRIMARIA**: (M)

**DISPONIBILIDAD** (M, CO, PR)
**SIGNIFICADO**: El coche con matricula M está en la oficina CO a un precio de PR euros diarios.
**CLAVE PRIMARIA**: (M, CO)
**CLAVE AJENA**: (M)

**ALQUILERES** (DNI, CO, M, N, F)
**SIGNIFICADO**: El cliente con DNI ha alquilado en la oficina CO el vehiculo con matricula M, en la fecha F, durante N dias.
**CLAVE PRIMARIA**: (M, F)
**CLAVE AJENA**: (M, CO)

1) Escribe en álgebra relacional las siguientes consultas:
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
```

e) Clientes que han alquilado en alguna oficina todos los vehiculos de alguna categoria.
```sql
```