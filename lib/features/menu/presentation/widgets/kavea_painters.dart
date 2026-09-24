import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';


class PouringCupsPainter extends CustomPainter {
  const PouringCupsPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final ink = Paint()
      ..color = AppColors.darkEspresso
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fill = Paint()
      ..color = AppColors.darkEspresso
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    final hand = Path()
      ..moveTo(w * 0.08, h * 0.02)
      ..quadraticBezierTo(w * 0.02, h * 0.18, w * 0.18, h * 0.22)
      ..quadraticBezierTo(w * 0.42, h * 0.18, w * 0.48, h * 0.08)
      ..quadraticBezierTo(w * 0.38, h * 0.02, w * 0.22, h * 0.04)
      ..close();
    canvas.drawPath(hand, ink);

    final stream = Path()
      ..moveTo(w * 0.46, h * 0.12)
      ..quadraticBezierTo(w * 0.52, h * 0.28, w * 0.48, h * 0.42)
      ..quadraticBezierTo(w * 0.62, h * 0.22, w * 0.58, h * 0.12)
      ..close();
    canvas.drawPath(stream, fill);

    _cup(canvas, Offset(w * 0.42, h * 0.42), w * 0.38, h * 0.22, ink, fill);
    _cup(canvas, Offset(w * 0.48, h * 0.62), w * 0.42, h * 0.24, ink, fill);
  }

  void _cup(
    Canvas canvas,
    Offset origin,
    double width,
    double height,
    Paint ink,
    Paint fill,
  ) {
    final cup = Path()
      ..moveTo(origin.dx, origin.dy)
      ..lineTo(origin.dx + width * 0.08, origin.dy + height)
      ..lineTo(origin.dx + width * 0.78, origin.dy + height)
      ..lineTo(origin.dx + width, origin.dy)
      ..close();
    canvas.drawPath(cup, ink);

    final handle = Path()
      ..moveTo(origin.dx + width * 0.92, origin.dy + height * 0.22)
      ..quadraticBezierTo(
        origin.dx + width * 1.22,
        origin.dy + height * 0.5,
        origin.dx + width * 0.86,
        origin.dy + height * 0.78,
      );
    canvas.drawPath(handle, ink);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class EspressoMachinePainter extends CustomPainter {
  const EspressoMachinePainter({this.color = AppColors.darkEspresso});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final ink = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    final body = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.18, h * 0.18, w * 0.62, h * 0.62),
      const Radius.circular(6),
    );
    canvas.drawRRect(body, ink);

    canvas.drawRect(
      Rect.fromLTWH(w * 0.22, h * 0.08, w * 0.18, h * 0.12),
      ink,
    );
    canvas.drawRect(
      Rect.fromLTWH(w * 0.58, h * 0.08, w * 0.18, h * 0.12),
      ink,
    );

    canvas.drawCircle(Offset(w * 0.32, h * 0.32), 6, ink);
    canvas.drawCircle(Offset(w * 0.44, h * 0.32), 6, ink);
    canvas.drawCircle(Offset(w * 0.56, h * 0.32), 4, ink);

    canvas.drawRect(Rect.fromLTWH(w * 0.28, h * 0.42, w * 0.18, h * 0.16), ink);
    canvas.drawRect(Rect.fromLTWH(w * 0.52, h * 0.42, w * 0.18, h * 0.16), ink);

    canvas.drawLine(
      Offset(w * 0.34, h * 0.58),
      Offset(w * 0.34, h * 0.7),
      ink,
    );
    canvas.drawLine(
      Offset(w * 0.64, h * 0.58),
      Offset(w * 0.64, h * 0.7),
      ink,
    );

    final dripTray = Path()
      ..moveTo(w * 0.14, h * 0.8)
      ..lineTo(w * 0.86, h * 0.8)
      ..lineTo(w * 0.8, h * 0.92)
      ..lineTo(w * 0.2, h * 0.92)
      ..close();
    canvas.drawPath(dripTray, ink);

    final cup = Path()
      ..moveTo(w * 0.42, h * 0.7)
      ..lineTo(w * 0.44, h * 0.8)
      ..lineTo(w * 0.56, h * 0.8)
      ..lineTo(w * 0.58, h * 0.7)
      ..close();
    canvas.drawPath(cup, ink);
  }

  @override
  bool shouldRepaint(covariant EspressoMachinePainter oldDelegate) =>
      oldDelegate.color != color;
}

