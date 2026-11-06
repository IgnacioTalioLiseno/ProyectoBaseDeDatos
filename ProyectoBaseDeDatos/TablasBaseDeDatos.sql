INSERT INTO DIA (dia_semana) VALUES 
('Lunes'), ('Martes'), ('Miércoles'), ('Jueves'), ('Viernes'), ('Sábado');

INSERT INTO PROVEEDOR (cuit, razon_soc, direccion, tel_fijo) VALUES
(30711223344, 'Calzados Argentinos S.A.', 'Rivadavia 450, Córdoba', '0351-4221100'),
(30655443322, 'Cueros del Centro SRL', 'Constitución 1240, Río Cuarto', '0358-4632211'),
(33544332219, 'Suela y Confort Mayorista', 'Alvear 890, Rosario', '0341-4890011'),
(30998877665, 'Distribuidora Andina', 'San Martín 150, Mendoza', '0261-4209988');

INSERT INTO PROVEEDOR_CELULAR (cuit, celular) VALUES
(30711223344, '351-155123456'),
(30655443322, '358-154332211'),
(33544332219, '341-152445566'),
(30998877665, '261-159887766');

INSERT INTO PERSONA (dni, nombre, apellido, direccion) VALUES
-- Vendedores
(38123456, 'Martín', 'Gómez', 'Sobremonte 234, Río Cuarto'),
(40987654, 'Lucía', 'Fernández', 'General Paz 890, Río Cuarto'),
(42333444, 'Rodrigo', 'Pérez', 'Belgrano 1120, Río Cuarto'),
(44111222, 'Sofía', 'Castro', 'Cabrera 450, Río Cuarto'),
-- Clientes
(35111222, 'Gonzalo', 'Romero', 'San Martín 500, Río Cuarto'),
(28777888, 'Marcela', 'Suárez', 'Bv. Roca 340, Río Cuarto'),
(32444555, 'Esteban', 'Quinteros', 'España 760, Río Cuarto'),
(45123987, 'Camila', 'Domínguez', 'Alberdi 1500, Río Cuarto'),
(29456123, 'Javier', 'Molina', 'Lavalle 320, Río Cuarto');

INSERT INTO VENDEDOR (dni) VALUES 
(38123456), 
(40987654), 
(42333444),
(44111222);

INSERT INTO CLIENTE (dni) VALUES 
(35111222), 
(28777888), 
(32444555), 
(45123987),
(29456123);

INSERT INTO MAYORISTA (dni, descuento) VALUES 
(35111222, 15.00),
(28777888, 20.00),
(29456123, 10.00);

INSERT INTO MINORISTA (dni, fecha_nac) VALUES 
(32444555, '1990-05-14'),
(45123987, '2001-11-28');

INSERT INTO HORARIO (dni_vendedor, dia_semana, hora_entrada, hora_salida) VALUES
(38123456, 'Lunes', '08:30:00', '16:30:00'),
(38123456, 'Martes', '08:30:00', '16:30:00'),
(40987654, 'Lunes', '09:00:00', '17:00:00'),
(42333444, 'Viernes', '10:00:00', '18:00:00'),
(44111222, 'Sábado', '09:00:00', '13:00:00');

INSERT INTO FRANCO (fecha, observaciones, dni_vendedor) VALUES
('2026-01-15', 'Compensatorio fin de semana', 38123456),  -- Martín tuvo franco en enero 2026
('2026-02-10', 'Franco rotativo', 40987654),              -- Lucía y Rodrigo no tuvieron en enero
('2026-03-05', 'Día por trámite', 42333444);                      

INSERT INTO STOCK (nro_talle) VALUES 
(37), (38), (39), (40), (41), (42), (43);

INSERT INTO ZAPATO (color, modelo, precio) VALUES
('Negro', 'Bota Chelsea Urbano', 65000.00),          -- ID 1
('Marrón', 'Zapato Náutico Cuero', 54000.00),       -- ID 2
('Blanco', 'Zapatilla Deportiva Classic', 42000.00), -- ID 3
('Suela', 'Borcego Trekking', 89000.00),            -- ID 4
('Rojo', 'Stiletto Elegance', 72000.00);             -- ID 5 (Sin ventas para la subconsulta)       

-- PROVEEDORES POR ZAPATO
INSERT INTO PROVEE (cuit, id_zapato) VALUES
(30711223344, 1),
(30655443322, 1), 
(30655443322, 2),
(33544332219, 3),
(30655443322, 4),
(30998877665, 4),
(30711223344, 5);

--Stock deposito por talle(todos los pares que se van a vender tienen que existir acá primero)
INSERT INTO TIENE (id_zapato, nro_talle, cantidad) VALUES
(1, 39, 15),
(1, 40, 20),
(1, 41, 10),
(2, 38, 12),
(2, 39, 18),
(2, 40, 8),
(3, 39, 25),
(3, 40, 30),
(4, 41, 14),
(4, 42, 16),
(5, 37, 10), -- Zapato 5 tiene stock pero NUNCA se vende en DET_FACTURACION
(5, 38, 8);

INSERT INTO FACTURA (fecha, monto, descuento, dni_cliente, nro_vendedor) VALUES
('2025-05-10', 130000.00, 0.00, 35111222, 1), -- Fac 1 (2025, Vend 1, Mayorista)
('2025-08-15', 108000.00, 5.00, 32444555, 2), -- Fac 2 (2025, Vend 2, Minorista)
('2025-11-20', 162000.00, 0.00, 35111222, 1), -- Fac 3 (2025, Vend 1, Mayorista)
('2025-12-05', 178000.00, 0.00, 28777888, 3), -- Fac 4 (2025, Vend 3, Mayorista)
('2026-02-14', 84000.00, 10.00, 28777888, 1),  -- Fac 5 (2026)
('2026-11-06', 108000.00, 0.00, 29456123, 1); 

-- Definimos ventas claras donde un talle vende más que otro para el inciso a)
INSERT INTO DET_FACTURACION (nro_factura, id_zapato, nro_talle, cant_venta, precio_venta) VALUES
--Zapato1: Se venden 2 pares del talle 40 y 5 pares del talle 41. Talle 41 es más vendido
(1, 1, 40, 2, 65000.00),
(3, 1, 41, 5, 65000.00),

--Zapato2: Se venden 8 pares del talle 39 y 1 par del talle 40. Talle 39 es el más vendido
(2, 2, 39, 6, 54000.00),
(2, 2, 40, 1, 54000.00),
(6, 2, 39, 2, 54000.00),

--Zapato 3: Se venden 4 pares del talle 40. Talle 40 es el más vendido
(4, 3, 40, 4, 42000.00),

-- Zapato 4: Se venden 2 pares del talle 42. Talle 42 es el más vendido
(4, 4, 42, 2, 89000.00),
(5, 4, 42, 1, 89000.00);



