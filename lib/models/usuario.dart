import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  final String id;
  final String uid;
  String nombre;
  final String email;
  final String fotoUrl;
  final DateTime ultimaVez;
  final bool esAdmin;

  Usuario(
      {this.id,
      this.email,
      this.fotoUrl,
      this.ultimaVez,
      this.nombre,
      this.uid,
      this.esAdmin});

  factory Usuario.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Usuario(
        id: doc.documentID,
        uid: data['uid'] ?? '',
        nombre: data['nombre'] ?? 'pipo',
        email: data['email'] ?? 0,
        fotoUrl: data['fotoUrl'] ?? '',
        ultimaVez: data['ultimaVez'] ?? null,
        esAdmin: data['esAdmin']);
  }

  factory Usuario.fromMap(Map data) {
    data = data ?? {};
    return Usuario(
        id: data['id'],
        uid: data['uid'] ?? '',
        nombre: data['nombre'] ?? '',
        email: data['email'] ?? 0,
        fotoUrl: data['fotoUrl'] ?? '',
        ultimaVez: data['ultimaVez'] ?? null,
        esAdmin: data['esAdmin']);
  }
}
