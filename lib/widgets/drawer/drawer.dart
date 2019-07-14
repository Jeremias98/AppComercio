import 'package:flutter/material.dart';
import 'package:vivero/models/usuario.dart';
import 'package:vivero/services/auth.dart';
import 'package:vivero/vistas/agregar_producto/agregar_producto.dart';

class DrawerWidget extends StatefulWidget {
  final Usuario usuario;

  const DrawerWidget({Key key, this.usuario}) : super(key: key);

  @override
  _DrawerWidget createState() => _DrawerWidget();
}

class _DrawerWidget extends State<DrawerWidget> {

  Widget build(BuildContext context) {
    final Widget drawerView = Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.white),
            currentAccountPicture: new CircleAvatar(
              backgroundColor: const Color(0xFF778899),
              backgroundImage: NetworkImage(widget.usuario.fotoUrl.toString()),
            ),
            accountName: new Container(
                child: Text(
              widget.usuario.nombre.toString(),
              style: TextStyle(color: Colors.black),
            )),
            accountEmail: new Container(
                child: Text(
              widget.usuario.email.toString(),
              style: TextStyle(color: Colors.black),
            )),
          ),
          ListTile(
            leading: Icon(Icons.add_shopping_cart),
            title: Text('Agregar producto'),
            onTap: () => navegarAgregarProducto(context),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Cerrar Sesión'),
            onTap: () => salir(context),
          ),
        ],
      ),
    );

    return drawerView;
  }

  void salir(BuildContext context) {
    Navigator.pop(context);
    authService.signOut();
  }

  void navegarAgregarProducto(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AgregarProductoScreen()));
  }
}
