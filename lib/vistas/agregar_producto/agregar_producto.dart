import 'package:flutter/material.dart';
import 'package:vivero/models/producto.dart';
import 'package:vivero/services/transaccionService.dart';

class AgregarProductoScreen extends StatefulWidget {
  final Producto producto;

  const AgregarProductoScreen({Key key, this.producto}) : super(key: key);

  @override
  _AgregarProductoScreen createState() => _AgregarProductoScreen();
}

class _AgregarProductoScreen extends State<AgregarProductoScreen> {
  final _formKey = GlobalKey<FormState>();

  num unidades = 0;

  obtenerFABAgregar() {
    return FloatingActionButton.extended(
        icon: Icon(Icons.add_shopping_cart),
        backgroundColor: Colors.deepPurpleAccent,
        onPressed: () {
          setState(() {
            transaccionService.agregar(widget.producto);
          });
        },
        label: new Text('AGREGAR ' +
            '(' +
            transaccionService.obtenerUnidades(widget.producto).toString() +
            ')'));
  }

  Widget build(BuildContext context) {
    final Widget formularioScaffold = Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.white,
          title: new Text("Detalle", style: TextStyle(color: Colors.black)),
        ),
        floatingActionButton: obtenerFABAgregar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  constraints: new BoxConstraints.expand(
                    height: 200.0,
                  ),
                  padding:
                      new EdgeInsets.only(left: 16.0, bottom: 8.0, right: 16.0),
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      image: new NetworkImage(widget.producto.fotoUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                          title: Text(
                            widget.producto.nombre,
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                              widget.producto.stock.toString() + ' en stock'),
                          trailing: Text(
                            '\$' +
                                widget.producto.obtenerPrecioVenta().toString(),
                            style: new TextStyle(
                              fontSize: 22.0,
                              color: Colors.grey,
                            ),
                          )),
                    ],
                  ),
                )
              ],
            ),
            Positioned(
              child: RawMaterialButton(
                onPressed: () {},
                child: new Icon(
                  Icons.edit,
                  color: Colors.blue,
                  size: 20.0,
                ),
                shape: new CircleBorder(),
                elevation: 2.0,
                fillColor: Colors.white,
                padding: const EdgeInsets.all(15.0),
              ),
              top: 175,
              left: (MediaQuery.of(context).size.width / 2) - 45,
            ),
          ],
        ));

    return formularioScaffold;
  }
}
