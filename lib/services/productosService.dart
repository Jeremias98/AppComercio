import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vivero/models/producto.dart';
import 'package:vivero/models/usuario.dart';
import 'package:vivero/services/auth.dart';

class ProductosService {
  Usuario usuario;
  final Firestore _db = Firestore.instance;

  // constructor
  ProductosService() {
    authService.profile.listen((usuario) => this.usuario = usuario);
  }

  obtener() async {
    QuerySnapshot querySnapshot =
        await _db.collection('productos').getDocuments();

    List<Producto> productos = new List();
    querySnapshot.documents.forEach((snapshot) {
      Producto producto = Producto.fromFirestore(snapshot);
      productos.add(producto);
    });

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
}

final ProductosService productosService = ProductosService();
