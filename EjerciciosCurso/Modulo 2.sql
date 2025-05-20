CREATE TABLE Clientes (
    ClienteID INT PRIMARY KEY,
    Nombre NVARCHAR(100),
    Correo NVARCHAR(100),
    Segmento NVARCHAR(50)
);

-- Tabla Transacciones
CREATE TABLE Transacciones (
    TransaccionID INT PRIMARY KEY,
    ClienteID INT,
    Fecha DATETIME,
    Monto DECIMAL(12, 2),
    Tipo NVARCHAR(50),
    Canal NVARCHAR(50),
    FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID)
);

-- Insertar datos en Clientes
INSERT INTO Clientes (ClienteID, Nombre, Correo, Segmento) VALUES
(1, 'Ana Martínez', 'ana.martinez@email.com', 'Premium'),
(2, 'Carlos Gómez', 'carlos.gomez@email.com', 'Estándar'),
(3, 'Laura Torres', 'laura.torres@email.com', 'Frecuente'),
(4, 'Juan Pérez', 'juan.perez@email.com', 'Premium');

-- Insertar datos en Transacciones
INSERT INTO Transacciones (TransaccionID, ClienteID, Fecha, Monto, Tipo, Canal) VALUES
(1001, 1, '2025-05-15 10:23:00', 120000.00, 'Transferencia', 'App'),
(1002, 1, '2025-05-15 11:05:00', 250000.00, 'Pago', 'Web'),
(1003, 2, '2025-05-16 09:45:00', 50000.00, 'Retiro', 'Cajero'),
(1004, 3, '2025-05-17 14:10:00', 75000.00, 'Pago', 'App'),
(1005, 3, '2025-05-17 15:30:00', 80000.00, 'Transferencia', 'Web'),
(1006, 4, '2025-05-17 16:00:00', 300000.00, 'Transferencia', 'App');

INSERT INTO Transacciones (TransaccionID, ClienteID, Fecha, Monto, Tipo, Canal) VALUES
(1007, 1, '2025-05-17 09:15:00', 5000.00, 'Consulta Saldo', 'App'),
(1008, 1, '2025-05-17 09:30:00', 1500000.00, 'Transferencia', 'Web'), 
(1009, 2, '2025-05-17 10:00:00', 200000.00, 'Pago', 'Web'),
(1010, 2, '2025-05-17 10:15:00', 199000.00, 'Transferencia', 'App'),
(1011, 2, '2025-05-17 10:17:00', 5000.00, 'Consulta Saldo', 'App'),
(1012, 3, '2025-05-17 11:00:00', 60000.00, 'Retiro', 'Cajero'),
(1013, 3, '2025-05-17 11:10:00', 800000.00, 'Transferencia', 'Web'), 
(1014, 4, '2025-05-17 12:00:00', 10000.00, 'Pago', 'App'),
(1015, 4, '2025-05-17 12:10:00', 20000.00, 'Pago', 'App'),
(1016, 4, '2025-05-17 12:30:00', 15000.00, 'Consulta Saldo', 'Web');

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
