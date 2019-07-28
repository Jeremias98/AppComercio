import 'package:flutter/material.dart';
import 'package:vivero/models/producto.dart';

class AgregarProductoScreen extends StatefulWidget {
  final Producto producto;

  const AgregarProductoScreen({Key key, this.producto}) : super(key: key);

  @override
  _AgregarProductoScreen createState() => _AgregarProductoScreen();
}

class _AgregarProductoScreen extends State<AgregarProductoScreen> {
  final _formKey = GlobalKey<FormState>();

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
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(14.0),
                        child: GestureDetector(
                          onTap: () {},
                          onLongPress: () {},
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.deepPurpleAccent,
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                            child: Text(
                              'AGREGAR AL CARRITO',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
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
