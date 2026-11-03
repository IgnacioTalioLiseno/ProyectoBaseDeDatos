# Comandos

### correr main, para ver la conexion de java y db

### Instrucciones recomendadas

* **Descargar el driver JDBC de PostgreSQL** (versión compatible con **Java 8**).
* **Enlace de descarga:** [Descargas oficiales de PostgreSQL JDBC](https://jdbc.postgresql.org/download/#latest-versions) *(Buscar la versión `postgresql-42.7.14` que soporte Java 8).*

---

### Versión corta (para una lista de tareas)

* Descargar el driver JDBC de PostgreSQL para **Java 8**: [Enlace de descarga](https://jdbc.postgresql.org/download/#latest-versions)

* Compilar todos los archivos java y el jar de postgresql-42

```bash
javac -cp .:postgresql-42.7.14.jar *.java
```

* Para ejecutar

```bash
java -cp .:postgresql-42.7.14.jar Main
```
