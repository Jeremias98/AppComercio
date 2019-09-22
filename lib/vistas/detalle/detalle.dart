import 'package:flutter/material.dart';
import 'package:vivero/models/producto.dart';
import 'package:vivero/services/transaccionService.dart';
import 'package:vivero/widgets/producto_detalle.dart';

class DetalleView extends StatefulWidget {
  final Producto producto;

  const DetalleView({Key key, this.producto}) : super(key: key);

  @override
  _DetalleView createState() => _DetalleView();
}

class _DetalleView extends State<DetalleView> {
  final Widget listView = Column(
    children: <Widget>[Text("Descripcion del producto")],
  );

  obtenerFABQuitar(Producto producto) {
    return FloatingActionButton.extended(
        icon: Icon(Icons.remove_shopping_cart),
        backgroundColor: Colors.black,
        onPressed: () {
          quitarDelCarrito(producto);
        },
        label: new Text('QUITAR DEL CARRITO'));
  }

  obtenerFABAgregar(Producto producto) {
    return FloatingActionButton.extended(
        icon: Icon(Icons.add_shopping_cart),
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          setState(() {
            transaccionService.agregar(producto);
          });
        },
        label: new Text('AGREGAR AL CARRITO'));
  }

  obtenerFAB(Producto producto) {
    return transaccionService.pertenece(producto)
        ? obtenerFABQuitar(producto)
        : obtenerFABAgregar(producto);
  }

  Widget build(BuildContext context) {
    final bool mostrarFAB = MediaQuery.of(context).viewInsets.bottom == 0.0;
    return new Scaffold(
        floatingActionButton: mostrarFAB ? obtenerFAB(widget.producto) : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        backgroundColor: Colors.white,
        appBar: new AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.white,
          title: new Text("Detalle del producto",
              style: TextStyle(color: Colors.black)),
        ),
        body: ProductoDetalleWidget(producto: widget.producto));
  }

  quitarDelCarrito(Producto producto) {
    transaccionService.quitarDelCarrito(producto);
    Navigator.of(context).pop();
  }
}
