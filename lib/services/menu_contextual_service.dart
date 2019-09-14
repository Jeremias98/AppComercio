import 'package:flutter/material.dart';
import 'package:vivero/clases/item_menu.dart';
import 'package:vivero/clases/menu_contextual.dart';
import 'package:vivero/vistas/renovar_stock_precios/renovar_stock_precios.dart';

class MenuContextualService extends MenuContextual {
  MenuContextualService() : super() {
    agregar("RENOVAR_STOCK_PRECIOS", "Renovar Stock y Precios");
  }

  itemClickeado(ItemMenu item, contexto) {
    if (!item.habilitado) return;
    switch (item.codigo) {
      case ("RENOVAR_STOCK_PRECIOS"):
        Navigator.push(
            contexto,
            new MaterialPageRoute(
                builder: (BuildContext context) =>
                    new RenovarStockPreciosView()));
        break;
    }
  }
}

final MenuContextualService menuContextualService = MenuContextualService();
