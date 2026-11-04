# Universidad Nacional de Río Cuarto

**Facultad de Ciencias Exactas, Físico-Químicas y Naturales**
**Departamento de Computación**
**Asignatura:** BASES DE DATOS (3384) - Año 2026

## Trabajo Práctico Integrador: "Calzados S.A."

**Informe de Segunda Entrega (Puntos 3 y 4)**

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
