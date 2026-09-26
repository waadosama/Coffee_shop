import '../entities/coffe.dart';
import '../repositories/coffee_repo.dart';

class GetHotCoffee {
  final CoffeeRepository repository;

  GetHotCoffee(this.repository);

  Future<List<Coffee>> call() {
    return repository.getHotCoffee();
  }
}

class GetColdDrinks {
  final CoffeeRepository repository;

  GetColdDrinks(this.repository);

  Future<List<Coffee>> call() {
    return repository.getColdDrinks();
  }
}

class GetBreakfast {
  final CoffeeRepository repository;

  GetBreakfast(this.repository);

  Future<List<Coffee>> call() {
    return repository.getBreakfast();
  }
}
