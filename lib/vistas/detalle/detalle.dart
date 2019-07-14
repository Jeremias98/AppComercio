import 'package:flutter/material.dart';
import 'package:vivero/models/producto.dart';
import 'package:vivero/services/transaccionService.dart';

class DetalleView extends StatefulWidget {
  final Producto producto;

  const DetalleView({Key key, this.producto}) : super(key: key);

  @override
  _DetalleView createState() => _DetalleView();
}

class _DetalleView extends State<DetalleView> {
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        title: new Text(widget.producto.nombre,
            style: TextStyle(color: Colors.black)),
      ),
      body: ListView(
        children: <Widget>[
          Image.network(widget.producto.fotoUrl),
          ListTile(
              title: Text(widget.producto.nombre.toString()),
              subtitle: Text(widget.producto.stock.toString() + ' en stock'),
              trailing: Text(
                '\$' + widget.producto.obtenerPrecioVenta().toString(),
                style: new TextStyle(
                  fontSize: 20.0,
                  color: Colors.grey,
                ),
              )),
          Padding(
              child: MaterialButton(
                child: Text('QUITAR DEL CARRITO'),
                textColor: Colors.black,
                color: Colors.white,
                elevation: 0,
                shape: Border.all(color: Colors.grey, style: BorderStyle.solid),
                onPressed: () => quitarDelCarrito(widget.producto),
              ),
              padding: EdgeInsets.all(14.0))
        ],
      ),
    );
  }

  quitarDelCarrito(Producto producto) {
    transaccionService.quitar(producto);
    Navigator.of(context).pop();
  }
}
