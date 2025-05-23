--https://sqlfiddle.com/

-- Tabla Clientes
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


--Consultando la tabla de transacciones
SELECT * FROM Transacciones ORDER BY Fecha DESC;

--Determinando la cantidad de transacciones y tablas
SELECT ClienteID, COUNT(*) AS NumTransacciones, SUM(Monto) AS TotalMovido
FROM Transacciones
GROUP BY ClienteID;

--Conjunto de actualizaciones
UPDATE Clientes SET Segmento = 'Premium' WHERE Nombre = 'Carlos Gómez';
UPDATE Transacciones SET Canal = 'Cajero' WHERE TransaccionID = 1015;
UPDATE Transacciones SET Monto = 80000.00 WHERE TransaccionID = 1013;

--Eliminación de información
DELETE FROM Transacciones WHERE Monto = 0.00;


-- Primero verifica si no tiene transacciones
SELECT * FROM Transacciones WHERE ClienteID = 99;
-- Luego eliminas si está vacío
DELETE FROM Clientes
WHERE ClienteID = 99;

--Total de transacciones por cliente
SELECT 
    ClienteID,
    COUNT(*) AS TotalTransacciones,
    SUM(Monto) AS MontoTotal
FROM Transacciones
GROUP BY ClienteID;

--Monto total por tipo de transacción
SELECT 
    Tipo,
    COUNT(*) AS Cantidad,
    SUM(Monto) AS TotalPorTipo
FROM Transacciones
GROUP BY Tipo;

--Transacciones por cliente y tipo de transacción
SELECT 
    ClienteID,
    Tipo,
    COUNT(*) AS Cantidad,
    SUM(Monto) AS Total
FROM Transacciones
GROUP BY ClienteID, Tipo;

--Clientes con más de 2 transacciones (con HAVING)
SELECT 
    ClienteID,
    COUNT(*) AS TotalTransacciones
FROM Transacciones
GROUP BY ClienteID
HAVING COUNT(*) > 2;

