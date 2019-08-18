import 'package:flutter/widgets.dart';

class ItemMenu {
  String codigo;
  String titulo;
  IconData icono;
  bool habilitado;

  ItemMenu(String codigo, String titulo, [IconData icono, bool habilitado]) {
    this.codigo = codigo;
    this.titulo = titulo;
    this.icono = icono != null ? icono : null;
    this.habilitado = habilitado != null ? habilitado : true;
  }
}
