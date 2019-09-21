import 'package:flutter/material.dart';
import 'package:vivero/models/producto.dart';
import 'package:vivero/services/transaccionService.dart';

class ContadorUnidadesWidget extends StatefulWidget {
  final Producto producto;

  const ContadorUnidadesWidget({Key key, this.producto}) : super(key: key);

  @override
  _ContadorUnidadesWidget createState() => _ContadorUnidadesWidget();
}

class _ContadorUnidadesWidget extends State<ContadorUnidadesWidget> {
  Widget botonQuitar() {
    return Container(
      width: 50,
      height: 50,
      child: Ink(
        decoration: BoxDecoration(
          border: new Border.all(color: Colors.red, width: 2.0),
          borderRadius: new BorderRadius.circular(10.0),
        ),
        child: IconButton(
          icon: Icon(Icons.remove),
          color: Colors.red,
          onPressed: () {
            setState(() {
              transaccionService.quitar(widget.producto);
            });
          },
        ),
      ),
    );
  }

  Widget botonAgregar() {
    return Container(
      width: 50,
      height: 50,
      child: Ink(
        decoration: BoxDecoration(
          border: new Border.all(color: Colors.green, width: 2.0),
          borderRadius: new BorderRadius.circular(10.0),
        ),
        child: IconButton(
          icon: Icon(Icons.add),
          color: Colors.green,
          onPressed: () {
            setState(() {
              transaccionService.agregar(widget.producto);
            });
          },
        ),
      ),
    );
  }

  Widget numeroDeUnidades(Producto producto) {
    return Container(
        width: 50,
        height: 50,
        alignment: Alignment.center,
        child: Text(transaccionService.obtenerUnidades(producto).toString(),
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)));
  }

  Widget build(BuildContext context) {
    // return Text("Contador: " +
    //     transaccionService.obtenerUnidades(widget.producto).toString());
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        botonQuitar(),
        numeroDeUnidades(widget.producto),
        botonAgregar()
      ],
    );
  }
}
