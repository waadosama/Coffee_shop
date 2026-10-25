import 'package:dio/dio.dart';

import '../../domain/entities/order_draft.dart';

/// Talks to the order backend (`POST /api/orders`).
abstract class OrderRemoteDataSource {
  Future<void> postOrder(OrderDraft draft, {String? fcmToken});
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  /// [dio] may be injected by tests; production uses a client pointed at
  /// [ORDER_API_BASE].
  OrderRemoteDataSourceImpl([Dio? dio]) : dio = dio ?? _defaultDio();

  /// Base URL of the order backend.
  ///
  /// `10.0.2.2` is the host machine as seen from the Android emulator; pass
  /// `--dart-define=ORDER_API_BASE=http://192.168.1.10:8080` when running on
  /// a real device, or the deployed HTTPS URL once the backend is live.
  static const String baseUrl = String.fromEnvironment(
    'ORDER_API_BASE',
    defaultValue: 'http://10.0.2.2:8080',
  );

  final Dio dio;

  static Dio _defaultDio() => Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

  @override
  Future<void> postOrder(OrderDraft draft, {String? fcmToken}) {
    return dio.post<void>(
      '/api/orders',
      data: <String, dynamic>{
        'fcmToken': fcmToken,
        'itemCount': draft.itemCount,
        'totalEgp': draft.totalEgp,
        'items': [
          for (final line in draft.lines)
            <String, dynamic>{
              'name': line.name,
              'quantity': line.quantity,
              'unitPriceEgp': line.unitPriceEgp,
            },
        ],
      },
    );
  }
}
