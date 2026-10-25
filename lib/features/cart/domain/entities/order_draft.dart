import 'cart_item.dart';

/// Immutable snapshot of a checkout, captured while the cart is still full.
///
/// The cart is emptied the moment the order is placed, so everything the
/// backend needs to notify the customer has to be copied out first.
class OrderDraft {
  OrderDraft.fromItems(List<CartItem> items)
      : itemCount = items.fold(0, (sum, item) => sum + item.quantity),
        totalEgp = items.fold(0.0, (sum, item) => sum + item.subtotalEgp),
        lines = [
          for (final item in items)
            OrderLine(
              name: item.coffee.name,
              quantity: item.quantity,
              unitPriceEgp: item.coffee.priceEgp,
            ),
        ];

  /// Number of drinks in the order (quantities summed).
  final int itemCount;

  /// Order total in EGP.
  final double totalEgp;

  /// One entry per drink line, in cart order.
  final List<OrderLine> lines;
}

/// A single drink line of an [OrderDraft].
class OrderLine {
  const OrderLine({
    required this.name,
    required this.quantity,
    required this.unitPriceEgp,
  });

  final String name;
  final int quantity;
  final double unitPriceEgp;
}
