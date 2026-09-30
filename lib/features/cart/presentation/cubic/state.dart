import '../../domain/entities/cart_item.dart';
import '../../../menu/domain/entities/coffe.dart';

class CartState {
  const CartState([this.items = const []]);

  /// Everything currently in the cart, in insertion order.
  final List<CartItem> items;

  /// Sum of all quantities, e.g. a 2x Espresso and a 1x Latte give 3.
  int get totalCount => items.fold(0, (sum, item) => sum + item.quantity);

  /// Cart total in EGP.
  double get totalPriceEgp =>
      items.fold(0.0, (sum, item) => sum + item.subtotalEgp);

  bool get isEmpty => items.isEmpty;

  /// Formats an EGP amount, e.g. `140 EGP`.
  static String formattedEgp(double amount) => Coffee.formatEgp(amount);
}
