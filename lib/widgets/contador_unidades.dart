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
  bool editandoCantidad = false;

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
    TextEditingController controller = new TextEditingController();
    controller.text = transaccionService.obtenerUnidades(producto).toString();
    return Container(
      width: 50,
      height: 50,
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        onSubmitted: (text) {
          int cantidad = int.parse(text);
          if (cantidad > 0 && cantidad <= producto.stock) {
            setState(() {
              transaccionService.quitarDelCarrito(producto);
              transaccionService.agregarPorCantidad(producto, num.parse(text));
            });
          }
        },
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget build(BuildContext context) {
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
