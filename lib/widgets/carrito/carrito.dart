import 'package:flutter/material.dart';
import 'package:qr_reader/qr_reader.dart';
import 'package:vivero/clases/contador.dart';
import 'package:vivero/models/producto.dart';
import 'package:vivero/models/usuario.dart';
import 'package:vivero/services/productosService.dart';
import 'package:vivero/services/transaccionService.dart';
import 'package:vivero/vistas/detalle/detalle.dart';
import 'package:vivero/vistas/resumen/resumen.dart';

class CarritoWidget extends StatefulWidget {
  final Usuario usuario;

  const CarritoWidget({Key key, this.usuario}) : super(key: key);

  @override
  _CarritoWidget createState() => _CarritoWidget();
}

class _CarritoWidget extends State<CarritoWidget> {
  Future<String> codigoQR;
  num cantidad = 1;
  var txtCantidad = TextEditingController();

  Contador contador = new Contador();

  Producto _productoEscaneado = new Producto();

  Widget build(BuildContext context) {
    final Widget listView = ListView.separated(
        scrollDirection: Axis.vertical,
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemCount: transaccionService.obtenerProductos().length,
        itemBuilder: (context, index) {
          final item = transaccionService.obtenerProductos()[index];

          return ListTile(
            onTap: () => navegarDetalle(context, item),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(item.fotoUrl),
            ),
            title: Text(item.nombre.toString()),
            subtitle: Text(transaccionService.obtenerUnidades(item).toString() +
                ' unidades'),
            trailing: Text('\$' + item.obtenerPrecioVenta().toString()),
          );
        });

    final Widget contenedorWidget = Column(
      children: <Widget>[
        ListTile(
          title: Text(
            transaccionService.obtenerTotalUnidades().toString() + " UNIDADES",
            style: TextStyle(
                fontSize: 14.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          trailing: MaterialButton(
            child: Text(
              "COBRAR",
              style: TextStyle(fontSize: 14.0, color: Colors.deepPurpleAccent),
            ),
            shape: Border.all(
                color: Colors.deepPurpleAccent, style: BorderStyle.solid),
            onPressed: () {navegarResumen(context);},
          ),
        ),
        Expanded(
          child: listView,
        ),
        Divider(),
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
              // Escanear
              escanear();
            },
            onLongPress: () {
              cantidad = 1;
              txtCantidad.text = cantidad.toString();
              abrirDialog();
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                borderRadius: BorderRadius.circular(2.0),
              ),
              child: Text(
                'ESCANEAR',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );

    return contenedorWidget;
  }

  cargarProducto(state) {
    _productoEscaneado = state;
    transaccionService.agregarPorCantidad(
        _productoEscaneado, contador.obtenerContador());
    contador.reestablecerContador();
  }

  agregarAlCarrito(String qr) {
    productosService
        .obtenerPorQR(qr)
        .listen((state) => setState(() => cargarProducto(state)));
  }

  abrirDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Unidades"),
          content: contadorWidget(),
          actions: <Widget>[
            new FlatButton(
              child: new Text("CANCELAR"),
              onPressed: () {
                contador.reestablecerContador();
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("ESCANEAR"),
              onPressed: () {
                escanear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  contadorWidget() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  contador.decrementarContador();
                  txtCantidad.text = contador.obtenerContador().toString();
                },
              ),
            ],
          ),
          Column(children: <Widget>[
            Container(
              width: 60,
              child: TextField(
                controller: txtCantidad,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
              ),
            ),
          ]),
          Column(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  contador.incrementarContador();
                  txtCantidad.text = contador.obtenerContador().toString();
                },
              ),
            ],
          ),
        ],
      ),
      height: 50,
    );
  }

  escanear() {
    setState(() {
      codigoQR = new QRCodeReader().scan().then((qr) => agregarAlCarrito(qr));
    });
  }

  navegarDetalle(context, producto) {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) =>
                new DetalleView(producto: producto)));
  }

  navegarResumen(context) {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new ResumenView()));
  }
}
