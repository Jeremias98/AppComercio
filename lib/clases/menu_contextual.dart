import 'package:flutter/cupertino.dart';
import 'package:vivero/clases/item_menu.dart';
import 'package:vivero/excepciones/item_repetido_exception.dart';

class MenuContextual {
  List<ItemMenu> _items;

  MenuContextual() {
    _items = new List<ItemMenu>();
  }

  MenuContextual.desdeLista(List<ItemMenu> items) {
    if (items == null)
      _items = new List<ItemMenu>();
    else
      _items = items;
  }

  void agregar(String codigo, String titulo,
      [IconData icono, bool habilitado]) {
    ItemMenu item = new ItemMenu(codigo, titulo, icono, habilitado);
    if (obtener(item.codigo) != null)
      throw new ItemRepetidoException(
          "No puede insertar un item con el mismo codigo al MenuContextual");
    else
      _items.add(item);
  }

  ItemMenu quitar(String codigo) {
    ItemMenu itemMenu = obtener(codigo);
    if (itemMenu == null) return null;
    _items.remove(itemMenu);
    return itemMenu;
  }

  void deshabilitar(String codigo) {
    ItemMenu itemMenu = obtener(codigo);
    if (itemMenu != null) itemMenu.habilitado = false;
  }

  void habilitar(String codigo) {
    ItemMenu itemMenu = obtener(codigo);
    if (itemMenu != null) itemMenu.habilitado = true;
  }

  ItemMenu obtener(String codigo) {
    int indice = _items.indexWhere((item) => item.codigo == codigo);
    return indice >= 0 ? _items[indice] : null;
  }

  List<ItemMenu> items() {
    return _items;
  }
}
