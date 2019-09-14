import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vivero/clases/carrito.dart';
import 'package:vivero/models/usuario.dart';

class TransaccionService extends Carrito {
  final Firestore _db = Firestore.instance;

  TransaccionService() : super();

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
