import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coffee_shop_app/features/cart/presentation/cart_navigator.dart';
import 'package:coffee_shop_app/features/cart/presentation/cubic/cubic.dart';
import 'package:coffee_shop_app/features/cart/presentation/pages/cart_page.dart';
import 'package:coffee_shop_app/features/menu/domain/entities/coffe.dart';

const _espresso = Coffee(
  id: 1,
  name: 'Espresso',
  description: 'A short, intense shot of pure coffee.',
  image: 'https://example.com/espresso.jpg',
  priceEgp: 70,
);

const _latte = Coffee(
  id: 2,
  name: 'Latte',
  description: 'Espresso softened with steamed milk.',
  image: 'https://example.com/latte.jpg',
  priceEgp: 90,
);

Widget _host(CartCubit cart, {Widget? home}) {
  return BlocProvider<CartCubit>.value(
    value: cart,
    child: MaterialApp(home: home ?? const CartPage()),
  );
}

/// Lets the snackbar auto-dismiss so no timers leak out of the test.
Future<void> _settleSnackbar(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 5));
  await tester.pumpAndSettle();
}

void main() {
  test('CartCubit increase and decrease rewrite the line quantity', () {
    final cart = CartCubit()..add(_espresso, quantity: 20);

    cart.increase(_espresso.id);
    expect(cart.state.items.single.quantity, 20, reason: 'capped at 20');

    cart.decrease(_espresso.id);
    expect(cart.state.items.single.quantity, 19);

    cart.decrease(_espresso.id);
    expect(cart.state.items.single.quantity, 18);

    // Dropping the last unit deletes the line instead of keeping a 0.
    final other = CartCubit()..add(_latte);
    other.decrease(_latte.id);
    expect(other.state.isEmpty, isTrue);

    // A drink that was never added stays untouched.
    cart.increase(_latte.id);
    expect(cart.state.items, hasLength(1));
  });

  testWidgets('empty cart shows the empty state and no checkout bar',
      (tester) async {
    await tester.pumpWidget(_host(CartCubit()));
    await tester.pump();

    expect(find.text('السلة فارغة'), findsOneWidget);
    expect(find.text('your cart is empty.'), findsOneWidget);
    expect(find.text('تصفّح المنيو'), findsOneWidget);
    expect(find.text('إتمام الطلب'), findsNothing);
    expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
  });

  testWidgets('cart lists every line with its EGP subtotal and the total',
      (tester) async {
    final cart = CartCubit()
      ..add(_espresso, quantity: 2)
      ..add(_latte);

    await tester.pumpWidget(_host(cart));
    await tester.pump();

    expect(find.text('ESPRESSO'), findsOneWidget);
    expect(find.text('LATTE'), findsOneWidget);

    // Unit prices and the espresso line subtotal (2 x 70).
    expect(find.text('70 EGP'), findsOneWidget);
    expect(find.text('140 EGP'), findsOneWidget);
    // The latte unit price and its 1 x 90 subtotal.
    expect(find.text('90 EGP'), findsNWidgets(2));

    // Header count, summary count and the order total (140 + 90).
    expect(find.text('3 منتج'), findsOneWidget);
    expect(find.textContaining('الإجمالي'), findsOneWidget);
    expect(find.text('230 EGP'), findsOneWidget);
    expect(find.text('إتمام الطلب'), findsOneWidget);
  });

  testWidgets('quantity stepper updates the line subtotal and the total',
      (tester) async {
    final cart = CartCubit()..add(_espresso);

    await tester.pumpWidget(_host(cart));
    await tester.pump();

    expect(find.text('140 EGP'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(cart.state.totalCount, 2);
    expect(cart.state.totalPriceEgp, 140);
    // Shown twice: the line subtotal and the order total.
    expect(find.text('140 EGP'), findsNWidgets(2));

    // Dropping back to the last unit removes the whole line.
    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump();

    expect(cart.state.isEmpty, isTrue);
    expect(find.text('السلة فارغة'), findsOneWidget);
  });

  testWidgets('removing a line empties the cart', (tester) async {
    final cart = CartCubit()..add(_espresso)..add(_latte);

    await tester.pumpWidget(_host(cart));
    await tester.pump();

    expect(find.text('160 EGP'), findsOneWidget);

    // Each line has its own close button; drop the espresso (first) line.
    await tester.tap(find.byIcon(Icons.close).first);
    await tester.pump();

    expect(cart.state.items, hasLength(1));
    expect(find.text('ESPRESSO'), findsNothing);
    expect(find.text('LATTE'), findsOneWidget);
    // Unit price, line subtotal and the order total of the lone latte.
    expect(find.text('90 EGP'), findsNWidgets(3));
  });

  testWidgets('checkout clears the cart and returns to the menu',
      (tester) async {
    final cart = CartCubit()..add(_espresso, quantity: 2);

    await tester.pumpWidget(
      _host(
        cart,
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () => openCartPage(context),
                child: const Text('open cart'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('open cart'));
    await tester.pumpAndSettle();

    expect(find.byType(CartPage), findsOneWidget);
    // Shown twice: the line subtotal and the order total.
    expect(find.text('140 EGP'), findsNWidgets(2));

    await tester.tap(find.text('إتمام الطلب'));
    await tester.pumpAndSettle();

    expect(cart.state.isEmpty, isTrue);
    expect(find.byType(CartPage), findsNothing);
    expect(find.textContaining('order placed'), findsOneWidget);

    await _settleSnackbar(tester);
  });
}
