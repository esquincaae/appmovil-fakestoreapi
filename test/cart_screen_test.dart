import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_list_app/models/product.dart';
import 'package:product_list_app/cart/cart.dart';
import 'package:product_list_app/screens/cart_screen.dart';

void main() {
  group('CartScreen', () {
    setUp(() {
      Cart.items.clear(); //Limpiar antes de cada test
      Cart.add(Product(
        id: 1,
        title: 'Producto de prueba',
        description: 'Descripción',
        price: 99.99,
        image: 'https://via.placeholder.com/150',
      ));
    });

    testWidgets('Muestra productos y total en el carrito', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: CartScreen()));

      // Verifica que el título del producto se muestre
      expect(find.text('Producto de prueba'), findsOneWidget);

      // Verifica que el total se muestre correctamente
      expect(find.textContaining('Total: \$99.99'), findsOneWidget);
    });

    testWidgets('Botón "Comprar" vacía el carrito', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: CartScreen()));

      // Verifica que el producto esté presente
      expect(find.text('Producto de prueba'), findsOneWidget);

      // Presiona el botón "Comprar"
      final buyButton = find.widgetWithText(ElevatedButton, 'Comprar');
      expect(buyButton, findsOneWidget);

      await tester.tap(buyButton);
      await tester.pump(); // Refresca UI

      // Verifica que ya no haya productos en pantalla
      expect(find.text('Producto de prueba'), findsNothing);
      expect(find.text('El carrito está vacío'), findsOneWidget);
    });

    testWidgets('Incrementa y reduce cantidad con botones + y -', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: CartScreen()));

      // Verifica cantidad inicial
      expect(find.text('Cantidad: 1'), findsOneWidget);

      // Presiona +
      final addButton = find.byIcon(Icons.add);
      await tester.tap(addButton);
      await tester.pump();
      expect(find.text('Cantidad: 2'), findsOneWidget);

      // Presiona -
      final removeButton = find.byIcon(Icons.remove);
      await tester.tap(removeButton);
      await tester.pump();
      expect(find.text('Cantidad: 1'), findsOneWidget);
    });
  });
}
