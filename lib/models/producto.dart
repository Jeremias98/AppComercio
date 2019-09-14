import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vivero/models/valor_temporal.dart';

class Producto {
  String id;
  String nombre;
  String fotoUrl;
  num precioUnitario;
  num stock;
  num porcentajeGanancia;
  String descripcion;
  List<ValorTemporal> stockHistorico;

  Producto(
      {this.id,
      this.nombre,
      this.fotoUrl,
      this.precioUnitario,
      this.stock,
      this.porcentajeGanancia,
      this.descripcion,
      this.stockHistorico});

  factory Producto.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    Producto producto = new Producto(
        id: doc.documentID,
        nombre: data['nombre'] ?? '',
        fotoUrl: data['fotoUrl'] ?? '',
        precioUnitario: data['precioUnitario'] ?? 0,
        stock: data['stock'] ?? 0,
        porcentajeGanancia: data['porcentajeGanancia'] ?? 0,
        descripcion: data['descripcion'] ?? '');

    producto.stockHistorico = new List<ValorTemporal>();

    List<dynamic> stockHistoricoFirebase = data['stockHistorico'] ?? null;

    stockHistoricoFirebase.forEach((sh) {
      ValorTemporal valorTemporal =
          new ValorTemporal(fecha: sh['fecha'], valor: sh['valor']);
      producto.stockHistorico.add(valorTemporal);
    });

    return producto;
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

  Widget obtenerTextStock() {
    if (stock == 0) {
      return Text('Sin stock', style: TextStyle(color: Colors.red));
    }
    return Text(stock.toString() + ' en stock');
  }
}
