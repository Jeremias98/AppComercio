import 'package:vivero/models/producto.dart';

class Carrito {
  List<Producto> productos;
  Map<String, num> map = new Map<String, num>();

  Carrito() {
    this.productos = List<Producto>();
  }

  void agregar(Producto producto) {
    if (map.containsKey(producto.id)) {
      map[producto.id] = map[producto.id] + 1;
    } else {
      this.productos.add(producto);
      map[producto.id] = 1;
    }
  }

  void agregarPorCantidad(Producto producto, num cantidad) {
    for (num i = 1; i <= cantidad; i++) {
      agregar(producto);
    }
  }

  void quitar(Producto producto) {
    if (!pertenece(producto)) return;
    this.productos.remove(producto);
    map.remove(producto.id);
  }

  void limpiar() {
    this.productos.length = 0;
    map.clear();
  }

  bool pertenece(Producto producto) {
    return productos.map((p) => p.id).contains(producto.id);
  }

  List<Producto> obtenerProductos() {
    return this.productos;
  }

  num obtenerUnidades(Producto producto) {
    return map[producto.id] != null ? map[producto.id] : 0;
  }

  num obtenerTotalUnidades() {
    if (map.values.length == 0) return 0;
    return map.values.reduce((a, b) => a + b);
  }

  obtenerPrecioTotal() {
    num suma = 0;
    productos.forEach((producto) =>
        suma += (producto.obtenerPrecioVenta() * map[producto.id]));
    return suma;
  }
}
