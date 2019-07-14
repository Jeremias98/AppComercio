import 'package:flutter/material.dart';

class AgregarProductoScreen extends StatefulWidget {
  @override
  _AgregarProductoScreen createState() => _AgregarProductoScreen();
}

class _AgregarProductoScreen extends State<AgregarProductoScreen> {
  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    final Widget formularioScaffold = Scaffold(
        appBar: AppBar(title: Text("Mi Comercio")),
        drawer: Drawer(),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Nombre'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Este campo está vacío';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false
                    // otherwise.
                    if (_formKey.currentState.validate()) {
                      // If the form is valid, display a Snackbar.
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Processing Data')));
                    }
                  },
                  child: Text('Guardar'),
                ),
              ),
            ],
          ), // Build this out in the next steps.
        ));

    return formularioScaffold;
  }
}
