# **Explorando las Funciones Agregadas y Clausula Having**

### Funciones Agregadas (Aggregate Functions)

Estas funciones operan sobre un conjunto de filas y devuelven un solo valor. Son útiles para hacer cálculos sobre columnas numéricas:

- MAX() → Retorna el valor máximo.
- MIN() → Retorna el valor mínimo.
- SUM() → Suma todos los valores.
- AVG() → Calcula el promedio.
- COUNT() → Cuenta el número de registros.

### Cláusula HAVING

- HAVING no es una función, sino una cláusula usada junto con GROUP BY.
- Sirve para filtrar los resultados agregados (algo que WHERE no puede hacer después de un GROUP BY).

## Ejercicio

Vamos a ejecutar las siguientes sentencias para construir una tabla en SQL server:
```
CREATE TABLE TransaccionesFraude (

id_transaccion INT PRIMARY KEY,

id_usuario INT NOT NULL,

monto DECIMAL(10, 2) NOT NULL,

fecha_transaccion DATETIME NOT NULL,

canal NVARCHAR(50),

resultado_validacion NVARCHAR(20),

riesgo_fraude NVARCHAR(10),

tipo_documento NVARCHAR(20),

pais NVARCHAR(50)

);
```
```
INSERT INTO TransaccionesFraude

(id_transaccion, id_usuario, monto, fecha_transaccion, canal, resultado_validacion, riesgo_fraude, tipo_documento, pais)

VALUES

(1, 101, 500000, '2025-04-01 10:30:00', 'App', 'Aprobado', 'Bajo', 'Cédula', 'Colombia'),

(2, 102, 1500000, '2025-04-01 11:00:00', 'Web', 'Rechazado', 'Alto', 'Pasaporte', 'Venezuela'),

(3, 103, 750000, '2025-04-02 09:15:00', 'Tienda Física', 'Aprobado', 'Medio', 'Cédula', 'Colombia'),

(4, 104, 2000000, '2025-04-02 14:45:00', 'WhatsApp', 'Pendiente', 'Alto', 'Otro', 'Perú'),

(5, 105, 300000, '2025-04-03 16:20:00', 'App', 'Aprobado', 'Bajo', 'Cédula', 'Colombia'),

(6, 106, 1250000, '2025-04-03 17:50:00', 'Web', 'Rechazado', 'Alto', 'Pasaporte', 'Ecuador'),

(7, 107, 600000, '2025-04-04 12:10:00', 'Tienda Física', 'Aprobado', 'Medio', 'Cédula', 'Colombia'),

(8, 108, 950000, '2025-04-04 13:30:00', 'WhatsApp', 'Pendiente', 'Alto', 'Otro', 'México'),

(9, 109, 400000, '2025-04-05 10:00:00', 'App', 'Aprobado', 'Bajo', 'Cédula', 'Colombia'),

(10, 110, 1100000, '2025-04-05 11:25:00', 'Web', 'Rechazado', 'Alto', 'Pasaporte', 'Argentina');
```

