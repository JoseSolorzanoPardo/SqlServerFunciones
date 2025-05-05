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
SELECT TOP 1 \*

FROM TransaccionesFraude

WHERE riesgo_fraude='Alto' ORDER BY monto DESC;
```
#### 6.Mostrar el registro completo de la transacción con el mayor monto
```
SELECT TOP 1 \*

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
SELECT TOP 1 \* FROM TransaccionesFraude

WHERE resultado_validacion = 'Aprobado' ORDER BY MONTO;
```
#### 12\. Mostrar el registro completo de la transacción con el monto más bajo
```
SELECT TOP 1 \*

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
SELECT

canal,

AVG(monto) AS Promedio_Monto

FROM TransaccionesFraude

GROUP BY canal

HAVING AVG(monto) > 1000000;
```
#### 24.Contar todas las transacciones
```
SELECT COUNT(\*) AS Total_Transacciones

FROM TransaccionesFraude;
```
#### 25.Contar transacciones por canal
```
SELECT canal, COUNT(\*) AS Total_Por_Canal

FROM TransaccionesFraude

GROUP BY canal;
```
#### 26.Contar transacciones por país
```
SELECT pais, COUNT(\*) AS Total_Por_Pais

FROM TransaccionesFraude

GROUP BY pais;
```
#### 27.Contar transacciones de riesgo “Alto”
```
SELECT COUNT(\*) AS Total_Alto_Riesgo

FROM TransaccionesFraude

WHERE riesgo_fraude = 'Alto';
```
#### 29.Cantidad de transacciones por resultado de validación
```
SELECT resultado_validacion, COUNT(\*) AS Total_Por_Resultado

FROM TransaccionesFraude

GROUP BY resultado_validacion;
```
#### 30\. Mostrar solo países con más de 2 transacciones (usando HAVING)
```
SELECT pais, COUNT(\*) AS Total

FROM TransaccionesFraude

GROUP BY pais

HAVING COUNT(\*) > 2;
```
