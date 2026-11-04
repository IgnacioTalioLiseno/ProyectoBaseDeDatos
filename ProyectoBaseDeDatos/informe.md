# Universidad Nacional de Río Cuarto

**Facultad de Ciencias Exactas, Físico-Químicas y Naturales**
**Departamento de Computación**
**Asignatura:** BASES DE DATOS (3384) - Año 2026

## Trabajo Práctico Integrador: "Calzados S.A."

**Informe de Entrega (Puntos 3, 4, 5 y 6)**

**Integrantes del grupo:**

- Lucero, Facundo
- Migliorini, Nicolás
- Talio, Ignacio
- Martinez, Maximiliano
- Morosi, Agustín

###### Github: <https://github.com/IgnacioTalioLiseno/ProyectoBaseDeDatos>

---

### 1. Elección del Motor de Base de Datos

Para la implementación de este proyecto, nuestro grupo optó por utilizar **PostgreSQL**, cumpliendo con las opciones sugeridas por la cátedra.

Tomamos esta decisión principalmente por la robustez que ofrece PostgreSQL para manejar la integridad referencial y su potente lenguaje procedimental. Esto nos facilitó mucho la tarea de programar los triggers que pedía la consigna para la auditoría, además de darnos acceso a tipos de datos muy útiles como `SERIAL` para la autogeneración de claves, lo cual simplificó el diseño de las tablas.

### 2. Decisiones de Diseño y Particularidades de la Implementación

Durante el proceso de pasar nuestro modelo Entidad-Relación al modelo Relacional y luego al código SQL, nos encontramos con varios desafíos que resolvimos de la siguiente manera:

- **Mapeo de las Jerarquías (Herencia):**
  En nuestro modelo teníamos jerarquías claras: una `PERSONA` puede ser `VENDEDOR` o `CLIENTE`, y a su vez un `CLIENTE` puede ser `MAYORISTA` o `MINORISTA`. Para pasarlo a tablas, decidimos mantener el `DNI` como Clave Primaria en todas estas tablas. Al mismo tiempo, este `DNI` funciona como Clave Foránea apuntando a la tabla "padre". Le agregamos la restricción `ON DELETE CASCADE` para que, si el día de mañana la zapatería elimina a una "Persona", automáticamente se borren sus datos específicos como cliente o vendedor sin dejar registros huérfanos.

- **Generación del Número de Vendedor:**
  La consigna pedía explícitamente que los números de los vendedores debían ser generados. Para no depender del programa en Java para esto, le delegamos la responsabilidad al motor. En la tabla `VENDEDOR`, creamos la columna `nro_vendedor SERIAL NOT NULL` y le pusimos una restricción `UNIQUE`. De esta forma, el DNI sigue siendo la clave primaria que lo vincula como persona, pero el sistema le asigna automáticamente un número de legajo único (1, 2, 3, etc.).

- **Restricciones de Dominio (CHECKs):**
  Para proteger la base de datos de ingresos erróneos, llenamos las tablas de restricciones `CHECK`. Por ejemplo, en la tabla `ZAPATO` nos aseguramos de que el precio sea mayor a 0 y menor a $200.000 como pedía el enunciado. También limitamos los descuentos (tanto de mayoristas como de las facturas) para que solo acepten valores entre 0.00 y 100.00.

- **Implementación de la Auditoría (Trigger):**
  Este fue uno de los puntos más interesantes. Se nos pedía guardar automáticamente el historial de cambios de precios de los zapatos. Para resolverlo, creamos la tabla `AUDITORIA_PRECIO_ZAPATO` y luego programamos una función en `plpgsql` que compara el precio viejo (`OLD.precio`) con el nuevo (`NEW.precio`). Si son distintos, inserta un registro con la fecha actual y usa la variable del sistema `CURRENT_USER` para saber qué usuario de la base de datos hizo el `UPDATE`. Finalmente, atamos esta función a un `TRIGGER` que se dispara `AFTER UPDATE` en la tabla `ZAPATO`.

### 3. Organización de los Scripts y Carga de Datos

Para mantener el trabajo ordenado, dividimos la entrega en dos archivos SQL distintos, en los cuales todos los integrantes participamos de manera colaborativa:

1. **`BaseDeDatosZapateria.sql`:**
   Este script contiene toda la definición estructural. También incluye la creación de la función y el trigger de auditoría.

2. **`TablasBaseDeDatos.sql`:**
   Aquí armamos un lote de inserciones (`INSERT INTO`) para poblar la base de datos. Nos preocupamos por cargar datos de prueba coherentes: varios modelos de zapatos, distintos talles con su stock, proveedores, vendedores y algunos clientes (tanto mayoristas como minoristas).
   *Nota:* Al final de este archivo, incluimos a propósito una sentencia `UPDATE ZAPATO SET precio = 69900.00 WHERE id_zapato = 1;`. La pusimos para que los docentes, al correr el script, puedan ir a la tabla de auditoría y comprobar que el Trigger funciona perfectamente y registra el cambio.