#### 1.Valor máximo de todas las transacciones
```
SELECT MAX(monto) AS Monto_Maximo From TransaccionesFraude;
```
#### 2.Monto máximo por cada canal
```
SELECT canal, MAX(monto) AS Monto_Maximo

FROM TransaccionesFraude

GROUP BY canal;
```
#### 3.Monto máximo por país
```
SELECT pais, MAX(monto) AS Monto_Maximo

FROM TransaccionesFraude

GROUP BY pais;
```
#### 4\. Monto máximo solo para transacciones con riesgo "Alto"
```
SELECT MAX(monto) AS Monto_Maximo_Alto_Riesgo

FROM TransaccionesFraude

WHERE riesgo_fraude = 'Alto';
```
#### 5.Monto máximo solo para transacciones con riesgo "Alto"
```
SELECT MAX(monto) AS Monto_Maximo_Alto_Riesgo

FROM TransaccionesFraude

WHERE riesgo_fraude = 'Alto';
```
#### 6.Obtener el registro completo de Monto Máximo solo para transacciones con riesgo “Alto”
```
SELECT TOP 1 *

FROM TransaccionesFraude

WHERE riesgo_fraude='Alto' ORDER BY monto DESC;
```
#### 6.Mostrar el registro completo de la transacción con el mayor monto
```
SELECT TOP 1 *

FROM TransaccionesFraude

ORDER BY monto DESC;
```
#### 7\. Valor mínimo de todas las transacciones
```
SELECT MIN(monto) as monto_minimo FROM TransaccionesFraude;
```
#### 8.Monto mínimo por canal
```
SELECT canal, MIN(monto) AS Monto_Minimo

FROM TransaccionesFraude

GROUP BY canal;
```
#### 9.Monto mínimo por país
```
SELECT pais, MIN(monto) AS Monto_Minimo

FROM TransaccionesFraude

GROUP BY pais;
```
#### 10.Monto mínimo en transacciones con resultado 'Aprobado'
```
SELECT MIN(monto) AS Monto_Minimo_Aprobado

FROM TransaccionesFraude

WHERE resultado_validacion = 'Aprobado';
```
#### 11.Registro completo de Monto mínimo en transacciones con resultado 'Aprobado'
```
SELECT TOP 1 * FROM TransaccionesFraude

WHERE resultado_validacion = 'Aprobado' ORDER BY MONTO;
```
#### 12\. Mostrar el registro completo de la transacción con el monto más bajo
```
SELECT TOP 1 *

FROM TransaccionesFraude

ORDER BY monto ASC;
```
#### 13\. Suma total de todos los montos
```
SELECT SUM(monto) AS Suma_Total

FROM TransaccionesFraude;
```
#### 14.Suma de montos por canal
```
SELECT canal, SUM(monto) AS Suma_Por_Canal

FROM TransaccionesFraude

GROUP BY canal;
```
#### 15.Suma de montos por país
```
SELECT pais, SUM(monto) AS Suma_Por_Pais

FROM TransaccionesFraude

GROUP BY pais;
```
#### 16.Suma de montos por nivel de riesgo
```
SELECT riesgo_fraude, SUM(monto) AS Suma_Por_Riesgo

FROM TransaccionesFraude

GROUP BY riesgo_fraude;
```
#### 17\. Suma de montos para transacciones rechazadas
```
SELECT SUM(monto) AS Suma_Rechazados

FROM TransaccionesFraude

WHERE resultado_validacion = 'Rechazado';
```
#### 18\. Suma de montos por país (solo donde la suma supere 2 millones)
```
SELECT pais, '$'+FORMAT (SUM(monto), 'N2','es-CO') AS Total_Pais

FROM TransaccionesFraude

GROUP BY pais

HAVING SUM(monto) > 2000000;
```
#### 19.Promedio de todos los montos
```
SELECT AVG(monto) AS Promedio_Total

FROM TransaccionesFraude;
```
#### 20\. Promedio por canal
```
SELECT canal, AVG(monto) AS Promedio_Por_Canal

FROM TransaccionesFraude

GROUP BY canal;
```
#### 21\. Promedio por país
```
SELECT pais, AVG(monto) AS Promedio_Por_Pais

FROM TransaccionesFraude

GROUP BY pais;
```
#### 22.Promedio para transacciones de riesgo "Alto"
```
SELECT AVG(monto) AS Promedio_Riesgo_Alto

FROM TransaccionesFraude

WHERE riesgo_fraude = 'Alto';
```
#### 23\. Promedios mayores a $1.000.000
```
SELECT canal,

AVG(monto) AS Promedio_Monto

FROM TransaccionesFraude

GROUP BY canal

HAVING AVG(monto) > 1000000;
```
#### 24.Contar todas las transacciones
```
SELECT COUNT(*) AS Total_Transacciones

FROM TransaccionesFraude;
```
#### 25.Contar transacciones por canal
```
SELECT canal, COUNT(*) AS Total_Por_Canal

FROM TransaccionesFraude

GROUP BY canal;
```
#### 26.Contar transacciones por país
```
SELECT pais, COUNT(*) AS Total_Por_Pais

FROM TransaccionesFraude

GROUP BY pais;
```
#### 27.Contar transacciones de riesgo “Alto”
```
SELECT COUNT(*) AS Total_Alto_Riesgo

FROM TransaccionesFraude

WHERE riesgo_fraude = 'Alto';
```
#### 29.Cantidad de transacciones por resultado de validación
```
SELECT resultado_validacion, COUNT(*) AS Total_Por_Resultado

FROM TransaccionesFraude

GROUP BY resultado_validacion;
```
#### 30\. Mostrar solo países con más de 2 transacciones (usando HAVING)
```
SELECT pais, COUNT(*) AS Total
FROM TransaccionesFraude
GROUP BY pais
HAVING COUNT(*) > 2;
```


