import 'package:flutter/material.dart';
import 'package:vivero/clases/item_menu.dart';
import 'package:vivero/clases/menu_contextual.dart';
import 'package:vivero/services/auth.dart';
import 'package:vivero/services/menu_contextual_service.dart';
import 'package:vivero/services/transaccionService.dart';
import 'package:vivero/vistas/lista_productos/lista_productos.dart';
import 'package:vivero/widgets/carrito/carrito.dart';
// import 'package:vivero/widgets/drawer/drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  int _indiceSeleccionado = 0;

  Future<String> codigoQR;

  MenuContextual _menuContextual = new MenuContextual();

  final List<Widget> _bodyChildren = [CarritoWidget(), ListaProductosView()];

  FloatingActionButton fabAgregarProducto = FloatingActionButton.extended(
      icon: Icon(Icons.add),
      backgroundColor: Colors.deepPurpleAccent,
      onPressed: () => {},
      label: new Text('Nuevo'));

  obtenerFAB(indice) {
    if (indice == 1) return fabAgregarProducto;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final Widget vistaHome = Scaffold(
        appBar: AppBar(
            title: Text("Mi Comercio"),
            backgroundColor: Colors.deepPurpleAccent,
            actions: <Widget>[
              PopupMenuButton<ItemMenu>(
                elevation: 3.2,
                onCanceled: () {},
                onSelected: (item) =>
                    menuContextualService.itemClickeado(item, context),
                itemBuilder: (BuildContext context) {
                  return menuContextualService.items().map((ItemMenu item) {
                    return PopupMenuItem<ItemMenu>(
                      value: item,
                      child: Text(item.titulo),
                    );
                  }).toList();
                },
              )
            ]),
        body: _bodyChildren[_indiceSeleccionado],
        bottomNavigationBar: barraInferior());

    final Widget vistaLogin = Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            MaterialButton(
              onPressed: () => authService.googleSignIn(),
              color: Colors.white,
              textColor: Colors.blue,
              child: Text('Ingresar con Google'),
            )
          ])
        ],
      ),
    );

    Widget childWidget = authService.sesionIniciada ? vistaHome : vistaLogin;

    return childWidget;
  }

  @override
  initState() {
    super.initState();
    transaccionService.limpiar();
    authService.profile.listen(
        (state) => setState(() => authService.establecerUsuario(state)));
  }

  void establecerUsuario(state) {
    authService.establecerUsuario(state);
  }

  void salir(BuildContext context) {
    Navigator.pop(context);
    authService.signOut();
  }

  void _onItemTapped(int index) {
    setState(() {
      _indiceSeleccionado = index;
    });
  }

  Widget barraInferior() {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          title: Text('Carrito'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          title: Text('Productos'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          title: Text('Perfil'),
        ),
      ],
      currentIndex: _indiceSeleccionado,
      selectedItemColor: Colors.black,
      onTap: _onItemTapped,
    );
  }
}
