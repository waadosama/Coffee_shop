import '../../domain/entities/coffe.dart';

abstract class CoffeeState {}

class CoffeeInitial extends CoffeeState {}

class CoffeeLoading extends CoffeeState {}

class CoffeeSuccess extends CoffeeState {
  final List<Coffee> coffee;

  CoffeeSuccess(this.coffee);
}

class CoffeeError extends CoffeeState {
  final String message;

  CoffeeError(this.message);
}