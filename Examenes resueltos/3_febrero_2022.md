# Examen 3 de febrero 2022

<<<<<<< HEAD
Una empresa organizadora de carreras tiene una base de datos para gestionar las competiciones que ofrece. En el esquema de base de datos utilizado los atributos se abrevían según el siguiente convenio:

| Atributo | Significado                                                                    |
| -------- | ------------------------------------------------------------------------------ |
| CDC      | Ciudad donde se realiza la carrera                                             |
| D        | Distancia en kilometros de una carrera: 10.000, 21.097                         |
| DNI      | DNI de la persona                                                              |
| F        | Fecha de la carrera                                                            |
| IC       | Identificador de la carrera: I1, I2, ...                                       |
| PR       | Precio en Euros de la inscripción en una carrera                               |
| S        | Sexo: Hombre o Mujer                                                           |
| T        | Tiempo en minutos que una persona invirtió en una carrera. Nulo si no la acabó |

Las tablas utilizadas son:

**PERSONAS** (DNI, S)\
**SIGNIFICADO**: La persona con DNI es de sexo S.\
**CLAVE PRIMARIA**: (DNI)

**CARRERAS** (IC, CDC, F, D, PR)\
**SIGNIFICADO**: La prueba IC se celebra en la ciudad CDC, en la fecha, tiene una distancia D kilometros y el precio de la inscripción es PR Euros.\
**CLAVE PRIMARIA**: (IC)

**PARTICIPANTES** (DNI, IC, T)\
**SIGNIFICADO**: La persona con DNI, participó en la carrera IC e hizo un tiempo de T minutos. Si el valor T es nulo la persona no acabó la carrera.\
**CLAVE PRIMARIA**: (DNI, IC)\
**CLAVE AJENA**: (DNI), (IC)

## 1. Responder en algebra relacional a las siguientes consultas:
a) Personas que han corrido la carrera I1 pero no la I2.
```sql
A = P(DNI) S(IC = 'I1') (PARTICIPANTES)
B = P(DNI) S(IC = 'I2') (PARTICIPANTES)
A - B
```

b) Personas que han corrido una misma distancia en varias ciudades.
```sql
A = B = P(DNI, CDC, D) (PARTICIPANTES * CARRERAS)
P(A.DNI) S((A.DNI = B.DNI) ^ (A.D = B.D) ^ (A.CDC != B.CDC)) (A x B)
```

c) Persona que ganó la carrera I1.
```sql
A = B = P(DNI, T) S(IC = 'I1') (PARTICIPANTES)
C = P(A.DNI) S((A.T > B.T) ^ (A.T = 0)) (A * B)
P(DNI) (A) - C
``` 

d) Personas que han corrido al menos una vez en cada ciudad en la que se organizan carreras.
```sql
A = P(DNI, CDC) (PARTICIPANTES * CARRERAS)
B = P(CDC) (CARRERAS)
P(DNI) (A/B)
```

e) Personas que han corrido en alguna ciudad todas las carreras que se han organizado en ella.
```sql

```


## 2. Responder en cálculo relaciona de t-uplas y de dominio a las siguientes consultas:
a) Personas que han corrido en al menos 2 carreras celebradas en un mismo día.
* Cálculo de t-uplas:
```sql
dom(p1) = dom(p2) = PARTICIPANTES
dom(c1) = dom(c2) = CARRERAS
{t | ∃p1 ∈ PARTICIPANTES, c1 ∈ CARRERAS, p2 ∈ PARTICIPANTES, c2 ∈ CARRERAS, (p1.DNI = p2.DNI) ^ (p1.IC = c1.IC) ^ (p2.IC = c2.IC) ^ (c1.F = c2.F) ^ (c1.IC != c2.IC)}
=======
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

## 1. Responder en álgebra relacional a las siguientes consulta


## 2. Responder en cálculo relacional de tuplas y de dominios a las siguientes consultas:
a) Personas que han corrido en al menos 2 carreras celebradas en un mismo día.
* CRT:
```sql
dom(p1) = dom(p2) = PARTICIPANTES
dom(c1) = dom(c2) = CARRERAS
{t1 | (∃p1) (t[DNI] = p1[DNI]) ^ (∃p2) (p2[DNI] = p1[DNI]) ^ (∃c1, c2) (p1[IC] = c1[IC]) ^ (p2[IC] = c2[IC]) ^ (c1[F] = c2[F]) ^ (c1[IC] != c2[IC])}
```

* CRD:
```sql
{<dni> | (∃ic, t) (<dni, ic, t> ∈ PARTICIPANTES) ^ (∃ic´, t´) (<dni, ic´, t´> ∈ PARTICIPANTES) ^
         (∃cdc, f, d, pr) (<ic, cdc, f, d, pr> ∈ CARRERAS) ^ 
         (∃cdc´, f´, d´, pr´) (<ic´, cdc´, f´, d´, pr´> ∈ CARRERAS) ^ (f = f´) ^ (ic != ic´)}
```

b) Personas que siempre corren la misma distancia. (puede ser en una o varias carreras distintas)
* CRT:
```sql
dom(p1) = dom(p2) = PARTICIPANTES
dom(c1) = dom(c2) = CARRERAS
{t1 | (∃p1) (t1[DNI] = p1[DNI]) ^ (∃c1) (p1[IC] = c1[IC]) ^ 
      ¬(∃p2, c2) (p1[DNI] = p2[DNI]) ^ (p2[IC] = c2[IC]) ^ 
      (c1[D] != c2[D]) }
```

* CRD:
```sql
{<dni> | (∃ic, t) (<dni, ic, t> ∈ PARTICIPANTES) ^ ç
         (∃cdc, f, d, pr) (<ic, cdc, f, d, pr> ∈ CARRERAS) ^
         ¬(∃ic´, t´) (<dni, ic´, t´> ∈ PARTICIPANTES) ^
         ¬(∃cdc´, f´, d´, pr´) (<ic´, cdc´, f´, d´, pr´> ∈ CARRERAS) ^ (d != d´)}
```

c) Personas que han ganado alguna carrera.
* CRT:
```sql
dom(p1) = dom(p2) = PARTICIPANTES
{t1 | (∃p1) (t1[DNI] = p1[DNI]) ^ ¬(∃p2) (p1[DNI] = p2[DNI]) ^ (p1[T] > p2[T])}
```

* CRD:
```sql
{<dni> | (∃ic, t) (<dni, ic, t> ∈ PARTICIPANTES) ^ 
         ¬(∃ic´, t´) (<dni, ic´, t´> ∈ PARTICIPANTES) ^ (t > t´)}
```

d) Personas que han ganado todas las carreras en las que han participado.
* CRT:
```sql
dom(p1) = dom(p2) = PARTICIPANTES
dom(c1) = CARRERAS
{t1 | (∃p1) (t1[DNI] = p1[DNI]) ^ ¬(∃p2) (p1[DNI] = p2[DNI]) ^ (∃c1) (p1[IC] = c1[IC]) ^ (p1[T] < p2[T])}
>>>>>>> a5b0d1649759ceeda13d2ee734423586680e70c0
```