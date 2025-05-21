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


--Ejemplo 1: Vista de resumen de transacciones con nombre de cliente
CREATE VIEW Vista_ResumenTransacciones AS
SELECT 
    t.TransaccionID,
    c.Nombre,
    t.Fecha,
    t.Monto,
    t.Tipo,
    t.Canal
FROM Transacciones t
JOIN Clientes c ON t.ClienteID = c.ClienteID;

--Puedes consultarla con:
SELECT * FROM Vista_ResumenTransacciones;

--Ejemplo 2: Vista de clasificación de clientes por total movido
CREATE VIEW Vista_ClientesClasificados AS
SELECT 
    c.ClienteID,
    c.Nombre,
    SUM(t.Monto) AS TotalMovido,
    CASE 
        WHEN SUM(t.Monto) > 1000000 THEN 'Alto Valor'
        WHEN SUM(t.Monto) BETWEEN 300000 AND 1000000 THEN 'Medio Valor'
        ELSE 'Bajo Valor'
    END AS Categoria
FROM Clientes c
JOIN Transacciones t ON c.ClienteID = t.ClienteID
GROUP BY c.ClienteID, c.Nombre;
--Luego puedes hacer:
SELECT * FROM Vista_ClientesClasificados WHERE Categoria = 'Alto Valor';

--Ejemplo 3: Vista solo con transacciones de tipo ‘Transferencia’
CREATE VIEW Vista_Transferencias AS
SELECT * 
FROM Transacciones
WHERE Tipo = 'Transferencia';

--Ejemplo 4: Vista para clientes sin transacciones (LEFT JOIN)
CREATE VIEW Vista_ClientesSinTransacciones AS
SELECT c.ClienteID, c.Nombre
FROM Clientes c
LEFT JOIN Transacciones t ON c.ClienteID = t.ClienteID
WHERE t.TransaccionID IS NULL;

--Procedimiento almacenado para agregar información
CREATE PROCEDURE InsertarCliente
    @ClienteID INT,
    @Nombre NVARCHAR(100),
    @Correo NVARCHAR(100),
    @Segmento NVARCHAR(50)
AS
BEGIN
    INSERT INTO Clientes (ClienteID, Nombre, Correo, Segmento)
    VALUES (@ClienteID, @Nombre, @Correo, @Segmento);
END;

--Ejecutando una inserción
EXEC InsertarCliente 
    @ClienteID = 5,
    @Nombre = 'Lucía Ramírez',
    @Correo = 'lucia.ramirez@email.com',
    @Segmento = 'Frecuente';



--Creacion de Tabla de Log
CREATE TABLE LogCambiosClientes (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    ClienteID INT,
    FechaCambio DATETIME,
    Accion NVARCHAR(10)
);

CREATE TRIGGER trg_LogClientes
ON Clientes
AFTER INSERT, DELETE
AS
BEGIN
    -- Insertados = nuevos registros
    INSERT INTO LogCambiosClientes (ClienteID, FechaCambio, Accion)
    SELECT ClienteID, GETDATE(), 'INSERT'
    FROM inserted;

    -- Eliminados = registros borrados
    INSERT INTO LogCambiosClientes (ClienteID, FechaCambio, Accion)
    SELECT ClienteID, GETDATE(), 'DELETE'
    FROM deleted;
END;


