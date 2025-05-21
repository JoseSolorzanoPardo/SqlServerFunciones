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



-- Mostrar todas las transacciones con nombre del cliente
SELECT 
    t.TransaccionID,
    c.Nombre,
    t.Monto,
    t.Tipo,
    t.Canal,
    t.Fecha
FROM Transacciones t
INNER JOIN Clientes c ON t.ClienteID = c.ClienteID
ORDER BY t.Fecha DESC;

--Transacciones de clientes del segmento 'Premium'
SELECT 
    c.Nombre,
    t.Monto,
    t.Tipo,
    t.Fecha
FROM Transacciones t
INNER JOIN Clientes c ON t.ClienteID = c.ClienteID
WHERE c.Segmento = 'Premium';

--Total de dinero movido por cliente (resumen con GROUP BY)
SELECT 
    c.Nombre,
    COUNT(t.TransaccionID) AS TotalTransacciones,
    SUM(t.Monto) AS MontoTotal
FROM Clientes c
INNER JOIN Transacciones t ON c.ClienteID = t.ClienteID
GROUP BY c.Nombre
ORDER BY MontoTotal DESC;

--Clientes con más de 2 transacciones (usando HAVING)
SELECT 
    c.Nombre,
    COUNT(t.TransaccionID) AS NumTransacciones
FROM Clientes c
INNER JOIN Transacciones t ON c.ClienteID = t.ClienteID
GROUP BY c.Nombre
HAVING COUNT(t.TransaccionID) > 2;


--Subconsulta en WHERE
SELECT Nombre
FROM Clientes
WHERE ClienteID IN (
    SELECT ClienteID
    FROM Transacciones
    WHERE Monto > 500000
);

--Subconsulta en SELECT
SELECT 
    Nombre,
    (SELECT SUM(Monto) 
     FROM Transacciones 
     WHERE ClienteID = c.ClienteID) AS TotalMovido
FROM Clientes c;

--Subconsulta en FROM (derivada)
SELECT Tipo, AVG(Monto) AS Promedio
FROM (
    SELECT Tipo, Monto
    FROM Transacciones
    WHERE Monto > 0
) AS Subconsulta
GROUP BY Tipo;

--Subconsulta escalar (valor único)
SELECT Nombre
FROM Clientes
WHERE ClienteID = (
    SELECT TOP 1 ClienteID
    FROM Transacciones
    GROUP BY ClienteID
    ORDER BY SUM(Monto) DESC
);


--Clasificar transacciones por monto
SELECT 
    TransaccionID,
    Monto,
    CASE 
        WHEN Monto < 50000 THEN 'Bajo'
        WHEN Monto BETWEEN 50000 AND 300000 THEN 'Medio'
        ELSE 'Alto'
    END AS NivelMonto
FROM Transacciones;

--Etiquetar canales como Digital o Físico
SELECT 
    TransaccionID,
    Canal,
    CASE 
        WHEN Canal IN ('App', 'Web') THEN 'Digital'
        ELSE 'Físico'
    END AS TipoCanal
FROM Transacciones;

--Clasificar clientes por monto total transaccionado
SELECT 
    c.Nombre,
    SUM(t.Monto) AS TotalTransacciones,
    CASE 
        WHEN SUM(t.Monto) > 1000000 THEN 'Alto Valor'
        WHEN SUM(t.Monto) BETWEEN 300000 AND 1000000 THEN 'Medio Valor'
        ELSE 'Bajo Valor'
    END AS Categoria
FROM Clientes c
JOIN Transacciones t ON c.ClienteID = t.ClienteID
GROUP BY c.Nombre;
