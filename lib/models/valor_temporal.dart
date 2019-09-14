import 'package:cloud_firestore/cloud_firestore.dart';

class ValorTemporal {
  dynamic valor;
  dynamic fecha;

  ValorTemporal({this.valor, this.fecha});

  factory ValorTemporal.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return ValorTemporal(
        valor: data['valor'] ?? null,
        fecha: data['fecha'] ?? DateTime.now());
  }
}
