import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vivero/models/producto.dart';
import 'package:vivero/models/usuario.dart';
import 'package:vivero/services/auth.dart';

class TransaccionService {
  List<Producto> productos;

  var map = new Map<String, num>();

  Usuario usuario;
  final Firestore _db = Firestore.instance;

  // constructor
  TransaccionService() {
    productos = new List();
    authService.profile.listen((usuario) => this.usuario = usuario);
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
    if (map.containsKey(producto.id)) {
      map[producto.id] = map[producto.id] + cantidad;
    } else {
      this.productos.add(producto);
      map[producto.id] = cantidad;
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

  List<Producto> obtener() {
    return this.productos;
  }

  obtenerUnidades(Producto producto) {
    return map[producto.id];
  }

  obtenerTotalUnidades() {
    if (map.values.length == 0) return 0;
    return map.values.reduce((a, b) => a + b);
  }

  obtenerPrecioTotal() {
    num suma = 0;
    productos.forEach((producto) =>
        suma += (producto.obtenerPrecioVenta() * map[producto.id]));
    return suma;
  }

  finalizar() async {
    DocumentReference ref =
        _db.collection('transacciones').document(usuario.uid);

    return ref.setData({'productos': this.productos});
  }
}

final TransaccionService transaccionService = TransaccionService();
