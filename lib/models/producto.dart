import 'package:cloud_firestore/cloud_firestore.dart';

class Producto {
  final String id;
  final String nombre;
  final String fotoUrl;
  final num precioUnitario;
  final int stock;
  final num porcentajeGanancia;
  final String descripcion;

  Producto(
      {this.id,
      this.nombre,
      this.fotoUrl,
      this.precioUnitario,
      this.stock,
      this.porcentajeGanancia,
      this.descripcion});

  factory Producto.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Producto(
      id: doc.documentID,
      nombre: data['nombre'] ?? '',
      fotoUrl: data['fotoUrl'] ?? '',
      precioUnitario: data['precioUnitario'] ?? 0,
      stock: data['stock'] ?? 0,
      porcentajeGanancia: data['porcentajeGanancia'] ?? 0,
      descripcion: data['descripcion'] ?? '',
    );
  }

  factory Producto.fromMap(Map data) {
    data = data ?? {};
    return Producto(
        id: data['id'],
        nombre: data['nombre'] ?? '',
        fotoUrl: data['fotoUrl'] ?? '',
        precioUnitario: data['precioUnitario'] ?? 0,
        stock: data['stock'] ?? 0,
        porcentajeGanancia: data['porcentajeGanancia'] ?? 0,
        descripcion: data['descripcion'] ?? '');
  }

  num obtenerGanancia() {
    return (this.precioUnitario * this.porcentajeGanancia) / 100;
  }

  num obtenerPrecioVenta() {
    return this.precioUnitario + obtenerGanancia();
  }

  num obtenerPrecioCompra() {
    return this.precioUnitario;
  }
}
