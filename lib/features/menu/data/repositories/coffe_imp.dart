import '../../domain/entities/coffe.dart';
import '../../domain/repositories/coffee_repo.dart';
import '../datasources/remote.dart';

class CoffeeRepositoryImpl implements CoffeeRepository {
  final CoffeeRemoteDataSource remoteDataSource;

  CoffeeRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Coffee>> getHotCoffee() {
    return remoteDataSource.getHotCoffee();
  }
}