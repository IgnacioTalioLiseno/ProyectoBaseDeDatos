import java.sql.*;

public class Metodos {

  public void insertarProveedor(long cuit, String razonSoc, String direccion, String telFijo) {
    String sql = "INSERT INTO PROVEEDOR (cuit, razon_soc, direccion, tel_fijo) VALUES (?, ?, ?, ?)";

    try (Connection conn = Conexion.conectar();
        PreparedStatement sentenciaPreparada = conn.prepareStatement(sql)) {

      sentenciaPreparada.setLong(1, cuit);
      sentenciaPreparada.setString(2, razonSoc);
      sentenciaPreparada.setString(3, direccion);
      sentenciaPreparada.setString(4, telFijo);

      sentenciaPreparada.executeUpdate();
      System.out.println("¡Proveedor insertado exitosamente!");

    } catch (SQLException e) {
      System.err.println("Error al insertar proveedor: " + e.getMessage());
    }
  }

  public void eliminarProveedor(long cuit) {
    String sql = "DELETE FROM PROVEEDOR WHERE cuit = ?";

    try (Connection conn = Conexion.conectar();
        PreparedStatement sentenciaPreparada = conn.prepareStatement(sql)) {

      sentenciaPreparada.setLong(1, cuit);
      int filasAfectadas = sentenciaPreparada.executeUpdate();

      if (filasAfectadas > 0) {
        System.out.println("Proveedor eliminado correctamente.");
      } else {
        System.out.println("No se encontró ningún proveedor con el CUIT especificado.");
      }

    } catch (SQLException e) {
      System.err.println("Error al eliminar proveedor: " + e.getMessage());
    }
  }

  public void listarProveedores() {
    String sql = "SELECT cuit, razon_soc, direccion, tel_fijo FROM PROVEEDOR";

    try (Connection conn = Conexion.conectar();
        Statement sentencia = conn.createStatement();
        ResultSet res = sentencia.executeQuery(sql)) {

      System.out.println("\n--- LISTADO DE PROVEEDORES ---");
      boolean hayRegistros = false;

      while (res.next()) {
        hayRegistros = true;
        System.out.printf("CUIT: %d | Razón Social: %s | Dirección: %s | Tel. Fijo: %s%n",
            res.getLong("cuit"),
            res.getString("razon_soc"),
            res.getString("direccion"),
            res.getString("tel_fijo"));
      }

      if (!hayRegistros) {
        System.out.println("No hay proveedores registrados en la base de datos.");
      }

    } catch (SQLException e) {
      System.err.println("Error al listar proveedores: " + e.getMessage());
    }
  }
}