## Clausula Having

Se usa para filtrar resultados después de aplicar funciones agregadas (SUM(), AVG(), COUNT(), etc.).

**Diferencia clave:**

- WHERE filtra **antes** del GROUP BY (sobre filas individuales).
- HAVING filtra **después** del GROUP BY (sobre resultados agregados).

#### 31.Canales con promedio de transacciones mayor a $1.000.000
```
SELECT canal, AVG(monto) AS Promedio_Monto
FROM TransaccionesFraude
GROUP BY canal
HAVING AVG(monto) > 1000000;
```
#### 32\. Países donde se hicieron más de 2 transacciones
```
SELECT pais, COUNT(*) AS Total_Transacciones
FROM TransaccionesFraude
GROUP BY pais
HAVING COUNT(*) > 1;
```
#### 33\. Niveles de riesgo con una suma total mayor a $2.000.000
```
SELECT riesgo_fraude, SUM(monto) AS Total_Riesgo
FROM TransaccionesFraude
GROUP BY riesgo_fraude
HAVING SUM(monto) > 2000000;
```
#### 34\. Mostrar países donde la transacción máxima supera $1.500.000
```
SELECT pais, MAX(monto) AS Monto_Maximo
FROM TransaccionesFraude
GROUP BY pais
HAVING MAX(monto) > 1500000;
```
#### 35\. Formateado con HAVING (para visualización)
```
SELECT
pais,
'$' + FORMAT(SUM(monto), 'N2', 'es-CO') AS Total_Formateado
FROM TransaccionesFraude
GROUP BY pais
HAVING SUM(monto) > 2000000;
```



# Procedimientos Almacenados

Un procedimiento almacenado es un bloque de código SQL que se guarda en la base de datos y se puede ejecutar cuantas veces quieras. Piensa en él como una "función" o "método" que puede contener consultas SELECT, INSERT, UPDATE, DELETE, lógica condicional (IF, WHILE, etc.), y que puede recibir parámetros.

**¿Por qué usar procedimientos almacenados?**

- **Reutilización de código**: no repites las mismas consultas en diferentes partes del sistema.
- **Seguridad**: puedes dar permiso para ejecutar un procedimiento sin dar acceso directo a las tablas.
- **Mantenimiento**: es más fácil actualizar la lógica de negocio centralizada.
- **Rendimiento**: el motor de SQL Server guarda un plan de ejecución optimizado.

## Procedimientos sin parámetros de entrada
```
CREATE PROCEDURE NombreDelProcedimiento

AS

BEGIN

\-- Código SQL aquí

SELECT \* FROM TransaccionesFraude;

END;
```
Ejecución del procedimiento almacenado:
```
EXEC NombreDelProcedimiento;
```
## Procedimiento con parámetros de entrada

