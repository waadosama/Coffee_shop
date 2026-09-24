import 'package:dio/dio.dart';

import '../models/coffe_model.dart';

abstract class CoffeeRemoteDataSource {
  Future<List<CoffeeModel>> getHotCoffee();
}

class CoffeeRemoteDataSourceImpl implements CoffeeRemoteDataSource {
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

    final data = _extractCoffeeList(response.data);

    return data
        .map(
          (json) => CoffeeModel.fromJson(Map<String, dynamic>.from(json)),
        )
        .toList();
  }

  List<dynamic> _extractCoffeeList(dynamic json) {
    if (json is List) {
      return json;
    }

    if (json is Map) {
      for (final key in ['data', 'drinks', 'items', 'results']) {
        final value = json[key];
        if (value is List) {
          return value;
        }
      }
    }

    throw FormatException(
      'Unexpected coffee response format: ${json.runtimeType}',
    );
  }
}
