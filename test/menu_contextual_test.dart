import "package:test/test.dart";
import 'package:vivero/clases/menu_contextual.dart';

void main() {
  group('El menu contextual inicialmente: ', () {
    test('No tiene items', () {
      MenuContextual menuContextual = new MenuContextual();
      expect(menuContextual.items().length, 0);
    });
  });

  group('Agregar y quitar items al menu: ', () {
    test('Aumenta en 1 (uno) la cantidad de items', () {
      MenuContextual menuContextual = new MenuContextual();
      menuContextual.agregar("ACCION", "Nombre");
      expect(menuContextual.items().length, 1);
      menuContextual.agregar("ACCION2", "Nombre2");
      expect(menuContextual.items().length, 2);
    });

    test('Un item agregado ahora pertenece al menu', () {
      MenuContextual menuContextual = new MenuContextual();
      menuContextual.agregar("ACCION", "Nombre");
      expect(menuContextual.obtener("ACCION"), isNotNull);
    });

    test('Agregar un item al carrito con un codigo existente lanza excepcion',
        () {
      MenuContextual menuContextual = new MenuContextual();
      menuContextual.agregar("ACCION", "Nombre");
      expect(() => menuContextual.agregar("ACCION", "Nombre"), throwsException);
    });

    test('Obtener un item inexistente devuelve null', () {
      MenuContextual menuContextual = new MenuContextual();
      menuContextual.agregar("ACCION", "Nombre");
      expect(menuContextual.obtener("ACCION_NO_EXISTENTE"), null);
    });

    test('Quitar un item que no esta devuelve null', () {
      MenuContextual menuContextual = new MenuContextual();
      expect(menuContextual.quitar("ACCION"), null);
    });

    test(
        'Quitar un item que esta en el menu devuelve ese item y ya no esta en el menu',
        () {
      MenuContextual menuContextual = new MenuContextual();
      menuContextual.agregar("ACCION", "Nombre");
      expect(menuContextual.quitar("ACCION"), isNotNull);
      expect(menuContextual.obtener("ACCION"), null);
    });
  });

  group('Habilitar y deshabilitar: ', () {
    test('Un item agregado esta habilitado inicialmente', () {
      MenuContextual menuContextual = new MenuContextual();
      menuContextual.agregar("ACCION", "Nombre");
      expect(menuContextual.obtener("ACCION").habilitado, true);
    });

    test('Se puede deshabilitar un item por codigo', () {
      MenuContextual menuContextual = new MenuContextual();
      menuContextual.agregar("ACCION", "Nombre");
      menuContextual.deshabilitar("ACCION");
      expect(menuContextual.obtener("ACCION").habilitado, false);
    });
  });
}
