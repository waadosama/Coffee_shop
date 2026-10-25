import '../../domain/entities/order_draft.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote.dart';

class OrderRepositoryImpl implements OrderRepository {
  OrderRepositoryImpl(this._remote);

  final OrderRemoteDataSource _remote;

  @override
  Future<void> placeOrder(OrderDraft draft, {String? fcmToken}) {
    return _remote.postOrder(draft, fcmToken: fcmToken);
  }
}
