import 'package:flutter/material.dart';
import 'package:vivero/models/producto.dart';
import 'package:vivero/models/valor_temporal.dart';
import 'package:vivero/services/productos_service.dart';
import 'package:intl/intl.dart';

class RenovarStockPreciosView extends StatefulWidget {
  @override
  _RenovarStockPreciosView createState() => _RenovarStockPreciosView();
}

class _RenovarStockPreciosView extends State<RenovarStockPreciosView> {
  static Map<String, num> nuevoStock = {};
  static Map<String, num> nuevoPrecio = {};

  @override
  initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    Map<String, List<TextEditingController>> controladores = {};

    Widget formularioPreciosYStock(Producto producto) {
      TextEditingController precioCostoController = TextEditingController();
      TextEditingController porcentajeController = TextEditingController();
      TextEditingController stockController = TextEditingController();

      producto.stockHistorico.add(new ValorTemporal());
      producto.stockHistorico[producto.stockHistorico.length - 1].fecha =
          DateTime.now();
      producto.stockHistorico[producto.stockHistorico.length - 1].valor = null;

      // precioCostoController.text = producto.precioUnitario.toString();
      porcentajeController.text = producto.porcentajeGanancia.toString();

      if (nuevoStock[producto.id] != null)
        stockController.text = nuevoStock[producto.id].toString();

      if (nuevoPrecio[producto.id] != null)
        precioCostoController.text = nuevoPrecio[producto.id].toString();
      else
        precioCostoController.text = producto.precioUnitario.toString();

      controladores[producto.id] = new List<TextEditingController>();
      controladores[producto.id].add(precioCostoController);
      controladores[producto.id].add(porcentajeController);
      controladores[producto.id].add(stockController);

      return Container(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 20),
        child: Column(
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.number,
              controller: controladores[producto.id][0],
              onChanged: (text) {
                producto.precioUnitario = num.parse(text);
                nuevoPrecio[producto.id] = num.parse(text);
              },
              decoration: InputDecoration(
                  labelText: 'Precio al Costo',
                  prefixIcon: Icon(Icons.attach_money)),
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: controladores[producto.id][1],
              onChanged: (text) {
                producto.porcentajeGanancia = num.parse(text);
              },
              decoration: InputDecoration(
                  labelText: 'Porcentaje de Ganancia',
                  prefixIcon: Icon(Icons.bubble_chart)),
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: controladores[producto.id][2],
              onChanged: (text) {
                nuevoStock[producto.id] = num.parse(text);
              },
              decoration: InputDecoration(
                  labelText: 'Stock Entrante', prefixIcon: Icon(Icons.backup)),
            ),
          ],
        ),
      );
    }

    Widget detallesProducto(Producto producto) {
      return ExpansionTile(
        title: Text(
          "MOSTRAR DETALLES",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        children: <Widget>[
          ListTile(
            title: Text("Ultimo Precio"),
            subtitle: Text(producto.obtenerUltimoPrecio() != null
                ? DateFormat('dd MMM yyyy')
                    .format(producto.obtenerUltimoPrecio().fecha)
                : "Sin datos"),
            trailing: Text(producto.obtenerUltimoPrecio() != null
                ? "\$" + producto.obtenerUltimoPrecio().valor.toString()
                : "Sin datos"),
          ),
          ListTile(
            title: Text("Ultimo Stock"),
            subtitle: Text(DateFormat('dd MMM yyyy')
                .format(producto.obtenerUltimoStock().fecha)),
            trailing: Text(producto.obtenerUltimoStock().valor.toString()),
          ),
        ],
      );
    }

    Widget informacionProducto(Producto producto) {
      return SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 210.0,
                alignment: Alignment(-1, 1),
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                        fit: BoxFit.cover,
                        image: new NetworkImage(producto.fotoUrl))),
              )
            ],
          ),
          Column(
            children: <Widget>[
              ListTile(
                  title: Text(
                    producto.nombre ?? '',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  subtitle: producto.obtenerTextStock(),
                  trailing: Text(
                    '\$' +
                        (producto.precioUnitario != null
                            ? producto.obtenerPrecioVenta().toString()
                            : ''),
                    style: new TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey,
                    ),
                  )),
              detallesProducto(producto),
              formularioPreciosYStock(producto)
            ],
          )
        ],
      ));
    }

    Widget pantallaFinal(List<Producto> productos) {
      return ListView.separated(
          scrollDirection: Axis.vertical,
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemCount: productos.length,
          itemBuilder: (context, index) {
            final Producto producto = productos[index];

            return ListTile(
                onTap: () {},
                onLongPress: () {},
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(producto.fotoUrl),
                ),
                title: Text(producto.nombre.toString()),
                subtitle: nuevoStock[producto.id] != null
                    ? Text(
                        "+" + nuevoStock[producto.id].toString() + " unidades")
                    : Text("Sin cambios"), //producto.obtenerTextStock(),
                trailing:
                    Text('\$' + producto.obtenerPrecioVenta().toString()));
          });
    }

    return new Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.white,
          title: new Text("Renovar Stock y Precios",
              style: TextStyle(color: Colors.black)),
        ),
        body: PageView.builder(
          itemCount: productosService.carrito.obtenerProductos().length + 1,
          itemBuilder: (conFtext, index) {
            if (index == productosService.carrito.obtenerProductos().length) {
              return pantallaFinal(productosService.carrito.obtenerProductos());
            }

            Producto producto =
                productosService.carrito.obtenerProductos()[index];

            return informacionProducto(producto);
          },
        ));
  }
}
