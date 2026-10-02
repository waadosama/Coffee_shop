import 'package:coffee_shop_app/features/menu/presentation/pages/intro_page.dart';
import 'package:coffee_shop_app/features/menu/presentation/widgets/intro_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpIntro(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(const MaterialApp(home: IntroPage()));
  await tester.pump(const Duration(milliseconds: 2000));
}

void main() {
  testWidgets('layout metrics', (tester) async {
    await _pumpIntro(tester, const Size(390, 844));

    final hero = tester.getRect(find.byType(IntroHeroSection));
    final brand = tester.getRect(find.byType(IntroBrandSection));
    final buttons = tester.getRect(find.byType(IntroNavigationButtons));
    debugPrint('HERO   $hero');
    debugPrint('BRAND  $brand');
    debugPrint('BUTTON $buttons');

    final fitted = find.byType(FittedBox);
    if (fitted.evaluate().isNotEmpty) {
      final fr = tester.getRect(fitted);
      debugPrint('FITTED $fr');
    }

    for (final e in find.byType(Text).evaluate()) {
      final r = tester.getRect(find.byWidget(e.widget));
      final txt = (e.widget as Text).data ?? '';
      debugPrint(
        'TEXT "${txt.substring(0, txt.length > 24 ? 24 : txt.length)}" -> $r',
      );
    }

    expect(tester.takeException(), isNull);
  });

  // Every viewport must render without overflow / layout exceptions.
  const viewports = <String, Size>{
    'small phone 320x480': Size(320, 480),
    'short phone 360x640': Size(360, 640),
    'iphone 390x844': Size(390, 844),
    'large phone 414x896': Size(414, 896),
    'landscape 844x390': Size(844, 390),
    'tablet 768x1024': Size(768, 1024),
  };

  for (final entry in viewports.entries) {
    testWidgets('no overflow on ${entry.key}', (tester) async {
      await _pumpIntro(tester, entry.value);

      expect(
        tester.takeException(),
        isNull,
        reason: 'layout exception on ${entry.key}',
      );

      // The two action buttons must remain fully on screen.
      final buttons = tester.getRect(find.byType(IntroNavigationButtons));
      expect(buttons.bottom, lessThanOrEqualTo(entry.value.height + 0.5));
      expect(buttons.top, greaterThanOrEqualTo(0));
    });
  }
}
