import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {
  private static final String URL = "jdbc:postgresql://localhost:5432/calzados_sa"; // name folder proyect
  private static final String USER = "postgres";
  private static final String PASS = "postgres";

  public static Connection conectar() throws SQLException {
    return DriverManager.getConnection(URL, USER, PASS);
  }
}
