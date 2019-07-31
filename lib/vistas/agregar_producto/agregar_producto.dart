import 'package:flutter/material.dart';
import 'package:vivero/models/producto.dart';
import 'package:vivero/services/productosService.dart';
import 'package:vivero/services/transaccionService.dart';

class CustomPopupMenu {
  CustomPopupMenu({this.title, this.icon});

  String title;
  IconData icon;
}

class AgregarProductoScreen extends StatefulWidget {
  final Producto producto;
  final bool nuevoProducto;

  const AgregarProductoScreen({Key key, this.producto, this.nuevoProducto})
      : super(key: key);

  @override
  _AgregarProductoScreen createState() => _AgregarProductoScreen();
}

List<CustomPopupMenu> choices = <CustomPopupMenu>[
  CustomPopupMenu(title: 'Editar', icon: Icons.edit),
  CustomPopupMenu(title: 'Imprimir QR', icon: Icons.share),
  CustomPopupMenu(title: 'Borrar', icon: Icons.delete),
];

class _AgregarProductoScreen extends State<AgregarProductoScreen> {
  final _formKey = GlobalKey<FormState>();

  bool modoEdicion = false;

  final nombreController = TextEditingController();
  final precioAlCostoController = TextEditingController();
  final porcDeGananciaController = TextEditingController();
  final stockController = TextEditingController();
  final urlFotoController = TextEditingController();
  final descripcionController = TextEditingController();

  CustomPopupMenu _selectedChoices = choices[0];
  void _select(CustomPopupMenu choice) {
    setState(() {
      if (choice.title == "Editar") {
        toggleModoEdicion();
      }
      _selectedChoices = choice;
    });
  }

  Widget build(BuildContext context) {
    final Widget formularioScaffold = Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: obtenerFABPrincipal(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                Container(
                  constraints: new BoxConstraints.expand(
                    height: 250.0,
                  ),
                  padding:
                      new EdgeInsets.only(left: 16.0, bottom: 8.0, right: 16.0),
                  decoration: new BoxDecoration(
                    color:
                        widget.producto.fotoUrl == null ? Colors.purple : null,
                    image: widget.producto.fotoUrl != null
                        ? DecorationImage(
                            image: new NetworkImage(widget.producto.fotoUrl ??
                                'http://isabelpaz.com/wp-content/themes/nucleare-pro/images/no-image-box.png'),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                          title: Text(
                            widget.producto.nombre ?? '',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                              widget.producto.stock.toString() + ' en stock'),
                          trailing: Text(
                            '\$' +
                                (widget.producto.precioUnitario != null
                                    ? widget.producto
                                        .obtenerPrecioVenta()
                                        .toString()
                                    : ''),
                            style: new TextStyle(
                              fontSize: 20.0,
                              color: Colors.grey,
                            ),
                          )),
                      obtenerFormulario(),
                    ],
                  ),
                )
              ],
            ),
            Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                actions: <Widget>[
                  PopupMenuButton<CustomPopupMenu>(
                    elevation: 3.2,
                    onCanceled: () {},
                    onSelected: _select,
                    itemBuilder: (BuildContext context) {
                      return choices.map((CustomPopupMenu choice) {
                        return PopupMenuItem<CustomPopupMenu>(
                          value: choice,
                          child: Text(choice.title),
                        );
                      }).toList();
                    },
                  )
                ],
              ),
            ),
          ],
        ));

    return formularioScaffold;
  }

  toggleModoEdicion() {
    modoEdicion = !modoEdicion;
  }

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

  obtenerFABGuardar() {
    return FloatingActionButton.extended(
        icon: Icon(Icons.save_alt),
        backgroundColor: Colors.deepPurpleAccent,
        onPressed: () {
          setState(() {
            Producto producto = new Producto(
                nombre: nombreController.value.text,
                precioUnitario: num.parse(precioAlCostoController.value.text),
                porcentajeGanancia:
                    num.parse(porcDeGananciaController.value.text),
                stock: num.parse(stockController.value.text),
                fotoUrl: urlFotoController.value.text,
                descripcion: descripcionController.value.text);

            productosService.guardarProducto(producto);
            print(nombreController.value.text);
          });
        },
        label: new Text('GUARDAR'));
  }

  obtenerFABPrincipal(context) {
    if (modoEdicion)
      return obtenerFABGuardar();
    else if (!tecladoActivo(context)) return obtenerFABAgregar();
    return null;
  }

  bool tecladoActivo(context) {
    return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
  }

  obtenerFormulario() {
    return Container(
        padding: EdgeInsets.only(left: 16.0, bottom: 8.0, right: 16.0),
        child: Builder(
            builder: (context) => Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: nombreController,
                              enabled: modoEdicion,
                              decoration: InputDecoration(labelText: "Nombre"),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Debe proveer un nombre';
                                }
                                return '';
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: precioAlCostoController,
                              enabled: modoEdicion,
                              decoration:
                                  InputDecoration(labelText: "Precio al costo"),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Debe proveer un precio al costo';
                                }
                                return '';
                              },
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: TextFormField(
                              controller: porcDeGananciaController,
                              enabled: modoEdicion,
                              decoration: InputDecoration(
                                  labelText: "Porc. de ganancia"),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Debe proveer un porcentaje de ganancia';
                                }
                                return '';
                              },
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: stockController,
                              enabled: modoEdicion,
                              decoration: InputDecoration(labelText: "Stock"),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Debe proveer un stock';
                                }
                                return '';
                              },
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: TextFormField(
                              controller: urlFotoController,
                              enabled: modoEdicion,
                              decoration:
                                  InputDecoration(labelText: "URL foto"),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: descripcionController,
                              enabled: modoEdicion,
                              decoration:
                                  InputDecoration(labelText: "Descripción"),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Debe proveer una descripción';
                                }
                                return '';
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )));
  }
}
