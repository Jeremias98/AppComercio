import 'package:flutter/material.dart';
import 'package:vivero/models/producto.dart';
import 'package:vivero/models/valor_temporal.dart';
import 'package:vivero/services/productos_service.dart';

class RenovarStockPreciosView extends StatefulWidget {
  @override
  _RenovarStockPreciosView createState() => _RenovarStockPreciosView();
}

class _RenovarStockPreciosView extends State<RenovarStockPreciosView> {
  Widget build(BuildContext context) {
    Map<String, List<TextEditingController>> controladores = {};
    Map<String, num> nuevoStockAuxiliar = {};

    Widget formularioPreciosYStock(Producto producto) {
      TextEditingController precioCostoController = TextEditingController();
      TextEditingController porcentajeController = TextEditingController();
      TextEditingController stockController = TextEditingController();

      // producto.stockHistorico.add(new ValorTemporal());
      // producto.stockHistorico[producto.stockHistorico.length - 1].fecha = DateTime.now();
      // producto.stockHistorico[producto.stockHistorico.length - 1].valor = null;

      precioCostoController.text = producto.precioUnitario.toString();
      porcentajeController.text = producto.porcentajeGanancia.toString();
      // stockController.text = producto.stockHistorico[producto.stockHistorico.length - 1].valor;
      // stockController.text = nuevoStockAuxiliar[producto.id].toString();

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
                nuevoStockAuxiliar[producto.id] = num.parse(text);
                print(nuevoStockAuxiliar[producto.id]);
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
            subtitle: Text("12 de Agosto de 2019"),
            trailing: Text("\$" + producto.obtenerPrecioCompra().toString()),
          ),
          ListTile(
            title: Text("Ultimo stock"),
            subtitle: Text("16 de Agosto de 2019"),
            trailing: Text("14 u"),
          ),
        ],
      );
    }

    Widget detalleProducto(Producto producto) {
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
          itemCount: productosService.carrito.obtenerProductos().length,
          itemBuilder: (conFtext, index) {
            Producto producto =
                productosService.carrito.obtenerProductos()[index];
                
            return detalleProducto(producto);
          },
        ));
  }
}
