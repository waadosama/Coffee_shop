import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Backdrop of the intro screen — a quiet rust field.
///
/// Three layers, all drawn straight from the theme palette: a soft vertical
/// wash from rust to the deepest roast, a warm pool of light behind the label
/// so the card lifts off the background, and a light vignette that keeps the
/// eye on the middle of the screen.
///
/// The composition is entirely static: it holds no animated state, so the
/// backdrop is painted once and never repaints while the page is open.
class IntroBackgroundPainter extends CustomPainter {
  const IntroBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final rect = Offset.zero & size;
    final center = Offset(size.width / 2, size.height * 0.44);

    _paintField(canvas, rect);
    _paintGlow(canvas, rect, center, size);
    _paintVignette(canvas, rect);
  }

  /// Rust wash fading to the deepest roast toward the bottom — the same
  /// rust-and-espresso ramp the rest of the app is built on.
  void _paintField(Canvas canvas, Rect rect) {
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.darkEspresso,
          AppColors.leatherSoft,
          AppColors.darkInk,
        ],
        stops: [0.0, 0.5, 1.0],
      ).createShader(rect);
    canvas.drawRect(rect, paint);
  }

  /// Soft, warm pool of light sitting behind the label so the card lifts off
  /// the background without any glow animation.
  void _paintGlow(Canvas canvas, Rect rect, Offset center, Size size) {
    final reach = math.max(size.width, size.height) * 0.7;
    final shader =
        RadialGradient(
          radius: 1,
          colors: [
            AppColors.pastelPink.withValues(alpha: 0.12),
            AppColors.pastelPink.withValues(alpha: 0.0),
          ],
          stops: const [0.0, 1.0],
        ).createShader(
          Rect.fromCenter(center: center, width: reach * 2, height: reach * 2),
        );
    canvas.drawRect(rect, Paint()..shader = shader);
  }

  /// Very light darkening toward the edges — enough to frame the label, not
  /// enough to read as a poster border.
  void _paintVignette(Canvas canvas, Rect rect) {
    final paint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 0.85,
        colors: [Colors.transparent, AppColors.darkInk.withValues(alpha: 0.28)],
        stops: const [0.5, 1.0],
      ).createShader(rect);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant IntroBackgroundPainter oldDelegate) => false;
}

/// Dashed hairline drawn a few pixels inside the paper label, the way a
/// coffee sack prints its frame.
class IntroLabelFramePainter extends CustomPainter {
  IntroLabelFramePainter({
    this.color = AppColors.darkEspresso,
    this.inset = 10,
    this.radius = 18,
    this.bottomRadius,
    this.strokeWidth = 1.1,
    this.dash = 5,
    this.gap = 4,
  });

  final Color color;
  final double inset;
  final double radius;

  /// Corner radius for the bottom edge; defaults to [radius] so a plain
  /// rounded rect needs no second value.
  final double? bottomRadius;
  final double strokeWidth;
  final double dash;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      inset,
      inset,
      size.width - inset * 2,
      size.height - inset * 2,
    );
    if (rect.width <= 0 || rect.height <= 0) return;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          rect,
          topLeft: Radius.circular(radius),
          topRight: Radius.circular(radius),
          bottomLeft: Radius.circular(bottomRadius ?? radius),
          bottomRight: Radius.circular(bottomRadius ?? radius),
        ),
      );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = color;

    // Walk the rounded rect and stroke short segments, skipping the gaps.
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final end = math.min(distance + dash, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance = end + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant IntroLabelFramePainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.inset != inset ||
      oldDelegate.radius != radius ||
      oldDelegate.bottomRadius != bottomRadius ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.dash != dash ||
      oldDelegate.gap != gap;
}

/// Wax-seal badge pinned to the top of the label: a gold disc, a ring of
/// perforation dots that turns slowly and two arcs of stamp copy curving
/// around a coffee icon.
class IntroSealPainter extends CustomPainter {
  IntroSealPainter({
    required this.progress,
    required this.topText,
    required this.bottomText,
    required this.textStyle,
    this.discColor = AppColors.pastelPink,
    this.inkColor = AppColors.darkEspresso,
  });

  /// Position along the rotating dot ring, 0..1.
  final double progress;
  final String topText;
  final String bottomText;
  final TextStyle textStyle;
  final Color discColor;
  final Color inkColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;

    // Disc + rim.
    canvas.drawCircle(center, radius - 1, Paint()..color = discColor);
    canvas.drawCircle(
      center,
      radius - 3.5,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.3
        ..color = inkColor.withValues(alpha: 0.45),
    );

    // Perforation dots — the only part of the seal that spins.
    final dotRadius = radius - 9;
    const dots = 30;
    final dotPaint = Paint()..color = inkColor.withValues(alpha: 0.55);
    for (var i = 0; i < dots; i++) {
      final angle = progress * math.pi * 2 + i * (math.pi * 2 / dots);
      canvas.drawCircle(
        Offset(
          center.dx + dotRadius * math.cos(angle),
          center.dy + dotRadius * math.sin(angle),
        ),
        1.1,
        dotPaint,
      );
    }

    // Hairline around the icon.
    canvas.drawCircle(
      center,
      radius * 0.46,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.1
        ..color = inkColor.withValues(alpha: 0.35),
    );

    final textRadius = radius - 16;
    _drawArcText(canvas, topText, center, textRadius, bottom: false);
    _drawArcText(canvas, bottomText, center, textRadius, bottom: true);
  }

  /// Lays [text] out glyph by glyph and places each one on the circle so the
  /// string curves along the rim — upright on top, right way up on the bottom.
  void _drawArcText(
    Canvas canvas,
    String text,
    Offset center,
    double radius, {
    required bool bottom,
  }) {
    final glyphs = <_SealGlyph>[];
    var total = 0.0;

    for (final char in text.split('')) {
      final painter = TextPainter(
        text: TextSpan(text: char, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      final angle = painter.width / radius;
      glyphs.add(_SealGlyph(painter, angle));
      total += angle;
    }

    if (bottom) {
      // Walk backwards from the left of the 6 o'clock position so the line
      // still reads left to right once the glyphs are flipped upright.
      var cursor = math.pi + total / 2;
      for (final glyph in glyphs) {
        cursor -= glyph.angle;
        final theta = cursor + glyph.angle / 2;
        _paintGlyph(
          canvas,
          glyph.painter,
          center,
          radius,
          theta,
          theta - math.pi,
        );
      }
    } else {
      var cursor = -total / 2;
      for (final glyph in glyphs) {
        final theta = cursor + glyph.angle / 2;
        _paintGlyph(canvas, glyph.painter, center, radius, theta, theta);
        cursor += glyph.angle;
      }
    }
  }

  void _paintGlyph(
    Canvas canvas,
    TextPainter painter,
    Offset center,
    double radius,
    double theta,
    double rotation,
  ) {
    final position = Offset(
      center.dx + radius * math.sin(theta),
      center.dy - radius * math.cos(theta),
    );
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(rotation);
    painter.paint(canvas, Offset(-painter.width / 2, -painter.height / 2));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant IntroSealPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.topText != topText ||
      oldDelegate.bottomText != bottomText ||
      oldDelegate.textStyle != textStyle;
}

/// One measured character of the seal copy.
class _SealGlyph {
  const _SealGlyph(this.painter, this.angle);

  final TextPainter painter;

  /// Sweep the glyph covers on the circle, in radians.
  final double angle;
}
