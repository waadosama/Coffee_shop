import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Firebase options sourced from `assets/.env`.
///
/// This is the **only** place the Firebase identifiers live — `lib/
/// firebase_options.dart` (the FlutterFire-generated file with the API key,
/// app id and project id written out in Dart) has been removed so nothing is
/// hardcoded in the source tree anymore.
///
/// The values themselves are public identifiers, not secrets: they are baked
/// into every APK either way. Keeping them in an env file is about keeping
/// them in one editable place, not about hiding them.
class FirebaseEnv {
  FirebaseEnv._();

  /// Path of the env file inside the asset bundle.
  static const String fileName = 'assets/.env';

  /// Keys that all have to be non-empty before [optionsFrom] will build a
  /// config from the env map.
  static const List<String> requiredKeys = [
    'FIREBASE_API_KEY',
    'FIREBASE_APP_ID',
    'FIREBASE_MESSAGING_SENDER_ID',
    'FIREBASE_PROJECT_ID',
  ];

  /// Reads `assets/.env` into memory. A missing file is not fatal here —
  /// [options] is what reports the missing keys. Must run before
  /// `Firebase.initializeApp`.
  static Future<void> load() async {
    await dotenv.load(fileName: fileName, isOptional: true);
  }

  /// True when the env file was loaded and carries every required key.
  static bool get isLoaded =>
      dotenv.isInitialized && isEveryDefined(dotenv.env);

  /// The options to pass to `Firebase.initializeApp`, straight from
  /// `assets/.env`.
  ///
  /// Throws a [StateError] naming the missing keys instead of silently
  /// booting Firebase with half a configuration.
  static FirebaseOptions get options {
    final env = dotenv.isInitialized ? dotenv.env : const <String, String>{};
    final fromEnv = optionsFrom(env);
    if (fromEnv == null) {
      final missing = [
        for (final key in requiredKeys)
          if ((env[key] ?? '').isEmpty) key,
      ];
      throw StateError(
        'Firebase options are incomplete — missing ${missing.join(', ')} '
        'in $fileName.\n'
        'Copy $fileName.example to $fileName and fill it in with the values '
        'from the Firebase console (Project settings → General → Your apps) '
        'or from `flutterfire configure`.',
      );
    }
    debugPrint('FirebaseEnv: loaded $fileName (project ${fromEnv.projectId})');
    return fromEnv;
  }

  /// Builds [FirebaseOptions] from a parsed env map, or returns `null` when
  /// any of [requiredKeys] is missing or empty.
  @visibleForTesting
  static FirebaseOptions? optionsFrom(Map<String, String> env) {
    if (!isEveryDefined(env)) return null;

    return FirebaseOptions(
      apiKey: env['FIREBASE_API_KEY']!,
      appId: env['FIREBASE_APP_ID']!,
      messagingSenderId: env['FIREBASE_MESSAGING_SENDER_ID']!,
      projectId: env['FIREBASE_PROJECT_ID']!,
      storageBucket: env['FIREBASE_STORAGE_BUCKET'],
    );
  }

  static bool isEveryDefined(Map<String, String> env) =>
      requiredKeys.every((key) => (env[key] ?? '').isNotEmpty);
}