class CafeDoodlesPainter extends CustomPainter {
  const CafeDoodlesPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final ink = Paint()
      ..color = AppColors.darkEspresso
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    _moka(canvas, Offset(size.width * 0.08, size.height * 0.12), 72, ink);
    _cups(canvas, Offset(size.width * 0.62, size.height * 0.08), ink);
    _pastry(canvas, Offset(size.width * 0.18, size.height * 0.58), ink);
  }

  void _moka(Canvas canvas, Offset o, double s, Paint ink) {
    final path = Path()
      ..moveTo(o.dx + s * 0.2, o.dy + s * 0.55)
      ..lineTo(o.dx + s * 0.15, o.dy + s * 0.95)
      ..lineTo(o.dx + s * 0.85, o.dy + s * 0.95)
      ..lineTo(o.dx + s * 0.8, o.dy + s * 0.55)
      ..close();
    canvas.drawPath(path, ink);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(o.dx + s * 0.28, o.dy + s * 0.18, s * 0.44, s * 0.4),
        const Radius.circular(4),
      ),
      ink,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(o.dx + s * 0.5, o.dy + s * 0.16),
        width: s * 0.22,
        height: s * 0.12,
      ),
      ink,
    );
    final handle = Path()
      ..moveTo(o.dx + s * 0.8, o.dy + s * 0.62)
      ..quadraticBezierTo(
        o.dx + s * 1.08,
        o.dy + s * 0.72,
        o.dx + s * 0.78,
        o.dy + s * 0.86,
      );
    canvas.drawPath(handle, ink);
  }

  void _cups(Canvas canvas, Offset o, Paint ink) {
    canvas.drawOval(Rect.fromLTWH(o.dx, o.dy, 54, 18), ink);
    canvas.drawOval(Rect.fromLTWH(o.dx + 8, o.dy + 16, 54, 18), ink);
    canvas.drawOval(Rect.fromLTWH(o.dx + 16, o.dy + 32, 54, 18), ink);
    canvas.drawArc(
      Rect.fromLTWH(o.dx + 62, o.dy + 34, 22, 18),
      -0.6,
      math.pi,
      false,
      ink,
    );
  }

  void _pastry(Canvas canvas, Offset o, Paint ink) {
    canvas.drawOval(Rect.fromLTWH(o.dx, o.dy, 110, 78), ink);
    canvas.drawLine(
      Offset(o.dx + 18, o.dy + 38),
      Offset(o.dx + 92, o.dy + 38),
      ink,
    );
    canvas.drawOval(Rect.fromLTWH(o.dx + 38, o.dy + 18, 34, 22), ink);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class StampBorderPainter extends CustomPainter {
  const StampBorderPainter({
    this.color = AppColors.darkEspresso,
    this.scallop = 7,
  });

  final Color color;
  final double scallop;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;

    final path = Path();
    const inset = 6.0;
    final rect = Rect.fromLTWH(
      inset,
      inset,
      size.width - inset * 2,
      size.height - inset * 2,
    );

    path.moveTo(rect.left + scallop, rect.top);
    for (double x = rect.left + scallop * 2; x < rect.right; x += scallop * 2) {
      path.arcToPoint(
        Offset(math.min(x, rect.right - scallop), rect.top),
        radius: Radius.circular(scallop),
        clockwise: false,
      );
    }
    path.lineTo(rect.right, rect.top + scallop);
    for (double y = rect.top + scallop * 2; y < rect.bottom; y += scallop * 2) {
      path.arcToPoint(
        Offset(rect.right, math.min(y, rect.bottom - scallop)),
        radius: Radius.circular(scallop),
        clockwise: false,
      );
    }
    path.lineTo(rect.right - scallop, rect.bottom);
    for (double x = rect.right - scallop * 2; x > rect.left; x -= scallop * 2) {
      path.arcToPoint(
        Offset(math.max(x, rect.left + scallop), rect.bottom),
        radius: Radius.circular(scallop),
        clockwise: false,
      );
    }
    path.lineTo(rect.left, rect.bottom - scallop);
    for (double y = rect.bottom - scallop * 2; y > rect.top; y -= scallop * 2) {
      path.arcToPoint(
        Offset(rect.left, math.max(y, rect.top + scallop)),
        radius: Radius.circular(scallop),
        clockwise: false,
      );
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant StampBorderPainter oldDelegate) =>
      oldDelegate.color != color;
}