El siguiente bloque crea un procedimiento llamado ‘validarTransaccion’ que recibe un parámetro de entrada llamado @ResultadoValidacion, de tipo NVARCHAR(100). Este valor se usará dentro del procedimiento para filtrar datos.
```
CREATE PROCEDURE validarTransaccion

@ResultadoValidacion NVARCHAR(100)

AS

BEGIN

\-- Código SQL aquí

SELECT pais,riesgo_fraude, canal, '$'+ FORMAT(SUM(monto) , 'N0', 'es-CO') AS Sumatorio_monto FROM TransaccionesFraude

WHERE resultado_validacion=@ResultadoValidacion

GROUP BY pais,riesgo_fraude,canal

ORDER BY Sumatorio_monto ;

END;

exec validarTransaccion @ResultadoValidacion='Rechazado';
```
Expliquemos el anterior código

- **FROM TransaccionesFraude**: trabaja sobre una tabla llamada TransaccionesFraude.
- **WHERE resultado_validacion = @ResultadoValidacion**: filtra solo los registros que tienen el resultado igual al valor enviado al procedimiento ('Rechazado', en este caso caso).
- **GROUP BY pais, riesgo_fraude, canal**: agrupa los datos por país, nivel de riesgo de fraude y canal (puede ser web, móvil, etc.).
- **SUM(monto)**: suma los montos por cada grupo.
- **FORMAT(SUM(monto), 'N0', 'es-CO')**: aplica formato numérico colombiano al valor sumado, agregando puntos como separadores de miles, sin decimales (N0).
- **'$' + FORMAT(...)**: antepone el símbolo de peso a la suma.
- **AS Sumatorio_monto**: así se llamará la columna en el resultado final.
- **ORDER BY Sumatorio_monto**: ordena los resultados por el valor sumado.

# ¿Qué hace ISNULL()?

ISNULL(valor, reemplazo) reemplaza un valor NULL por otro que tú definas.

#### Ejemplo Uso de ISNULL para reemplazar nulos en canal y riesgo_fraude

Vamos a suponer que, por ejemplo, en algunos registros futuros el campo canal o riesgo_fraude puede venir con valor NULL (lo cual puede pasar en registros incompletos). La función ISNULL en SQL Server se usa para **reemplazar valores nulos con un valor por defecto**.

Primero, vamos a insertar algunos registros con valores NULL en el campo canal y riesgo_fraude:
```
INSERT INTO TransaccionesFraude

(id_transaccion, id_usuario, monto, fecha_transaccion, canal, resultado_validacion, riesgo_fraude, tipo_documento, pais)

VALUES

(11, 111, 800000, '2025-04-06 08:00:00', NULL, 'Pendiente', NULL, 'Cédula', 'Chile'),

(12, 112, 650000, '2025-04-06 09:30:00', NULL, 'Aprobado', 'Bajo', 'Pasaporte', 'Colombia');
```
Ahora, una consulta usando ISNULL para reemplazar:

- NULL en canal con 'Sin Canal'
- NULL en riesgo_fraude con 'No Definido'
```
SELECT
id_transaccion,
id_usuario,
monto,
ISNULL(canal, 'Sin Canal') AS canal,
resultado_validacion,
ISNULL(riesgo_fraude, 'No Definido') AS riesgo_fraude,
tipo_documento,
pais
FROM TransaccionesFraude;
```
#### 36.Uso de AND Mostrar transacciones aprobadas de Colombia
```
SELECT *
FROM TransaccionesFraude
WHERE resultado_validacion = 'Aprobado'
AND pais = 'Colombia';
```
📌 Este filtro muestra solo los registros donde _ambas_ condiciones se cumplen al mismo tiempo.

#### 38\. Uso de OR Mostrar transacciones cuyo resultado haya sido 'Pendiente' o cuyo país sea 'Perú'

```
SELECT *
FROM TransaccionesFraude
WHERE resultado_validacion = 'Pendiente'
OR pais = 'Perú';
```

📌 Aquí se mostrará cualquier transacción que cumpla _al menos una_ de las condiciones.

