import '../entities/order_draft.dart';

/// Places the just-checked-out order at the backend.
///
/// The backend is the trusted party that holds the FCM server key, so this is
/// what turns "checkout tapped" into the *Your order is ready to be
/// prepared* push notification on the customer's device.
abstract class OrderRepository {
  /// Sends [draft] to the backend, along with the device's FCM [fcmToken]
  /// so the notification can be routed back to this phone.
  Future<void> placeOrder(OrderDraft draft, {String? fcmToken});
}
