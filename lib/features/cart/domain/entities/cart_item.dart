import '../../../menu/domain/entities/coffe.dart';

/// A drink together with how many of it the customer wants.
class CartItem {
  const CartItem({required this.coffee, this.quantity = 1});

  final Coffee coffee;
  final int quantity;

  /// Line total in EGP.
  double get subtotalEgp => coffee.priceEgp * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(coffee: coffee, quantity: quantity ?? this.quantity);
  }
}
