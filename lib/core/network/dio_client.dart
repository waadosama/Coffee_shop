import 'package:dio/dio.dart';

class DioClient {
  final Dio dio;

  DioClient()
      : dio = Dio(
          BaseOptions(
            baseUrl: 'https://funapi.dev',
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ),
        );
}