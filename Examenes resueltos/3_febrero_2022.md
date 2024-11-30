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
```