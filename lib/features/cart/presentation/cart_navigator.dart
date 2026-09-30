import 'package:flutter/material.dart';

import 'pages/cart_page.dart';

/// Opens the shopping cart: line items, quantity steppers, the EGP total and
/// checkout. The shared `CartCubit` is already provided above the Navigator.
void openCartPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const CartPage()),
  );
}
