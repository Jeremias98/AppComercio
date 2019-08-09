import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vivero/models/producto.dart';

class Transaccion {
  final String id;
  final String idUsuario;
  final List<Producto> productos;
  final DateTime fechaCreacion;

  Transaccion({this.id, this.idUsuario, this.productos, this.fechaCreacion});

  factory Transaccion.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Transaccion(
      id: doc.documentID,
      idUsuario: data['id_usuario'] ?? '',
      productos: data['productos'] ?? new List(),
      fechaCreacion: data['fecha_creacion'] ?? null,
    );
  }

  factory Transaccion.fromMap(Map data) {
    data = data ?? {};
    return Transaccion(
      id: data['id'],
      idUsuario: data['id_usuario'] ?? '',
      productos: data['productos'] ?? new List(),
      fechaCreacion: data['fecha_creacion'] ?? null,
    );
  }
}
