import '../entities/coffe.dart';

abstract class CoffeeRepository {
  Future<List<Coffee>> getHotCoffee();
}