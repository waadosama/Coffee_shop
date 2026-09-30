import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/cart_item.dart';
import '../../../menu/domain/entities/coffe.dart';
import 'state.dart';

/// Holds the shopping cart for the whole app.
///
/// Provided once above `MaterialApp`, so every page (menu sections and
/// product details) reads and updates the same cart.
class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

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

  /// Removes the whole line of the drink with [coffeeId].
  void remove(int coffeeId) {
    emit(
      CartState(
        state.items.where((item) => item.coffee.id != coffeeId).toList(),
      ),
    );
  }

  void clear() => emit(const CartState());
}
