import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../firebase/firebase_env.dart';

/// Firebase Cloud Messaging bootstrap.
///
/// Wires Firebase up, asks the customer for notification permission, keeps
/// this device's registration token in [token] — the backend needs it to
/// target the phone — and guarantees every message becomes a system
/// notification:
///
/// * app in background or terminated → Android renders `notification`
///   payloads by itself, so nothing extra is required;
/// * app in foreground → the system stays silent, so [_onForegroundMessage]
///   posts the message through `flutter_local_notifications` instead.
class FcmService {
  FcmService._();

  /// Channel used for order updates. Created on the device during [init] and
  /// targeted by id (`order_updates`) from the backend message.
  static const AndroidNotificationChannel orderChannel =
      AndroidNotificationChannel(
    'order_updates',
    'Order updates',
    description:
        'Tells you when an order was placed and is ready to be prepared.',
    importance: Importance.high,
  );

  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static String? _token;

  /// This device's FCM registration token, or `null` until [init] finished
  /// (or `null` forever if Firebase failed to start).
  static String? get token => _token;

  /// Must be called once, before `runApp`.
  static Future<void> init() async {
    // assets/.env is the only source of Firebase options — see FirebaseEnv.
    await FirebaseEnv.load();
    await Firebase.initializeApp(options: FirebaseEnv.options);

    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);

    await _initLocalNotifications();

    final messaging = FirebaseMessaging.instance;
    final permission = await messaging.requestPermission();
    debugPrint('FCM notification permission: ${permission.authorizationStatus}');

    // getToken/onTokenRefresh are soft-deprecated in favour of the new
    // FID-based register()/onRegistered pair, but the backend sends through
    // the Admin SDK's classic `send({ token })`, which needs the FCM
    // registration token these two still return.
    // ignore: deprecated_member_use
    _token = await messaging.getToken();
    debugPrint('FCM device token: $_token');
    // ignore: deprecated_member_use
    messaging.onTokenRefresh.listen((value) => _token = value);

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
  }

  /// Entry point used by messages that arrive while the app is in a
  /// background isolate. `notification` payloads are drawn by the system, so
  /// this only has to make Firebase reachable from this isolate.
  @pragma('vm:entry-point')
  static Future<void> _onBackgroundMessage(RemoteMessage message) async {
    // A background isolate has its own dotenv state, so load it again here.
    await FirebaseEnv.load();
    await Firebase.initializeApp(options: FirebaseEnv.options);
    debugPrint('FCM background message received: ${message.messageId}');
  }

  /// Creates the order-updates channel and asks for the Android 13+
  /// notification permission the same way Firebase does.
  static Future<void> _initLocalNotifications() async {
    await _notifications.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );

    final android = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.createNotificationChannel(orderChannel);
    await android?.requestNotificationsPermission();
  }

  /// Foreground messages would otherwise be silently dropped by Android.
  static Future<void> _onForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    final title = notification?.title ?? message.data['title'] as String?;
    final body = notification?.body ?? message.data['body'] as String?;
    if (title == null && body == null) return;

    await _notifications.show(
      id: message.hashCode,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          orderChannel.id,
          orderChannel.name,
          channelDescription: orderChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }
}
