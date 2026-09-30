import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coffee_shop_app/features/cart/presentation/cubic/cubic.dart';
import 'package:coffee_shop_app/features/cart/presentation/cubic/state.dart';
import 'package:coffee_shop_app/features/menu/domain/entities/coffe.dart';
import 'package:coffee_shop_app/features/menu/domain/repositories/coffee_repo.dart';
import 'package:coffee_shop_app/features/menu/domain/usecases/use.dart';
import 'package:coffee_shop_app/features/menu/presentation/cubic/cubic.dart';
import 'package:coffee_shop_app/features/menu/presentation/pages/menu_page.dart';
import 'package:coffee_shop_app/features/menu/presentation/pages/product_details_page.dart';

const _espresso = Coffee(
  id: 1,
  name: 'Espresso',
  description: 'A short, intense shot of pure coffee.',
  image: 'https://example.com/espresso.jpg',
  priceEgp: 70,
);

/// Serves the same drink list without touching the network.
class _FakeCoffeeRepository implements CoffeeRepository {
  @override
  Future<List<Coffee>> getHotCoffee() async => const [_espresso];

  @override
  Future<List<Coffee>> getColdDrinks() async => const [_espresso];

  @override
  Future<List<Coffee>> getBreakfast() async => const [_espresso];
}

Widget _host(CartCubit cart) {
  return BlocProvider<CartCubit>.value(
    value: cart,
    child: MaterialApp(home: ProductDetailsPage(coffee: _espresso)),
  );
}

void main() {
  test('CartCubit merges quantities of the same drink', () {
    final cart = CartCubit();

    cart.add(_espresso);
    cart.add(_espresso, quantity: 2);

    expect(cart.state.items, hasLength(1));
    expect(cart.state.totalCount, 3);
    expect(cart.state.totalPriceEgp, 210);
  });

  test('CartCubit removes a line and formats the EGP total', () {
    final cart = CartCubit()..add(_espresso, quantity: 2);

    expect(CartState.formattedEgp(cart.state.totalPriceEgp), '140 EGP');

    cart.remove(_espresso.id);

    expect(cart.state.isEmpty, isTrue);
    expect(cart.state.totalCount, 0);
  });

  testWidgets('product page shows the note and the price in EGP',
      (tester) async {
    await tester.pumpWidget(_host(CartCubit()));
    await tester.pump();

    expect(find.text('ESPRESSO'), findsOneWidget);
    expect(
      find.text('A short, intense shot of pure coffee.'),
      findsOneWidget,
    );
    expect(find.text('NOTE — ملاحظة'), findsOneWidget);
    // Shown twice: the price row and the running total (quantity 1).
    expect(find.text('70 EGP'), findsNWidgets(2));
    expect(find.text('أضف للسلة'), findsOneWidget);
  });

  testWidgets('add to cart button puts the drink in the cart',
      (tester) async {
    final cart = CartCubit();

    await tester.pumpWidget(_host(cart));
    await tester.pump();

    await tester.tap(find.text('أضف للسلة'));
    await tester.pump();

    expect(cart.state.totalCount, 1);
    expect(cart.state.totalPriceEgp, 70);
    expect(find.textContaining('added to cart'), findsOneWidget);

    // Let the snackbar auto-dismiss so no timers leak out of the test.
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });

  testWidgets('quantity selector updates the EGP total before adding',
      (tester) async {
    final cart = CartCubit();

    await tester.pumpWidget(_host(cart));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('140 EGP'), findsOneWidget);

    await tester.tap(find.text('أضف للسلة'));
    await tester.pump();

    expect(cart.state.totalCount, 2);
    expect(cart.state.totalPriceEgp, 140);

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });

  testWidgets('tapping a drink card opens its details page', (tester) async {
    final cart = CartCubit();
    final coffeeCubit = CoffeeCubit(GetHotCoffee(_FakeCoffeeRepository()));

    await tester.pumpWidget(
      BlocProvider<CartCubit>.value(
        value: cart,
        child: MaterialApp(
          home: BlocProvider<CoffeeCubit>.value(
            value: coffeeCubit..fetchHotCoffee(),
            child: const MenuPage(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('ESPRESSO'), findsOneWidget);

    await tester.tap(find.text('ESPRESSO'));
    await tester.pumpAndSettle();

    // The details page now shows the note and the EGP price.
    expect(find.byType(ProductDetailsPage), findsOneWidget);
    expect(find.text('NOTE — ملاحظة'), findsOneWidget);
    expect(find.text('70 EGP'), findsNWidgets(2));

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.byType(ProductDetailsPage), findsNothing);
    expect(find.byType(MenuPage), findsOneWidget);
  });
}
