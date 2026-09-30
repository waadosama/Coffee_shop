class Coffee {
  final int id;
  final String name;
  final String description;
  final String image;

  /// Menu price in Egyptian Pounds. Hardcoded in the code base (the remote
  /// API price is ignored on purpose).
  final double priceEgp;

  const Coffee({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.priceEgp,
  });

  /// Price ready for display, e.g. `70 EGP`.
  String get formattedPriceEgp => formatEgp(priceEgp);

  /// Formats an amount as EGP, dropping the decimals of whole numbers.
  static String formatEgp(double amount) {
    final value = amount % 1 == 0
        ? amount.toInt().toString()
        : amount.toStringAsFixed(2);

    return '$value EGP';
  }
}
