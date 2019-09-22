import 'package:flutter/material.dart';

class AgregarProductoScreen extends StatefulWidget {
  const AgregarProductoScreen() : super();

  @override
  _AgregarProductoScreen createState() => _AgregarProductoScreen();
}

class _AgregarProductoScreen extends State<AgregarProductoScreen> {
  TextEditingController nombre = new TextEditingController();
  TextEditingController descripcion = new TextEditingController();
  TextEditingController precioCosto = new TextEditingController();
  Widget formulario() {
    return SingleChildScrollView(
        child: Container(
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: nombre,
            onChanged: (text) {
              print(text);
            },
            decoration: InputDecoration(
                labelText: 'Nombre', border: OutlineInputBorder()),
          ),
          Container(height: 20),
          TextField(
            controller: descripcion,
            onChanged: (text) {
              print(text);
            },
            decoration: InputDecoration(
                labelText: 'Descripción', border: OutlineInputBorder()),
          ),
          Container(height: 20),
          TextField(
            controller: precioCosto,
            keyboardType: TextInputType.number,
            onChanged: (text) {
              print(text);
            },
            decoration: InputDecoration(
                labelText: 'Precio al costo', border: OutlineInputBorder(), prefixIcon: Icon(Icons.attach_money)),
          ),
        ],
      ),
    ));
  }

  obtenerFABGuardar() {
    return FloatingActionButton.extended(
        icon: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          setState(() {
            // TODO: Guardar producto
          });
        },
        label: new Text('GUARDAR'));
  }

  Widget build(BuildContext context) {
    return new Scaffold(
        floatingActionButton: obtenerFABGuardar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        backgroundColor: Colors.white,
        appBar: new AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.white,
          title:
              new Text("Nuevo producto", style: TextStyle(color: Colors.black)),
        ),
        body: formulario());
  }
}
