import 'package:coffee_shop_app/features/menu/presentation/pages/intro_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  testWidgets('capture intro screen', (tester) async {
    // Swallow google_fonts runtime-fetch failures (no network in tests).
    final previousOnError = FlutterError.onError;
    FlutterError.onError = (_) {};
    addTearDown(() => FlutterError.onError = previousOnError);

    GoogleFonts.config.allowRuntimeFetching = false;

    tester.view.physicalSize = const Size(390 * 3, 844 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: IntroPage()));

    // Mid entrance (staggered reveal in progress).
    await tester.pump(const Duration(milliseconds: 700));
    await expectLater(
      find.byType(IntroPage),
      matchesGoldenFile('goldens/intro_mid.png'),
    );

    // Settled state.
    await tester.pump(const Duration(milliseconds: 1200));
    await expectLater(
      find.byType(IntroPage),
      matchesGoldenFile('goldens/intro_done.png'),
    );
  });
}
