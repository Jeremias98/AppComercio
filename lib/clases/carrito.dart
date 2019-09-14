import 'package:vivero/models/producto.dart';

class Carrito {
  List<Producto> productos;
  Map<String, num> _map = new Map<String, num>();

  Carrito() {
    this.productos = List<Producto>();
  }

  void agregar(Producto producto) {
    if (_map.containsKey(producto.id)) {
      _map[producto.id] = _map[producto.id] + 1;
    } else {
      this.productos.add(producto);
      _map[producto.id] = 1;
    }
  }

  void agregarPorCantidad(Producto producto, num cantidad) {
    for (num i = 1; i <= cantidad; i++) {
      agregar(producto);
    }
  }

  void quitar(Producto producto) {
    if (!pertenece(producto)) return;
    this.productos.removeWhere((p) => p.id == producto.id);
    _map.remove(producto.id);
  }

  void limpiar() {
    this.productos.length = 0;
    _map.clear();
  }

  bool pertenece(Producto producto) {
    return _map[producto.id] != null ? _map[producto.id] > 0 : false;
  }

  List<Producto> obtenerProductos() {
    return this.productos;
  }

  num obtenerUnidades(Producto producto) {
    return _map[producto.id] != null ? _map[producto.id] : 0;
  }

  num obtenerTotalUnidades() {
    if (_map.values.length == 0) return 0;
    return _map.values.reduce((a, b) => a + b);
  }

  bool estaVacio() {
    return obtenerTotalUnidades() == 0;
  }

  obtenerPrecioTotal() {
    num suma = 0;
    productos.forEach((producto) =>
        suma += (producto.obtenerPrecioVenta() * _map[producto.id]));
    return suma;
  }
}
