import "package:test/test.dart";
import 'package:vivero/models/producto.dart';

void main() {
  test('Un producto tiene un precio de compra', () {
    final Producto producto1 =
        new Producto(id: "1", precioUnitario: 30, porcentajeGanancia: 50);

    expect(producto1.obtenerPrecioCompra(), 30);
  });

  test(
      'Un producto tiene un precio de venta y es precio de compra + porcentaje de ganancia',
      () {
    final Producto producto1 =
        new Producto(id: "1", precioUnitario: 30, porcentajeGanancia: 50);

    expect(producto1.obtenerPrecioVenta(), 45);

    final Producto producto2 =
        new Producto(id: "1", precioUnitario: 50, porcentajeGanancia: 100);

    expect(producto2.obtenerPrecioVenta(), 100);
  });

  test('Un producto tiene una ganancia porcentual sobre el precio de compra',
      () {
    final Producto producto1 =
        new Producto(id: "1", precioUnitario: 30, porcentajeGanancia: 50);

    expect(producto1.obtenerGanancia(), 15);

    final Producto producto2 =
        new Producto(id: "2", precioUnitario: 50, porcentajeGanancia: 100);

    expect(producto2.obtenerGanancia(), 50);
  });
}
