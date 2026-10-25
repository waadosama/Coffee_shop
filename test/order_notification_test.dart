import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coffee_shop_app/features/cart/domain/entities/cart_item.dart';
import 'package:coffee_shop_app/features/cart/domain/entities/order_draft.dart';
import 'package:coffee_shop_app/features/cart/domain/repositories/order_repository.dart';
import 'package:coffee_shop_app/features/cart/presentation/cart_navigator.dart';
import 'package:coffee_shop_app/features/cart/presentation/cubic/cubic.dart';
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

/// Stands in for the backend that pushes the FCM notification.
class _RecordingOrderRepository implements OrderRepository {
  OrderDraft? draft;
  String? fcmToken;
  bool throwOnSend = false;

  @override
  Future<void> placeOrder(OrderDraft draft, {String? fcmToken}) async {
    this.draft = draft;
    this.fcmToken = fcmToken;
    if (throwOnSend) throw Exception('backend unreachable');
  }
}

Widget _host(CartCubit cart) {
  return BlocProvider<CartCubit>.value(
    value: cart,
    child: MaterialApp(
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
}

/// Dismisses the confirmation dialog and lets its snackbar time out.
Future<void> _settleOrderUi(WidgetTester tester) async {
  await tester.tap(find.text('تمام'));
  await tester.pumpAndSettle();
  await tester.pump(const Duration(seconds: 5));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('checkout sends the order snapshot so FCM can be triggered',
      (tester) async {
    final orders = _RecordingOrderRepository();
    final cart = CartCubit(orders: orders)
      ..add(_espresso, quantity: 2)
      ..add(_latte);

    await tester.pumpWidget(_host(cart));
    await tester.pumpAndSettle();

    await tester.tap(find.text('open cart'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('إتمام الطلب'));
    await tester.pumpAndSettle();

    // The cart is emptied, but the snapshot taken before clearing it must
    // have reached the backend.
    expect(cart.state.isEmpty, isTrue);
    expect(orders.draft, isNotNull);
    expect(orders.draft!.itemCount, 3);
    expect(orders.draft!.totalEgp, 230);
    expect(orders.draft!.lines.map((line) => line.name), [
      'Espresso',
      'Latte',
    ]);
    expect(orders.draft!.lines.first.quantity, 2);

    // No device token in widget tests — FcmService.init never ran here.
    expect(orders.fcmToken, isNull);

    await _settleOrderUi(tester);
  });

  testWidgets('the confirmation still completes when the backend is down',
      (tester) async {
    final orders = _RecordingOrderRepository()..throwOnSend = true;
    final cart = CartCubit(orders: orders)..add(_espresso);

    await tester.pumpWidget(_host(cart));
    await tester.pumpAndSettle();

    await tester.tap(find.text('open cart'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('إتمام الطلب'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(cart.state.isEmpty, isTrue);

    await _settleOrderUi(tester);
  });

  test('placeOrder reports a failure instead of throwing', () async {
    final orders = _RecordingOrderRepository()..throwOnSend = true;
    final cart = CartCubit(orders: orders)..add(_espresso);
    final draft = OrderDraft.fromItems(cart.state.items);

    final accepted = await cart.placeOrder(draft, fcmToken: 'token-123');

    expect(accepted, isFalse);
    expect(orders.fcmToken, 'token-123');
  });

  test('placeOrder is a no-op when no backend is wired in', () async {
    final cart = CartCubit()..add(_espresso);
    final draft = OrderDraft.fromItems(cart.state.items);

    expect(await cart.placeOrder(draft), isFalse);
  });

  test('OrderDraft sums quantities and EGP totals from the cart lines', () {
    final draft = OrderDraft.fromItems(const [
      CartItem(coffee: _espresso, quantity: 3),
      CartItem(coffee: _latte),
    ]);

    expect(draft.itemCount, 4);
    expect(draft.totalEgp, 300); // 3 x 70 + 1 x 90
    expect(draft.lines, hasLength(2));
    expect(draft.lines.last.unitPriceEgp, 90);
  });
}
