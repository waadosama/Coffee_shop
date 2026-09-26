import '../../domain/entities/coffe.dart';
import '../../domain/repositories/coffee_repo.dart';
import '../datasources/local.dart';
import '../datasources/remote.dart';

class CoffeeRepositoryImpl implements CoffeeRepository {
  final CoffeeRemoteDataSource remoteDataSource;
  final BreakfastLocalDataSource breakfastLocalDataSource;

  CoffeeRepositoryImpl(
    this.remoteDataSource, {
    BreakfastLocalDataSource? breakfastLocalDataSource,
  }) : breakfastLocalDataSource =
           breakfastLocalDataSource ?? const BreakfastLocalDataSourceImpl();

  @override
  Future<List<Coffee>> getHotCoffee() {
    return remoteDataSource.getHotCoffee();
  }

  @override
  Future<List<Coffee>> getColdDrinks() {
    return remoteDataSource.getColdDrinks();
  }

  @override
  Future<List<Coffee>> getBreakfast() {
    return breakfastLocalDataSource.getBreakfast();
  }
}
