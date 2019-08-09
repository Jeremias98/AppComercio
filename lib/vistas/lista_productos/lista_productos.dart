import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vivero/models/producto.dart';
import 'package:vivero/vistas/agregar_producto/agregar_producto.dart';

class ListaProductosView extends StatefulWidget {
  @override
  _ListaProductosView createState() => _ListaProductosView();
}

class _ListaProductosView extends State<ListaProductosView> {
  bool modoSeleccion = false;
    List<Producto> productosSeleccionado = new List<Producto>();
  Widget build(BuildContext context) {

    Widget obtenerSubtituloStock(num stock) {
      if (stock == 0) {
        return Text('Sin stock', style: TextStyle(color: Colors.red));
      }
      return Text(stock.toString() + ' en stock');
    }

    final Widget streamBuilderList = StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("productos").snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<QuerySnapshot> querySnapshot) {
        switch (querySnapshot.connectionState) {
          case ConnectionState.waiting:
            return new Center(child: new CircularProgressIndicator());
          default:
            return ListView.separated(
                scrollDirection: Axis.vertical,
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: querySnapshot.data.documents.length,
                itemBuilder: (context, index) {
                  final Producto producto = Producto.fromFirestore(
                      querySnapshot.data.documents[index]);

                  return ListTile(
                    onTap: () => navegarDetalle(context, producto),
                    onLongPress: () => setState(() {
                      modoSeleccion = true;
                      productosSeleccionado.add(producto);
                    }),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(producto.fotoUrl),
                    ),
                    title: Text(producto.nombre.toString()),
                    subtitle: obtenerSubtituloStock(producto.stock),
                    trailing:
                        Text('\$' + producto.obtenerPrecioVenta().toString()),
                    selected: productosSeleccionado.contains(producto),
                  );
                });
        }
      },
    );

    final Widget botonAgregar = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(14.0),
      child: GestureDetector(
        onTap: () {
          navegarDetalle(context, new Producto());
        },
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.deepPurpleAccent,
            borderRadius: BorderRadius.circular(2.0),
          ),
          child: Text(
            'NUEVO PRODUCTO',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );

    final Widget vista = Column(
      children: <Widget>[
        Expanded(
          child: streamBuilderList,
        ),
        botonAgregar
      ],
    );

    return vista;
  }

  @override
  initState() {
    super.initState();
  }

  navegarDetalle(context, producto) {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) =>
                new AgregarProductoScreen(producto: producto)));
  }
}
