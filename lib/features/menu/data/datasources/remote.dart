import 'package:dio/dio.dart';

import '../models/coffe_model.dart';

abstract class CoffeeRemoteDataSource {
  Future<List<CoffeeModel>> getHotCoffee();
}
class CoffeeRemoteDataSourceImpl
    implements CoffeeRemoteDataSource {
  final Dio dio;

  CoffeeRemoteDataSourceImpl(this.dio);

  @override
  Future<List<CoffeeModel>> getHotCoffee() async {
    final response = await dio.get(
      '/api/coffee/v1/drinks',
      queryParameters: {
        'type': 'hot',
      },
    );

    final List data = response.data;

    return data
        .map(
          (json) => CoffeeModel.fromJson(json),
        )
        .toList();
  }
}