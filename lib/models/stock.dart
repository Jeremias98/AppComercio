import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vivero/models/valor_temporal.dart';

class Stock {
  List<ValorTemporal> valores = new List();

  Stock({this.valores});

  stockActual() {
    print(this.valores);
    return 5;
    //return valores.map((v) => v.valor).first;
  }

}
