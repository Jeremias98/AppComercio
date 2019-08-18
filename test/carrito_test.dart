import "package:test/test.dart";
import 'package:vivero/models/producto.dart';
import 'package:vivero/clases/carrito.dart';

void main() {
  group('Carrito inicialmente: ', () {
    test('Tiene cero productos', () {
      final Carrito transaccion = new Carrito();

      expect(transaccion.obtenerProductos().length, 0);
    });

    test('Esta vacio', () {
      final Carrito transaccion = new Carrito();

      expect(transaccion.estaVacio(), true);
    });

    test('Tiene cero unidades de un producto cualquiera', () {
      final Carrito transaccion = new Carrito();

      final Producto producto1 = new Producto(id: "1");

      expect(transaccion.obtenerUnidades(producto1), 0);
    });

    test('Tiene cero unidades en total', () {
      final Carrito transaccion = new Carrito();

      expect(transaccion.obtenerTotalUnidades(), 0);
    });

    test('Suma un precio total de cero', () {
      final Carrito transaccion = new Carrito();

      expect(transaccion.obtenerPrecioTotal(), 0);
    });
  });

  group('Agregar al carrito: ', () {
    test('Un producto no pertenece, lo agrego, luego este pertenece al carrito',
        () {
      final Carrito transaccion = new Carrito();
      final Producto producto1 = new Producto(id: "1");

      expect(transaccion.pertenece(producto1), false);
      transaccion.agregar(producto1);
      expect(transaccion.pertenece(producto1), true);
    });

    test(
        'Productos distintos al carrito deberia incrementar la cantidad de productos en 1',
        () {
      final Carrito transaccion = new Carrito();
      final Producto producto1 = new Producto(id: "1");
      final Producto producto2 = new Producto(id: "2");
      final Producto producto3 = new Producto(id: "3");

      transaccion.agregar(producto1);
      expect(transaccion.obtenerProductos().length, 1);

      transaccion.agregar(producto2);
      expect(transaccion.obtenerProductos().length, 2);

      transaccion.agregar(producto3);
      expect(transaccion.obtenerProductos().length, 3);
    });

    test(
        'Productos distintos al carrito deberia incrementar las unidades de cada producto uno en 1',
        () {
      final Carrito transaccion = new Carrito();
      final Producto producto1 = new Producto(id: "1");
      final Producto producto2 = new Producto(id: "2");
      final Producto producto3 = new Producto(id: "3");

      transaccion.agregar(producto1);
      expect(transaccion.obtenerUnidades(producto1), 1);

      transaccion.agregar(producto2);
      expect(transaccion.obtenerUnidades(producto2), 1);

      transaccion.agregar(producto3);
      expect(transaccion.obtenerUnidades(producto3), 1);
    });

    test(
        'Varias veces el mismo producto deberia incrementar sus unidades, pero no la cantidad de productos',
        () {
      final Carrito transaccion = new Carrito();
      final Producto producto1 = new Producto(id: "1");

      transaccion.agregar(producto1);
      expect(transaccion.obtenerUnidades(producto1), 1);
      expect(transaccion.obtenerProductos().length, 1);

      transaccion.agregar(producto1);
      expect(transaccion.obtenerUnidades(producto1), 2);
      expect(transaccion.obtenerProductos().length, 1);

      transaccion.agregar(producto1);
      expect(transaccion.obtenerUnidades(producto1), 3);
      expect(transaccion.obtenerProductos().length, 1);
    });

    test(
        'Poner una cantidad de unidades por parametro deberia agregar esas unidades del producto',
        () {
      final Carrito transaccion = new Carrito();
      final Producto producto1 = new Producto(id: "1");

      transaccion.agregarPorCantidad(producto1, 1);
      expect(transaccion.obtenerUnidades(producto1), 1);
      expect(transaccion.obtenerProductos().length, 1);

      transaccion.agregarPorCantidad(producto1, 2);
      expect(transaccion.obtenerUnidades(producto1), 3);
      expect(transaccion.obtenerProductos().length, 1);

      transaccion.agregarPorCantidad(producto1, 3);
      expect(transaccion.obtenerUnidades(producto1), 6);
      expect(transaccion.obtenerProductos().length, 1);
    });

    test('Algunos productos, luego puedo obtener el total de unidades', () {
      final Carrito transaccion = new Carrito();
      final Producto producto1 = new Producto(id: "1");
      final Producto producto2 = new Producto(id: "2");
      final Producto producto3 = new Producto(id: "3");

      transaccion.agregarPorCantidad(producto1, 1);
      transaccion.agregarPorCantidad(producto2, 2);
      transaccion.agregarPorCantidad(producto3, 3);

      expect(transaccion.obtenerTotalUnidades(), 6);

      transaccion.agregarPorCantidad(producto3, 4);

      expect(transaccion.obtenerTotalUnidades(), 10);
    });

    test(
        'Varios productos y luego quito de a uno, deberian no haber unidades de ellos',
        () {
      final Carrito transaccion = new Carrito();

      final Producto producto1 = new Producto(id: "1");
      transaccion.agregar(producto1);

      final Producto producto2 = new Producto(id: "2");
      transaccion.agregar(producto2);

      expect(transaccion.pertenece(producto1), true);
      expect(transaccion.pertenece(producto2), true);

      transaccion.quitar(producto1);
      expect(transaccion.pertenece(producto1), false);
      expect(transaccion.obtenerUnidades(producto1), 0);
      expect(transaccion.obtenerProductos().length, 1);

      transaccion.quitar(producto2);
      expect(transaccion.pertenece(producto2), false);
      expect(transaccion.obtenerUnidades(producto2), 0);
      expect(transaccion.obtenerProductos().length, 0);
    });

    test('Limpiar el carrito deja en 0 la cantidad de productos y sus unidades',
        () {
      final Carrito transaccion = new Carrito();

      final Producto producto1 = new Producto(id: "1");
      transaccion.agregar(producto1);

      final Producto producto2 = new Producto(id: "2");
      transaccion.agregar(producto2);

      transaccion.limpiar();

      expect(transaccion.obtenerProductos().length, 0);
      expect(transaccion.obtenerUnidades(producto1), 0);
      expect(transaccion.obtenerUnidades(producto2), 0);
    });
  });

  group('Precios del carrito: ', () {
    test(
        'Agrego un producto con una unidad, y el precio total es el precio de venta de ese producto',
        () {
      final Carrito transaccion = new Carrito();
      final Producto producto1 =
          new Producto(id: "1", precioUnitario: 10, porcentajeGanancia: 5);

      transaccion.agregar(producto1);
      expect(transaccion.obtenerPrecioTotal(), producto1.obtenerPrecioVenta());
    });

    test(
        'Agregar varias unidades de un producto, devuelve el precio de venta multiplicado por las unidades',
        () {
      final Carrito transaccion = new Carrito();
      final Producto producto1 =
          new Producto(id: "1", precioUnitario: 20, porcentajeGanancia: 10);

      transaccion.agregarPorCantidad(producto1, 10);
      expect(transaccion.obtenerPrecioTotal(),
          producto1.obtenerPrecioVenta() * 10);
    });

    test('Agrego varios productos y el precio total es la suma de ellos', () {
      final Carrito transaccion = new Carrito();
      final Producto producto1 =
          new Producto(id: "1", precioUnitario: 10, porcentajeGanancia: 10);
      final Producto producto2 =
          new Producto(id: "2", precioUnitario: 20, porcentajeGanancia: 20);
      final Producto producto3 =
          new Producto(id: "3", precioUnitario: 30, porcentajeGanancia: 30);

      transaccion.agregar(producto1);
      transaccion.agregar(producto2);
      transaccion.agregar(producto3);
      expect(
          transaccion.obtenerPrecioTotal(),
          producto1.obtenerPrecioVenta() +
              producto2.obtenerPrecioVenta() +
              producto3.obtenerPrecioVenta());
    });

    test(
        'Agrego varias unidades de distintos productos y el precio total es la suma de ellos por su cantidad de unidades',
        () {
      final Carrito transaccion = new Carrito();
      final Producto producto1 =
          new Producto(id: "1", precioUnitario: 10, porcentajeGanancia: 10);
      final Producto producto2 =
          new Producto(id: "2", precioUnitario: 20, porcentajeGanancia: 20);
      final Producto producto3 =
          new Producto(id: "3", precioUnitario: 30, porcentajeGanancia: 30);

      transaccion.agregarPorCantidad(producto1, 1);
      transaccion.agregarPorCantidad(producto2, 2);
      transaccion.agregarPorCantidad(producto3, 3);
      expect(
          transaccion.obtenerPrecioTotal(),
          producto1.obtenerPrecioVenta() +
              producto2.obtenerPrecioVenta() * 2 +
              producto3.obtenerPrecioVenta() * 3);
    });
  });
}
