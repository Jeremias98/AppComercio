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
  final Widget listView = Column(
    children: <Widget>[Text("Descripcion del producto")],
  );

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
      body: Column(
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
          Expanded(
            child: listView,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(14.0),
            child: GestureDetector(
              onTap: () {
                quitarDelCarrito(widget.producto);
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2.0),
                    border: Border.all(
                        color: Colors.grey, style: BorderStyle.solid)),
                child: Text(
                  'QUITAR DEL CARRITO',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  quitarDelCarrito(Producto producto) {
    transaccionService.quitar(producto);
    Navigator.of(context).pop();
  }
}
