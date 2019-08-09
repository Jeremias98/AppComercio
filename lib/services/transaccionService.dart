import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vivero/models/producto.dart';
import 'package:vivero/models/transaccion.dart';
import 'package:vivero/models/usuario.dart';

class TransaccionService {
  List<Producto> productos;

  Map<String, num> map = new Map<String, num>();

  final Firestore _db = Firestore.instance;

  num contadorUnidades = 1;

  TransaccionService() {
    productos = new List();
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

  obtenerProductosParaGuardar() {
    var mapa = {};
    this.productos.forEach((producto) => mapa[producto.id] = {
          'cantidad': obtenerUnidades(producto),
          'precio_unitario': producto.obtenerPrecioVenta()
        });

    return mapa;
  }

  Future<void> finalizar(Usuario usuario) {
    DocumentReference refTransacciones =
        _db.collection('transacciones').document();

    var batch = _db.batch();

    batch.setData(
        refTransacciones,
        {
          'id_usuario': usuario.id,
          'productos': obtenerProductosParaGuardar(),
          'fecha_creacion': DateTime.now()
        },
        merge: true);

    this.productos.forEach((producto) {
      DocumentReference refProducto =
          _db.collection('productos').document(producto.id);
      batch.updateData(
          refProducto, {'stock': (producto.stock - obtenerUnidades(producto))});
    });

    return batch.commit();

  }
}

final TransaccionService transaccionService = TransaccionService();
