import 'package:flutter/material.dart';
import 'package:vivero/models/producto.dart';
import 'package:vivero/models/usuario.dart';
import 'package:vivero/services/auth.dart';
import 'package:qr_reader/qr_reader.dart';
import 'package:vivero/services/productosService.dart';
import 'package:vivero/services/transaccionService.dart';
import 'package:vivero/widgets/carrito/carrito.dart';
import 'package:vivero/widgets/drawer/drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  Usuario _profile = new Usuario();

  Future<String> codigoQR;

  @override
  Widget build(BuildContext context) {
    final Widget buildScaffold = Scaffold(
      appBar: AppBar(
        title: Text("Carrito"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: CarritoWidget(),
      drawer: new DrawerWidget(usuario: _profile),
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
    ));

    Widget childWidget =
        authService.sesionIniciada ? buildScaffold : vistaLogin;

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
}
