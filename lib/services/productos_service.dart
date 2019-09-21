import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vivero/clases/carrito.dart';
import 'package:vivero/models/producto.dart';
import 'package:vivero/models/usuario.dart';
import 'package:vivero/models/valor_temporal.dart';
import 'package:vivero/services/auth.dart';

class ProductosService {
  Usuario usuario;
  Carrito carrito;
  final Firestore _db = Firestore.instance;

  // constructor
  ProductosService() {
    authService.profile.listen((usuario) => this.usuario = usuario);
    carrito = new Carrito();
  }

  obtenerProductos() async {
    QuerySnapshot querySnapshot =
        await _db.collection('productos').getDocuments();

    List<Producto> productos = new List();

    for (DocumentSnapshot docProducto in querySnapshot.documents) {
      Producto producto = Producto.fromFirestore(docProducto);
      productos.add(producto);
    }

    return productos;
  }

  obtenerPorQR(String codigoQR) {
    if (codigoQR == null || codigoQR == "") return Observable.just({});
    return _db
        .collection('productos')
        .document(codigoQR)
        .snapshots()
        .map((snap) => Producto.fromFirestore(snap));
  }

  void guardarProducto(Producto producto) async {
    DocumentReference ref = _db.collection('productos').document();

    return ref.setData({
      'nombre': producto.nombre,
      'fotoUrl': producto.fotoUrl,
      'precioUnitario': producto.precioUnitario,
      'stock': producto.stock,
      'porcentajeGanancia': producto.porcentajeGanancia,
      'descripcion': producto.descripcion
    }, merge: true);
  }

  Future<void> renovarStockYPrecios(List<Producto> productos,
      Map<String, num> nuevoStock, Map<String, num> nuevoPrecio) async {
    var batch = _db.batch();

    productos.forEach((producto) {
      if (nuevoStock[producto.id] != null || nuevoPrecio[producto.id] != null) {
        DocumentReference refProducto =
            _db.collection('productos').document(producto.id);

        num stock = nuevoStock[producto.id] != null
            ? producto.stock + nuevoStock[producto.id]
            : producto.stock;

        num precio = nuevoPrecio[producto.id] != null
            ? nuevoPrecio[producto.id]
            : producto.precioUnitario;

        var fechaActual = DateTime.now();

        if (nuevoStock[producto.id] != null)
          producto.stockHistorico.add(new ValorTemporal(
              valor: nuevoStock[producto.id], fecha: fechaActual));

        if (nuevoPrecio[producto.id] != null)
          producto.precioHistorico.add(new ValorTemporal(
              valor: nuevoPrecio[producto.id], fecha: fechaActual));

        batch.updateData(refProducto, {
          'stock': stock,
          'precioUnitario': precio,
          'precioHistorico': producto.precioHistorico,
          'stockHistorico': producto.stockHistorico
        });
      }
    });

    return batch.commit();
  }
}

final ProductosService productosService = ProductosService();
