public class Main {
  public static void main(String[] args) {
    Metodos dao = new Metodos();

    // Prueba de inserción (usando un CUIT como long)
    dao.insertarProveedor(30711122223L, "Calzados Mayorista del Sur", "Av. Sabattini 1200", "0358-4567890");

    // Prueba de listar
    dao.listarProveedores();

    // Prueba de eliminación por CUIT
    // dao.eliminarProveedor(30711122223L);
  }
}
