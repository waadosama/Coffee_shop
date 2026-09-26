import '../../domain/entities/coffe.dart';

class CoffeeModel extends Coffee {
  const CoffeeModel({
    required super.id,
    required super.name,
    required super.description,
    required super.image,
  });

  factory CoffeeModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final ingredients = json['ingredients'];
    final price = json['price'];
    final description =
        json['description']?.toString() ??
        (ingredients is List
            ? ingredients.join(', ')
            : price == null
            ? ''
            : 'Hot coffee - \$${_formatPrice(price)}');
    final name = (json['name'] ?? json['title'] ?? 'Coffee').toString();

    return CoffeeModel(
      id: rawId is int ? rawId : int.tryParse('$rawId') ?? 0,
      name: name,
      description: description,
      image: _imageFromJson(json, name),
    );
  }

  static String _formatPrice(dynamic price) {
    final value = price is num ? price : num.tryParse('$price');
    if (value == null) {
      return '$price';
    }

    return value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(2);
  }

  static String _imageFromJson(Map<String, dynamic> json, String name) {
    final image =
        json['image'] ?? json['imageUrl'] ?? json['thumbnail'] ?? json['photo'];
    if (image != null && image.toString().trim().isNotEmpty) {
      return image.toString();
    }

    return _fallbackImages[name.toLowerCase()] ?? _fallbackImages['coffee']!;
  }

  static const Map<String, String> _fallbackImages = {
    'espresso':
        'https://images.unsplash.com/photo-1510707577719-ae7c14805e3a?auto=format&fit=crop&w=700&q=80',
    'latte':
        'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?auto=format&fit=crop&w=700&q=80',
    'cappuccino':
        'https://images.unsplash.com/photo-1534778101976-62847782c213?auto=format&fit=crop&w=700&q=80',
    'flat white':
        'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?auto=format&fit=crop&w=700&q=80',
    'mocha':
        'https://images.unsplash.com/photo-1578314675249-a6910f80cc4e?auto=format&fit=crop&w=700&q=80',
    'turkish coffee':
        'https://images.unsplash.com/photo-1521302080334-4bebac2763a6?auto=format&fit=crop&w=700&q=80',
    'cold brew':
        'https://images.unsplash.com/photo-1517701550927-30cf4ba1dba5?auto=format&fit=crop&w=700&q=80',
    'iced matcha latte':
        'https://images.unsplash.com/photo-1536256263959-770b48d82b0a?auto=format&fit=crop&w=700&q=80',
    'coffee':
        'https://images.unsplash.com/photo-1509042239860-f550ce710b93?auto=format&fit=crop&w=700&q=80',
  };
}
