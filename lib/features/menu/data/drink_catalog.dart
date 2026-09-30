/// Hardcoded menu details for every drink returned by the remote API:
/// the shop's price in EGP plus the tasting note shown on the product page.
///
/// The API only exposes a USD price, which does not match the shop's real
/// menu, so both values are owned here instead.
class DrinkCatalog {
  DrinkCatalog._();

  /// Price used for a drink that is not listed in [_prices].
  static const double defaultPriceEgp = 100;

  static const Map<String, double> _prices = {
    // Hot drinks
    'espresso': 70,
    'latte': 110,
    'cappuccino': 115,
    'flat white': 120,
    'mocha': 130,
    'turkish coffee': 90,
    // Cold drinks
    'cold brew': 135,
    'iced matcha latte': 150,
  };

  static const Map<String, String> _notes = {
    'espresso':
        'A short, intense shot of pure coffee with a rich golden crema '
        '— no milk, no sugar, just the bean.',
    'latte': 'Espresso mellowed with steamed milk and a thin layer of silky '
        'foam — soft, warm and easy to drink.',
    'cappuccino': 'Equal parts espresso, steamed milk and airy foam '
        '— light, comforting and gently sweet.',
    'flat white': 'Double espresso folded into velvety microfoam '
        '— strong, smooth and low on foam.',
    'mocha': 'Espresso, dark chocolate and steamed milk '
        '— sweet, rich and indulgent.',
    'turkish coffee': 'Finely ground coffee simmered slowly in a cezve '
        '— thick, aromatic and served unfiltered.',
    'cold brew': 'Coarse grounds steeped in cold water for twelve hours '
        '— smooth, sweet and low in acidity.',
    'iced matcha latte': 'Ceremonial matcha shaken with cold milk and ice '
        '— earthy, creamy and refreshing.',
  };

  static const String _defaultNote =
      'Prepared fresh to order with our specialty beans.';

  /// EGP price for [name], falling back to [defaultPriceEgp].
  static double priceEgpFor(String name) {
    return _prices[name.trim().toLowerCase()] ?? defaultPriceEgp;
  }

  /// Tasting note for [name].
  static String noteFor(String name) {
    return _notes[name.trim().toLowerCase()] ?? _defaultNote;
  }
}
