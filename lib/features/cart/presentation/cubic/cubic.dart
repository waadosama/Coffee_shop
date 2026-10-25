import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/cart_item.dart';
import '../../domain/entities/order_draft.dart';
import '../../domain/repositories/order_repository.dart';
import '../../../menu/domain/entities/coffe.dart';
import 'state.dart';

/// Holds the shopping cart for the whole app.
///
/// Provided once above `MaterialApp`, so every page (menu sections and
/// product details) reads and updates the same cart.
class CartCubit extends Cubit<CartState> {
  CartCubit({OrderRepository? orders})
      : _orders = orders,
        super(const CartState());

  /// Backend used to notify the customer that an order was placed. It stays
  /// `null` in widget tests, where nothing should hit the network.
  final OrderRepository? _orders;

  /// Adds [quantity] of [coffee]. If the drink is already in the cart its
  /// quantity is increased instead of duplicating the line.
  void add(Coffee coffee, {int quantity = 1}) {
    if (quantity < 1) return;

    final items = [...state.items];
    final index = items.indexWhere((item) => item.coffee.id == coffee.id);

    if (index == -1) {
      items.add(CartItem(coffee: coffee, quantity: quantity));
    } else {
      items[index] = items[index].copyWith(
        quantity: items[index].quantity + quantity,
      );
    }

    emit(CartState(items));
  }

  /// Adds one more of the drink with [coffeeId]. Does nothing when the drink
  /// is not in the cart yet (use [add] to put it there).
  void increase(int coffeeId) => _setQuantity(coffeeId, (q) => q + 1);

  /// Drops one of the drink with [coffeeId]. The last remaining unit removes
  /// the whole line, so the cart never holds a zero-quantity item.
  void decrease(int coffeeId) => _setQuantity(coffeeId, (q) => q - 1);

  /// Rewrites the quantity of [coffeeId] with [next]. Values below 1 delete
  /// the line, values above 20 are clamped to match the product page.
  void _setQuantity(int coffeeId, int Function(int quantity) next) {
    final items = [...state.items];
    final index = items.indexWhere((item) => item.coffee.id == coffeeId);
    if (index == -1) return;

    final quantity = next(items[index].quantity);

    if (quantity < 1) {
      items.removeAt(index);
    } else {
      items[index] = items[index].copyWith(
        quantity: quantity > 20 ? 20 : quantity,
      );
    }

    emit(CartState(items));
  }

  /// Removes the whole line of the drink with [coffeeId].
  void remove(int coffeeId) {
    emit(
      CartState(
        state.items.where((item) => item.coffee.id != coffeeId).toList(),
      ),
    );
  }

  void clear() => emit(const CartState());

  /// Hands the just-checked-out [draft] to the backend, which pushes the
  /// *order is ready to be prepared* FCM notification to [fcmToken].
  ///
  /// Returns `true` once the backend accepted the order. Failures are logged
  /// rather than thrown: the confirmation dialog already told the customer
  /// what happened, so a flaky network must never break the checkout flow.
  Future<bool> placeOrder(OrderDraft draft, {String? fcmToken}) async {
    final orders = _orders;
    if (orders == null) return false;

    try {
      await orders.placeOrder(draft, fcmToken: fcmToken);
      return true;
    } catch (error) {
      debugPrint('Order notification request failed: $error');
      return false;
    }
  }
}
