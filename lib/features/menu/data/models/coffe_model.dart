import '../../domain/entities/coffe.dart';

class CoffeeModel extends Coffee {
  const CoffeeModel({
    required super.id,
    required super.name,
    required super.description,
    required super.image,
  });

  factory CoffeeModel.fromJson(Map<String, dynamic> json) {
    return CoffeeModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
    );
  }
}