#### 39.Combinación de AND y OR con paréntesis mostrar transacciones con resultado 'Pendiente' y país distinto de Colombia, o aquellas con canal nulo

```
SELECT *
FROM TransaccionesFraude
WHERE (resultado_validacion = 'Pendiente' AND pais <> 'Colombia')
OR canal IS NULL;
```

📌 Los paréntesis ayudan a agrupar condiciones y evitar errores lógicos en la consulta.

#### 40\. Filtro con monto y riesgo usando AND Transacciones mayores a $1.000.000 con riesgo alto

```
SELECT \*
FROM TransaccionesFraude
WHERE monto > 1000000
AND riesgo_fraude = 'Alto';
```

#### 41\. Uso básico de IN mostrar transacciones realizadas desde los canales 'App' o 'Web'
```
SELECT *
FROM TransaccionesFraude
WHERE canal IN ('App', 'Web');
```
📌 Esto es equivalente a usar:
```
WHERE canal = 'App' OR canal = 'Web'
```
pero de forma más compacta.

#### 42\. Combinando IN con otra condición (AND) Transacciones rechazadas y hechas por canal 'Web' o 'WhatsApp'
```
SELECT *
FROM TransaccionesFraude
WHERE resultado_validacion = 'Rechazado'
AND canal IN ('Web', 'WhatsApp');
```

#### 43: Usando IN con países Transacciones que provienen de Colombia, Perú o México
```
SELECT *
FROM TransaccionesFraude
WHERE pais IN ('Colombia', 'Perú', 'México');
```

#### 44.Transacciones que no provienen de Colombia ni Venezuela
```
SELECT *
FROM TransaccionesFraude
WHERE pais NOT IN ('Colombia', 'Venezuela');
```

#### 45\. Uso de NOT con igualdad Transacciones que no fueron aprobadas
```
SELECT *
FROM TransaccionesFraude
WHERE NOT resultado_validacion = 'Aprobado';
```

📌 Equivalente a:
```
WHERE resultado_validacion <> 'Aprobado';
```

#### 46\. Uso de NOT IN Transacciones que no se realizaron en los canales 'App', 'Web' ni 'WhatsApp'
```
SELECT *
FROM TransaccionesFraude
WHERE canal NOT IN ('App', 'Web', 'WhatsApp');
```

#### 47\. Uso de NOT LIKE Transacciones donde el país no comienza por 'C'
```
SELECT *
FROM TransaccionesFraude
WHERE pais NOT LIKE 'C%';
```

📌 Esto excluye países como "Colombia", "Chile", etc.

#### 48\. Uso de NOT con IS NULL Transacciones donde el campo canal NO está vacío (no es nulo)
```
SELECT *
FROM TransaccionesFraude
WHERE canal IS NOT NULL;
```
#### 49\. BETWEEN con montos Transacciones con montos entre $500.000 y $1.000.000
```
SELECT *
FROM TransaccionesFraude
WHERE monto BETWEEN 500000 AND 1000000;
```

📌 Esto incluye transacciones cuyo monto sea igual a **500000**, **1000000**, o cualquier valor intermedio.

#### 50\. BETWEEN con fechas Transacciones realizadas entre el 1 y el 3 de abril de 2025
```
SELECT *
FROM TransaccionesFraude
WHERE fecha_transaccion BETWEEN '2025-04-01' AND '2025-04-03 23:59:59';
```

📌 Importante incluir la hora si quieres abarcar todo el último día.

#### 51\. combinando BETWEEN con otra condición (AND) Transacciones entre $500.000 y $1.000.000, realizadas por canal 'App'
```
SELECT \*
FROM TransaccionesFraude
WHERE monto BETWEEN 500000 AND 1000000
AND canal = 'App';
```
#### 52\. Ejemplo 4: NOT BETWEEN Transacciones fuera del rango de $600.000 a $1.500.000
```
SELECT *
FROM TransaccionesFraude
WHERE monto NOT BETWEEN 600000 AND 1500000;
```
