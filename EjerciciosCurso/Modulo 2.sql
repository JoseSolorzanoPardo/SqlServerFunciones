

--Agrupación por tipo de transaccion
SELECT 
    Tipo,
    SUM(Monto) AS TotalPorTipo
FROM Transacciones
GROUP BY Tipo;

--Agrupación por canal
SELECT 
    Canal,
    SUM(Monto) AS TotalPorCanal
FROM Transacciones
GROUP BY Canal;


--Número de transacciones por cliente
SELECT 
    c.Nombre,
    COUNT(t.TransaccionID) AS NumTransacciones
FROM Transacciones t
JOIN Clientes c ON t.ClienteID = c.ClienteID
GROUP BY c.Nombre;

--Contar clientes por segmento
SELECT 
    Segmento,
    COUNT(*) AS CantidadClientes
FROM Clientes
GROUP BY Segmento;


--Clientes que han hecho más de 3 transacciones
SELECT 
    ClienteID,
    COUNT(*) AS TotalTransacciones
FROM Transacciones
GROUP BY ClienteID
HAVING COUNT(*) > 3;


--Clientes que han movido más de $1.000.000
SELECT 
    ClienteID,
    SUM(Monto) AS MontoTotal
FROM Transacciones
GROUP BY ClienteID
HAVING SUM(Monto) > 1000000;




--Transacciones tipo 'Pago' o 'Retiro'
SELECT *
FROM Transacciones
WHERE Tipo = 'Pago' OR Tipo = 'Retiro';

--Clientes que NO son del segmento 'Premium'
SELECT *
FROM Clientes
WHERE Segmento <> 'Premium';
-- O también: WHERE NOT Segmento = 'Premium';

--Transacciones con montos entre $100.000 y $500.000
SELECT *
FROM Transacciones
WHERE Monto BETWEEN 100000 AND 500000;

--Clientes cuyo nombre contiene “Torres”
SELECT *
FROM Clientes
WHERE Nombre LIKE '%Torres%';


--SEGUNDA PARTE

--DROP PROCEDURE ReporteResumenClientes

CREATE PROCEDURE ReporteResumenClientes
AS
BEGIN
    SELECT 
        c.Nombre,
        c.Segmento,
        COUNT(t.TransaccionID) AS TotalTransacciones,
        SUM(t.Monto) AS MontoTotal
    FROM Clientes c
    JOIN Transacciones t ON c.ClienteID = t.ClienteID
    GROUP BY c.Nombre, c.Segmento
    ORDER BY MontoTotal DESC;
END;


EXEC ReporteResumenClientes;



CREATE PROCEDURE ObtenerTransaccionesPorTipo
    @TipoTransaccion NVARCHAR(50)
AS
BEGIN
    SELECT 
        TransaccionID,
        ClienteID,
        Fecha,
        Monto,
        Tipo,
        Canal
    FROM Transacciones
    WHERE Tipo = @TipoTransaccion
    ORDER BY Fecha DESC;
END;


EXEC ObtenerTransaccionesPorTipo @TipoTransaccion = 'Transferencia';
