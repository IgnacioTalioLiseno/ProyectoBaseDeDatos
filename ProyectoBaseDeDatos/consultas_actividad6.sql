-- ============================================================================
-- ACTIVIDAD 6: RESOLUCIÓN DE CONSULTAS SQL (Base de Datos Zapatería)
-- Motor: PostgreSQL
-- Base de datos: tp_zapateria
-- ============================================================================

-- ----------------------------------------------------------------------------
-- a) Devolver el Nº más vendido por cada modelo de zapatos.
-- ----------------------------------------------------------------------------
-- Explicación:
-- "Nº" representa el número o talle del zapato (columna 'nro_talle').
-- Se calcula la suma de unidades vendidas ('cant_venta') por cada par (modelo, nro_talle)
-- y se selecciona aquel o aquellos talles que alcancen la máxima cantidad vendida
-- para cada modelo.

-- OPCIÓN 1: Mediante Subconsulta estándar (Compatible con SQL estándar / Álgebra Relacional)
SELECT 
    z.modelo,
    df1.nro_talle AS numero_talle,
    SUM(df1.cant_venta) AS unidades_vendidas
FROM DET_FACTURACION df1
JOIN ZAPATO z ON df1.id_zapato = z.id_zapato
GROUP BY z.id_zapato, z.modelo, df1.nro_talle
HAVING SUM(df1.cant_venta) >= ALL (
    SELECT SUM(df2.cant_venta)
    FROM DET_FACTURACION df2
    WHERE df2.id_zapato = z.id_zapato
    GROUP BY df2.nro_talle
)
ORDER BY z.modelo;

-- OPCIÓN 2: Mediante Funciones de Ventana (Window Functions - RANK)
WITH VentasPorTalle AS (
    SELECT 
        z.modelo,
        df.nro_talle AS numero_talle,
        SUM(df.cant_venta) AS unidades_vendidas,
        RANK() OVER (PARTITION BY z.id_zapato ORDER BY SUM(df.cant_venta) DESC) AS ranking
    FROM DET_FACTURACION df
    JOIN ZAPATO z ON df.id_zapato = z.id_zapato
    GROUP BY z.id_zapato, z.modelo, df.nro_talle
)
SELECT modelo, numero_talle, unidades_vendidas
FROM VentasPorTalle
WHERE ranking = 1
ORDER BY modelo;


-- ----------------------------------------------------------------------------
-- b) Listado de vendedores con sus ventas totales (monto total) durante 2025.
-- ----------------------------------------------------------------------------
-- Explicación:
-- Se cruza VENDEDOR con PERSONA para obtener datos personales y con FACTURA
-- filtrando por el año 2025 mediante EXTRACT(YEAR FROM fecha).
-- Usamos LEFT JOIN para incluir a todos los vendedores registrados, incluso si 
-- no concretaron ventas en dicho año (asignándoles 0.00 con COALESCE).

SELECT 
    v.nro_vendedor,
    p.apellido,
    p.nombre,
    COALESCE(SUM(f.monto), 0.00) AS monto_total_ventas_2025
FROM VENDEDOR v
JOIN PERSONA p ON v.dni = p.dni
LEFT JOIN FACTURA f ON v.nro_vendedor = f.nro_vendedor 
    AND EXTRACT(YEAR FROM f.fecha) = 2025
GROUP BY v.nro_vendedor, p.apellido, p.nombre
ORDER BY monto_total_ventas_2025 DESC;


-- ----------------------------------------------------------------------------
-- c) Apellido y Nombre de los vendedores que no han tenido francos en enero de 2026.
-- ----------------------------------------------------------------------------
-- Explicación:
-- Buscamos los vendedores registrados cuyo DNI no aparezca asociado a un franco 
-- en el rango '2026-01-01' a '2026-01-31'.

-- OPCIÓN 1: Subconsulta con NOT IN
SELECT 
    p.apellido, 
    p.nombre
FROM VENDEDOR v
JOIN PERSONA p ON v.dni = p.dni
WHERE v.dni NOT IN (
    SELECT f.dni_vendedor
    FROM FRANCO f
    WHERE f.fecha >= '2026-01-01' AND f.fecha <= '2026-01-31'
)
ORDER BY p.apellido, p.nombre;

-- OPCIÓN 2: Subconsulta correlacionada con NOT EXISTS
SELECT 
    p.apellido, 
    p.nombre
FROM VENDEDOR v
JOIN PERSONA p ON v.dni = p.dni
WHERE NOT EXISTS (
    SELECT 1
    FROM FRANCO f
    WHERE f.dni_vendedor = v.dni
      AND f.fecha >= '2026-01-01' AND f.fecha <= '2026-01-31'
)
ORDER BY p.apellido, p.nombre;


-- ----------------------------------------------------------------------------
-- d) Consultas Propias (no menos de tres, al menos una con subconsultas)
-- ----------------------------------------------------------------------------

-- CONSULTA PROPIA 1 (Utiliza SUBCONSULTAS: una en WHERE y otra en SELECT):
-- Enunciado:
-- "Listar los modelos de zapatos cuyo precio supera el precio promedio general 
-- de todos los zapatos del catálogo, mostrando además cuántos proveedores diferentes 
-- abastecen a dicho modelo."
SELECT 
    z.id_zapato, 
    z.modelo, 
    z.color, 
    z.precio,
    (SELECT COUNT(*) 
     FROM PROVEE pr 
     WHERE pr.id_zapato = z.id_zapato) AS cantidad_proveedores
FROM ZAPATO z
WHERE z.precio > (SELECT AVG(precio) FROM ZAPATO)
ORDER BY z.precio DESC;


-- CONSULTA PROPIA 2 (Utiliza SUBCONSULTA con NOT IN / Conjuntos):
-- Enunciado:
-- "Identificar aquellos modelos de calzados que actualmente cuentan con stock disponible 
-- en el depósito (tabla TIENE), pero que todavía nunca han sido vendidos en ninguna factura."
SELECT 
    z.id_zapato, 
    z.modelo, 
    z.color, 
    z.precio,
    SUM(t.cantidad) AS stock_total_en_deposito
FROM ZAPATO z
JOIN TIENE t ON z.id_zapato = t.id_zapato
WHERE z.id_zapato NOT IN (
    SELECT DISTINCT df.id_zapato 
    FROM DET_FACTURACION df
)
GROUP BY z.id_zapato, z.modelo, z.color, z.precio
HAVING SUM(t.cantidad) > 0
ORDER BY stock_total_en_deposito DESC;


-- CONSULTA PROPIA 3 (Agrupación, Joins y Filtro por Agregación HAVING):
-- Enunciado:
-- "Listar los clientes mayoristas que han acumulado compras superiores a $100.000, 
-- detallando su DNI, Nombre completo, porcentaje de descuento asignado y el total gastado."
SELECT 
    m.dni, 
    p.apellido, 
    p.nombre, 
    m.descuento AS porcentaje_descuento, 
    SUM(f.monto) AS monto_total_acumulado
FROM MAYORISTA m
JOIN PERSONA p ON m.dni = p.dni
JOIN FACTURA f ON m.dni = f.dni_cliente
GROUP BY m.dni, p.apellido, p.nombre, m.descuento
HAVING SUM(f.monto) > 100000.00
ORDER BY monto_total_acumulado DESC;