### 4. Programa Java - Gestión de Proveedores (Punto 5)

Para resolver la interacción con la base de datos desde Java, usamos la API JDBC junto con el driver `postgresql-42.7.5.jar`. Para estructurar el código de forma clara y modular, lo dividimos en tres clases:

- **`Conexion.java`:** Centraliza la conexión al motor PostgreSQL mediante `DriverManager.getConnection()`, facilitando cambiar o ajustar los parámetros de conexión en un solo lugar.
- **`Metodos.java`:** Implementa la lógica para las tres operaciones solicitadas:
  - *Insertar datos de proveedores:* Recibe los datos y utiliza un `PreparedStatement` parametrizado (`?`) para evitar inyección SQL y manipular el CUIT con el tipo numérico `long`.
  - *Eliminar un proveedor dado su CUIT:* Ejecuta el `DELETE FROM PROVEEDOR WHERE cuit = ?` mediante un `PreparedStatement`, controlando e informando por consola la cantidad de filas afectadas.
  - *Listar todos los proveedores:* Ejecuta una consulta con `Statement` y recorre el `ResultSet` imprimiendo en pantalla los datos de cada proveedor cargado.
- **`Main.java`:** Es el punto de entrada donde instanciamos la clase de métodos y ejecutamos las pruebas de inserción, listado y eliminación.

### 5. Resolución de Consultas SQL (Punto 6)

Resolvimos todas las consultas pedidas en el archivo `consultas_actividad6.sql`, empleando la sintaxis y operaciones de reunión y agrupamiento vistas en las clases:

- **a) Número más vendido por cada modelo de zapatos:**
  Considerando el "número" como el talle del calzado (`nro_talle`), agrupamos las ventas por modelo y número sumando las cantidades vendidas (`SUM(cant_venta)`). Para quedarnos con el talle que alcanzó el máximo de ventas por modelo, utilizamos una subconsulta con `HAVING ... >= ALL (...)`:
  ```sql
  SELECT 
      z.modelo,
      df1.nro_talle AS numero_talle,
      SUM(df1.cant_venta) AS unidades_vendidas
  FROM DET_FACTURACION df1
  INNER JOIN ZAPATO z ON (df1.id_zapato = z.id_zapato)
  GROUP BY z.id_zapato, z.modelo, df1.nro_talle
  HAVING SUM(df1.cant_venta) >= ALL (
      SELECT SUM(df2.cant_venta)
      FROM DET_FACTURACION df2
      WHERE df2.id_zapato = z.id_zapato
      GROUP BY df2.nro_talle
  )
  ORDER BY z.modelo;
  ```

- **b) Listado de vendedores con sus ventas totales durante 2025:**
  Reunimos `VENDEDOR` con `PERSONA` y aplicamos un `LEFT OUTER JOIN` con `FACTURA` filtrando las fechas con `BETWEEN '2025-01-01' AND '2025-12-31'`. De esta manera, se listan todos los vendedores registrados, incluso si alguno no registró ventas en dicho año:
  ```sql
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
  ```

- **c) Vendedores que no tuvieron francos en enero de 2026:**
  Buscamos a los vendedores cuyo DNI no se encuentre registrado en `FRANCO` para las fechas de enero de 2026. Lo resolvimos mediante una subconsulta con `NOT EXISTS`:
  ```sql
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
  ```

- **d) Consultas Propias:**
  Planteamos tres consultas útiles para el negocio aplicando subconsultas y filtros por agregación:

  1. *Modelos con precio superior al promedio del catálogo y cantidad de proveedores:*
     Utiliza una subconsulta escalar en el `WHERE` para calcular el `AVG(precio)` de los zapatos, junto con `LEFT OUTER JOIN` y `GROUP BY` para contar cuántos proveedores abastecen a cada uno.
     ```sql
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
     ```

  2. *Modelos con stock disponible en depósito pero que nunca fueron vendidos:*
     Aplica una subconsulta con `NOT IN` sobre `DET_FACTURACION` y agrupa por calzado con `HAVING SUM(t.cantidad) > 0` para detectar productos sin rotación de ventas.
     ```sql
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
     ```

  3. *Clientes mayoristas con compras acumuladas superiores a $100.000:*
     Aplica reuniones internas entre `MAYORISTA`, `PERSONA` y `FACTURA`, agrupando los datos del cliente y filtrando el acumulado mediante `HAVING SUM(f.monto) > 100000.00`.
     ```sql
     SELECT 
         m.dni, 
         p.apellido, 
         p.nombre, 
         m.descuento AS porcentaje_descuento, 
         SUM(f.monto) AS monto_total_acumulado
     FROM MAYORISTA m
     INNER JOIN PERSONA p ON (m.dni = p.dni)
     INNER JOIN FACTURA f ON (m.dni = f.dni_cliente)
     GROUP BY m.dni, p.apellido, p.nombre, m.descuento
     HAVING SUM(f.monto) > 100000.00
     ORDER BY monto_total_acumulado DESC;
     ```
