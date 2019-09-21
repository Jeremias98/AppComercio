import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vivero/models/producto.dart';
import 'package:vivero/widgets/contador_unidades.dart';

class ProductoDetalleWidget extends StatefulWidget {
  final Producto producto;

  const ProductoDetalleWidget({Key key, this.producto}) : super(key: key);

  @override
  _ProductoDetalleWidget createState() => _ProductoDetalleWidget();
}

class _ProductoDetalleWidget extends State<ProductoDetalleWidget> {
  Widget portada(Producto producto, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 210.0,
      alignment: Alignment(-1, 1),
      decoration: new BoxDecoration(
          image: new DecorationImage(
              fit: BoxFit.cover, image: new NetworkImage(producto.fotoUrl))),
    );
  }

  Widget filaDatosPrincipales(Producto producto) {
    return ListTile(
        title: Text(
          producto.nombre ?? '',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        subtitle: producto.obtenerTextStock(),
        trailing: Text(
          '\$' + producto.obtenerPrecioVenta().toString(),
          style: new TextStyle(
            fontSize: 20.0,
            color: Colors.grey,
          ),
        ));
  }

  Widget detallesProducto(Producto producto) {
    return ExpansionTile(
      title: Text(
        "MOSTRAR DETALLES",
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
      ),
      children: <Widget>[
        ListTile(
          title: Text("Último Precio"),
          subtitle: Text(producto.obtenerUltimoPrecio() != null
              ? DateFormat('dd MMM yyyy')
                  .format(producto.obtenerUltimoPrecio().fecha)
              : "Sin datos"),
          trailing: Text(producto.obtenerUltimoPrecio() != null
              ? "\$" + producto.obtenerUltimoPrecio().valor.toString()
              : "Sin datos"),
        ),
        ListTile(
          title: Text("Último Stock"),
          subtitle: Text(DateFormat('dd MMM yyyy')
              .format(producto.obtenerUltimoStock().fecha)),
          trailing: Text(producto.obtenerUltimoStock().valor.toString() + " u"),
        ),
      ],
    );
  }

  Widget descripcion(Producto producto) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(15),
      child: Text(
        producto.descripcion != ""
            ? producto.descripcion
            : "No hay descripción para este producto.",
        style: TextStyle(
            color: Colors.black54, fontWeight: FontWeight.w400, fontSize: 15),
      ),
    );
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Stack(
          children: <Widget>[portada(widget.producto, context)],
        ),
        Column(
          children: <Widget>[
            filaDatosPrincipales(widget.producto),
            descripcion(widget.producto),
            Divider(),
            ContadorUnidadesWidget(producto: widget.producto),
            Divider(),
            detallesProducto(widget.producto),
            // formularioPreciosYStock(producto)
          ],
        )
      ],
    ));
  }
}
