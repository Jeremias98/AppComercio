import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vivero/models/producto.dart';
import 'package:vivero/services/menu_contextual_service.dart';
import 'package:vivero/services/productos_service.dart';
import 'package:vivero/vistas/agregar_producto/agregar_producto.dart';

class ListaProductosView extends StatefulWidget {
  @override
  _ListaProductosView createState() => _ListaProductosView();
}

class _ListaProductosView extends State<ListaProductosView> {
  Widget build(BuildContext context) {
    Widget textoCarrito() {
      return productosService.carrito.estaVacio()
          ? Text("NUEVO PRODUCTO", style: TextStyle(color: Colors.white))
          : Text("CANCELAR", style: TextStyle(color: Colors.white));
    }

    Widget botonPrincipal = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(14.0),
      child: GestureDetector(
        onTap: () {
          botonPrincipalClickeado(context, new Producto());
        },
        child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent,
              borderRadius: BorderRadius.circular(2.0),
            ),
            child: textoCarrito()),
      ),
    );

    seleccionarProducto(Producto producto) {
      setState(() {
        if (!productosService.carrito.pertenece(producto)) {
          productosService.carrito.agregar(producto);
        } else {
          productosService.carrito.quitarDelCarrito(producto);
        }

        if (productosService.carrito.estaVacio())
          menuContextualService.deshabilitar("RENOVAR_STOCK_PRECIOS");
        else
          menuContextualService.habilitar("RENOVAR_STOCK_PRECIOS");
      });
    }

    productoClickeado(Producto producto, context) {
      if (productosService.carrito.estaVacio()) {
        botonPrincipalClickeado(context, producto);
      } else {
        seleccionarProducto(producto);
      }
    }

    Widget obtenerSubtituloStock(Producto producto) {
      if (producto.stock == 0) {
        return productosService.carrito.pertenece(producto)
            ? Text('Sin stock', style: TextStyle(color: Colors.blue))
            : Text('Sin stock', style: TextStyle(color: Colors.red));
      }
      return Text(producto.stock.toString() + ' en stock');
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
                    onTap: () => productoClickeado(producto, context),
                    onLongPress: () => seleccionarProducto(producto),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(producto.fotoUrl),
                    ),
                    title: Text(producto.nombre.toString()),
                    subtitle: obtenerSubtituloStock(producto),
                    trailing:
                        Text('\$' + producto.obtenerPrecioVenta().toString()),
                    selected: productosService.carrito.pertenece(producto),
                  );
                });
        }
      },
    );

    final Widget vista = Column(
      children: <Widget>[
        Expanded(
          child: streamBuilderList,
        ),
        botonPrincipal
      ],
    );

    return vista;
  }

  botonPrincipalClickeado(context, producto) {
    if (productosService.carrito.estaVacio()) {
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (BuildContext context) =>
                  new AgregarProductoScreen(producto: producto)));
    } else {
      setState(() {
        productosService.carrito.limpiar();
      });
    }
  }
}
