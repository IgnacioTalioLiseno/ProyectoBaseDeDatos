INSERT INTO DIA (dia_semana) VALUES 
('Lunes'), ('Martes'), ('Miércoles'), ('Jueves'), ('Viernes'), ('Sábado');

INSERT INTO PROVEEDOR (cuit, razon_soc, direccion, tel_fijo) VALUES
(30711223344, 'Calzados Argentinos S.A.', 'Rivadavia 450, Córdoba', '0351-4221100'),
(30655443322, 'Cueros del Centro SRL', 'Constitución 1240, Río Cuarto', '0358-4632211'),
(33544332219, 'Suela y Confort Mayorista', 'Alvear 890, Rosario', '0341-4890011');

INSERT INTO PROVEEDOR_CELULAR (cuit, celular) VALUES
(30711223344, '351-155123456'),
(30711223344, '351-156987654'),
(30655443322, '358-154332211'),
(33544332219, '341-152445566');

INSERT INTO PERSONA (dni, nombre, apellido, direccion) VALUES
-- Vendedores
(38123456, 'Martín', 'Gómez', 'Sobremonte 234, Río Cuarto'),
(40987654, 'Lucía', 'Fernández', 'General Paz 890, Río Cuarto'),
(42333444, 'Rodrigo', 'Pérez', 'Belgrano 1120, Río Cuarto'),
-- Clientes
(35111222, 'Gonzalo', 'Romero', 'San Martín 500, Río Cuarto'),
(28777888, 'Marcela', 'Suárez', 'Bv. Roca 340, Río Cuarto'),
(32444555, 'Esteban', 'Quinteros', 'España 760, Río Cuarto'),
(45123987, 'Camila', 'Domínguez', 'Alberdi 1500, Río Cuarto');

INSERT INTO VENDEDOR (dni) VALUES 
(38123456), 
(40987654), 
(42333444);

INSERT INTO CLIENTE (dni) VALUES 
(35111222), 
(28777888), 
(32444555), 
(45123987);

INSERT INTO MAYORISTA (dni, descuento) VALUES 
(35111222, 15.00),
(28777888, 20.00);

INSERT INTO MINORISTA (dni, fecha_nac) VALUES 
(32444555, '1990-05-14'),
(45123987, '2001-11-28');

INSERT INTO HORARIO (dni_vendedor, dia_semana, hora_entrada, hora_salida) VALUES
(38123456, 'Lunes', '08:30:00', '16:30:00'),
(38123456, 'Martes', '08:30:00', '16:30:00'),
(40987654, 'Lunes', '09:00:00', '17:00:00'),
(42333444, 'Viernes', '10:00:00', '18:00:00');

INSERT INTO FRANCO (fecha, observaciones, dni_vendedor) VALUES
('2026-01-15', 'Compensatorio fin de semana', 38123456),  
('2026-02-10', 'Franco rotativo', 40987654);            

INSERT INTO STOCK (nro_talle) VALUES 
(37), (38), (39), (40), (41), (42), (43);

INSERT INTO ZAPATO (color, modelo, precio) VALUES
('Negro', 'Bota Chelsea Urbano', 65000.00),         
('Marrón', 'Zapato Náutico Cuero', 54000.00),     
('Blanco', 'Zapatilla Deportiva Classic', 42000.00), 
('Suela', 'Borcego Trekking', 89000.00);            

INSERT INTO PROVEE (cuit, id_zapato) VALUES
(30711223344, 1),
(30655443322, 1), 
(30655443322, 2),
(33544332219, 3),
(30655443322, 4);

INSERT INTO TIENE (id_zapato, nro_talle, cantidad) VALUES
(1, 39, 10),
(1, 40, 15),
(1, 41, 8),
(2, 40, 5),
(2, 41, 12),
(3, 38, 20),
(3, 39, 25),
(4, 42, 6);

INSERT INTO FACTURA (fecha, monto, descuento, dni_cliente, dni_vendedor) VALUES
('2025-06-15', 130000.00, 0.00, 35111222, 38123456); 

INSERT INTO DET_FACTURACION (nro_factura, id_zapato, nro_talle, cant_venta, precio_venta) VALUES
(1, 1, 40, 2, 65000.00);

INSERT INTO FACTURA (fecha, monto, descuento, dni_cliente, dni_vendedor) VALUES
('2025-11-20', 108000.00, 5.00, 32444555, 40987654); 

INSERT INTO DET_FACTURACION (nro_factura, id_zapato, nro_talle, cant_venta, precio_venta) VALUES
(2, 2, 41, 2, 54000.00);

INSERT INTO FACTURA (fecha, monto, descuento, dni_cliente, dni_vendedor) VALUES
('2026-03-10', 84000.00, 10.00, 28777888, 38123456); 

INSERT INTO DET_FACTURACION (nro_factura, id_zapato, nro_talle, cant_venta, precio_venta) VALUES
(3, 3, 39, 2, 42000.00);

UPDATE ZAPATO 
SET precio = 69900.00 
WHERE id_zapato = 1;