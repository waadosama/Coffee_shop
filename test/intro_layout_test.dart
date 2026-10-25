import 'package:coffee_shop_app/features/menu/presentation/pages/intro_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// The intro screen must never overflow and its two calls-to-action must
/// always stay fully on screen, from small phones up to tablets.
void main() {
  const viewports = <String, Size>{
    'small phone 320x480': Size(320, 480),
    'short phone 360x640': Size(360, 640),
    'iphone 390x844': Size(390, 844),
    'large phone 414x896': Size(414, 896),
    'landscape 844x390': Size(844, 390),
    'tablet 768x1024': Size(768, 1024),
  };

  for (final entry in viewports.entries) {
    testWidgets('fits on ${entry.key}', (tester) async {
      tester.view.physicalSize = entry.value;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(const MaterialApp(home: IntroPage()));
      await tester.pump(const Duration(milliseconds: 2000));

      expect(
        tester.takeException(),
        isNull,
        reason: 'layout exception on ${entry.key}',
      );

      // Both action buttons must remain fully inside the viewport.
      final buttons = tester.getRect(find.text('المنيو'));
      expect(buttons.top, greaterThanOrEqualTo(0));
      expect(buttons.bottom, lessThanOrEqualTo(entry.value.height));

      final story = tester.getRect(find.text('Our Story'));
      expect(story.top, greaterThanOrEqualTo(0));
      expect(story.bottom, lessThanOrEqualTo(entry.value.height));
    });
  }
}
