import 'package:flutter/material.dart';
import 'package:vivero/models/usuario.dart';
import 'package:vivero/services/auth.dart';
import 'package:vivero/services/transaccionService.dart';
import 'package:vivero/vistas/lista_productos/lista_productos.dart';
import 'package:vivero/widgets/carrito/carrito.dart';
// import 'package:vivero/widgets/drawer/drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  Usuario _profile = new Usuario();

  int _selectedIndex = 0;

  Future<String> codigoQR;

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
      ),
      body: _bodyChildren[_selectedIndex],
      // drawer: new DrawerWidget(usuario: _profile),
      bottomNavigationBar: barraInferior(),
      // floatingActionButton: obtenerFAB(_selectedIndex),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );

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
      bottomNavigationBar: barraInferior(),
    );

    Widget childWidget = authService.sesionIniciada ? vistaHome : vistaLogin;

    return childWidget;
  }

  @override
  initState() {
    super.initState();
    transaccionService.limpiar();
    authService.profile.listen((state) => setState(() => _profile = state));
  }

  void salir(BuildContext context) {
    Navigator.pop(context);
    authService.signOut();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.black,
      onTap: _onItemTapped,
    );
  }
}
