import '../entities/coffe.dart';
import '../repositories/coffee_repo.dart';

class GetHotCoffee {
  final CoffeeRepository repository;

  GetHotCoffee(this.repository);

  Future<List<Coffee>> call() {
    return repository.getHotCoffee();
  }
}