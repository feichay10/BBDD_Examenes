# Examen 19 de diciembre de 2022

Una cadena de tiendas de venta de piezas de repuestos de coche tiene un base de datos para gestionar las ventas realizadas en las distintas tiendas de las que dispone. En el esquema de base de datos utilizado los atributos se abrevian según el siguiente convenio:

| Atributo | Significado               |
| -------- | ------------------------- |
| CT       | Código de tienda         |
| DNI      | DNI del cliente           |
| F        | Fecha de venta            |
| P        | Identificador de la pieza |
| PR       | Precio de la pieza        |
| T        | Tipo de pieza             |

Las tablas utilizadas son:

**PIEZAS** (P, T, PR)\
**SIGNIFICADO:** La pieza P es de tipo T y tiene un precio PR euros.\
**CLAVE PRIMARIA:** (P)

**VENTA** (DNI, CT, P, F)\
**SIGNIFICADO:** La persona con dni DNI, compró en la tienda CT la pieza P en la fecha F.\
**CLAVE PRIMARIA:** (DNI, CT, P, F)\
**CLAVE AJENA:** (P) 

## 1) Escribe en álgebra relacional las siguientes consultas:
a) Personas que han comprado la pieza P1 y la pieza P2.
```sql
P(DNI) S((P = 'P1') ^ (P = 'P2') (VENTA))
```

b) Personas que sólo han comprado piezas de tipo T1.
```sql
P(DNI) S((T = 'T1') (PIEZAS * VENTA))
```

c) Pieza más barata vendida en la tienda CT1.
```sql
A = B = PIEZA
P(A.P) S((A.PR < B.PR) ^ (A.P = B.P)) (A x B) = C
P(P) (VENTA) - C
```

d) Personas que un mismo día han comprado todas las piezas del tipo T1.
```sql
P(DNI, P) S((T = 'T1') (PIEZAS * VENTA)) / P(P) (VENTA) 
```

e) Tiendas que en un mismo día han vendido todas las piezas de algún tipo.
```sql

```
