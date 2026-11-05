--a) Devolver el Nº más vendido por cada modelo de zapatos.
SELECT 
    z.modelo,
    df1.nro_talle AS talle_mas_vendido,
    SUM(df1.cant_venta) AS unidades_vendidas
FROM DET_FACTURACION df1
INNER JOIN ZAPATO z ON df1.id_zapato = z.id_zapato
GROUP BY z.id_zapato, z.modelo, df1.nro_talle
HAVING SUM(df1.cant_venta) >= ALL (
    SELECT SUM(df2.cant_venta)
    FROM DET_FACTURACION df2
    WHERE df2.id_zapato = z.id_zapato
    GROUP BY df2.nro_talle
)
ORDER BY z.modelo;

-- b) Listado de vendedores con sus ventas totales (monto total) durante 2025.
SELECT 
    v.nro_vendedor,
    p.apellido,
    p.nombre,
    SUM(f.monto) AS monto_total_ventas_2025
FROM VENDEDOR v
INNER JOIN PERSONA p ON (v.dni = p.dni)
LEFT OUTER JOIN FACTURA f ON (v.nro_vendedor = f.nro_vendedor 
    AND f.fecha BETWEEN '2025-01-01' AND '2025-12-31')
GROUP BY v.nro_vendedor, p.apellido, p.nombre
ORDER BY monto_total_ventas_2025 DESC;

-- c) Apellido y Nombre de los vendedores que no han tenido francos en enero de 2026.
SELECT 
    p.apellido, 
    p.nombre
FROM VENDEDOR v
INNER JOIN PERSONA p ON (v.dni = p.dni)
WHERE NOT EXISTS (
    SELECT *
    FROM FRANCO f
    WHERE f.dni_vendedor = v.dni
      AND f.fecha BETWEEN '2026-01-01' AND '2026-01-31'
)
ORDER BY p.apellido, p.nombre;

-- d)Consultas propias:

--"Identificar los modelos de calzados que actualmente cuentan con stock disponible, 
-- pero que todavia nunca han sido vendidos en ningun factura. 
--(subconsulta con NOT IN)
SELECT 
    z.id_zapato, 
    z.modelo, 
    z.color, 
    z.precio,
    SUM(t.cantidad) AS stock_total_en_deposito
FROM ZAPATO z
INNER JOIN TIENE t ON (z.id_zapato = t.id_zapato)
WHERE z.id_zapato NOT IN (
    SELECT DISTINCT df.id_zapato 
    FROM DET_FACTURACION df
)
GROUP BY z.id_zapato, z.modelo, z.color, z.precio
HAVING SUM(t.cantidad) > 0
ORDER BY stock_total_en_deposito DESC;

-- "listar los modelos de zapatos cuyo precio supera el promedio general de todos los zapatos,
--mostrando tambien cuantos proveedores diferentes abastecen a dicho modelos.
--(subconsulta con func. agregada AVG)
SELECT 
    z.modelo, 
    z.color, 
    z.precio,
    COUNT(DISTINCT pr.cuit) AS cantidad_proveedores
FROM ZAPATO z
LEFT OUTER JOIN PROVEE pr ON (z.id_zapato = pr.id_zapato)
WHERE z.precio > (SELECT AVG(precio) FROM ZAPATO)
GROUP BY z.id_zapato, z.modelo, z.color, z.precio
ORDER BY z.precio DESC;

--listar los clientes mayoristas que han acumulado compras superiores a $100.000, 
--detallando su DNI, nombre completo, procentaje de descuento asignado y el total gastado
--(subconsulta con IN) 
SELECT 
    f.dni_cliente AS dni, 
    p.apellido, 
    p.nombre, 
    (SELECT m.descuento FROM MAYORISTA m WHERE m.dni = f.dni_cliente) AS porcentaje_descuento,
    SUM(f.monto) AS monto_total_acumulado
FROM FACTURA f
INNER JOIN PERSONA p ON (f.dni_cliente = p.dni)
WHERE f.dni_cliente IN (
    SELECT m.dni 
    FROM MAYORISTA m
)
GROUP BY f.dni_cliente, p.apellido, p.nombre
HAVING SUM(f.monto) > 100000.00
ORDER BY monto_total_acumulado DESC;