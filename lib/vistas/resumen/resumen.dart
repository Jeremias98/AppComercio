import 'package:flutter/material.dart';
import 'package:vivero/models/usuario.dart';
import 'package:vivero/services/auth.dart';
import 'package:vivero/services/transaccionService.dart';

class ResumenView extends StatefulWidget {
  final Usuario usuario;

  const ResumenView({Key key, this.usuario}) : super(key: key);

  @override
  _ResumenView createState() => _ResumenView();
}

class _ResumenView extends State<ResumenView> {
  @override
  initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        title: new Text("Resumen", style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              "TOTAL",
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey,
              ),
            ),
            trailing: Text(
              "\$" + transaccionService.obtenerPrecioTotal().toString(),
              style: TextStyle(
                fontSize: 22.0,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(14.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  transaccionService
                      .finalizar(authService.obtenerUsuario())
                      .then((data) {
                    transaccionService.limpiar();
                    Navigator.of(context).pop();
                  });
                });
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.circular(2.0),
                    border: Border.all(
                        color: Colors.deepPurpleAccent,
                        style: BorderStyle.solid)),
                child: Text(
                  'FINALIZAR',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
