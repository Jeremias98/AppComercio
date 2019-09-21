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
  List<ValorTemporal> precioHistorico;

  Producto(
      {this.id,
      this.nombre,
      this.fotoUrl,
      this.precioUnitario,
      this.stock,
      this.porcentajeGanancia,
      this.descripcion,
      this.stockHistorico,
      this.precioHistorico});

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
    producto.precioHistorico = new List<ValorTemporal>();

    List<dynamic> stockHistoricoFirebase = data['stockHistorico'] ?? [];
    List<dynamic> precioHistoricoFirebase = data['precioHistorico'] ?? [];

    stockHistoricoFirebase.forEach((sh) {
      ValorTemporal valorTemporal =
          new ValorTemporal(fecha: sh['fecha'], valor: sh['valor']);
      producto.stockHistorico.add(valorTemporal);
    });

    precioHistoricoFirebase.forEach((vh) {
      ValorTemporal valorTemporal =
          new ValorTemporal(fecha: vh['fecha'], valor: vh['valor']);
      producto.precioHistorico.add(valorTemporal);
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

  ValorTemporal obtenerUltimoStock() {
    if (this.stockHistorico == null || this.stockHistorico.length == 0) {
      return null;
    }

    return this.stockHistorico[this.stockHistorico.length - 1];
  }

  ValorTemporal obtenerUltimoPrecio() {
    if (this.precioHistorico == null || this.precioHistorico.length == 0) {
      return null;
    }

    return this.precioHistorico[this.precioHistorico.length - 1];
  }

  Widget obtenerTextStock() {
    return Text(obtenerStringStock(), style: TextStyle(color: stock == 0 ? Colors.red : Colors.grey));
  }

  obtenerStringStock() {
    return (stock == 0) ? "Sin stock" : stock.toString() + " en stock";
  }
}
