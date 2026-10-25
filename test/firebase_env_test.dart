import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coffee_shop_app/core/firebase/firebase_env.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('optionsFrom builds FirebaseOptions from a complete env map', () {
    final options = FirebaseEnv.optionsFrom(const {
      'FIREBASE_API_KEY': 'key-123',
      'FIREBASE_APP_ID': '1:42:android:abc',
      'FIREBASE_MESSAGING_SENDER_ID': '42',
      'FIREBASE_PROJECT_ID': 'coffee-shop-roknn',
      'FIREBASE_STORAGE_BUCKET': 'coffee-shop-roknn.firebasestorage.app',
    });

    expect(options, isNotNull);
    expect(options!.apiKey, 'key-123');
    expect(options.appId, '1:42:android:abc');
    expect(options.messagingSenderId, '42');
    expect(options.projectId, 'coffee-shop-roknn');
    expect(options.storageBucket, 'coffee-shop-roknn.firebasestorage.app');
  });

  test('optionsFrom rejects a map with a missing or empty key', () {
    expect(
      FirebaseEnv.optionsFrom(const {
        'FIREBASE_API_KEY': 'key-123',
        'FIREBASE_APP_ID': '1:42:android:abc',
        'FIREBASE_MESSAGING_SENDER_ID': '42',
        // projectId deliberately missing
        'FIREBASE_STORAGE_BUCKET': 'bucket',
      }),
      isNull,
    );

    expect(
      FirebaseEnv.optionsFrom(const {
        'FIREBASE_API_KEY': '',
        'FIREBASE_APP_ID': '1:42:android:abc',
        'FIREBASE_MESSAGING_SENDER_ID': '42',
        'FIREBASE_PROJECT_ID': 'coffee-shop-roknn',
      }),
      isNull,
    );
  });

  test('options names every missing key instead of booting half-configured',
      () {
    dotenv.clean(); // simulate a fresh process that never called load()

    expect(FirebaseEnv.isLoaded, isFalse);
    expect(
      () => FirebaseEnv.options,
      throwsA(
        isA<StateError>().having(
          (error) => error.message,
          'message',
          allOf(
            contains('assets/.env'),
            contains('FIREBASE_API_KEY'),
            contains('FIREBASE_PROJECT_ID'),
            contains('Copy assets/.env.example'),
          ),
        ),
      ),
    );
  });

  test('options prefers the env map once it has been loaded', () {
    dotenv.loadFromString(
      envString: '''
FIREBASE_API_KEY=env-key
FIREBASE_APP_ID=1:9:android:env-app
FIREBASE_MESSAGING_SENDER_ID=9
FIREBASE_PROJECT_ID=env-project
''',
    );

    expect(FirebaseEnv.isLoaded, isTrue);
    expect(FirebaseEnv.options.apiKey, 'env-key');
    expect(FirebaseEnv.options.projectId, 'env-project');

    dotenv.clean();
  });
}
