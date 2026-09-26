import '../entities/coffe.dart';

abstract class CoffeeRepository {
  Future<List<Coffee>> getHotCoffee();
  Future<List<Coffee>> getColdDrinks();
  Future<List<Coffee>> getBreakfast();
}
