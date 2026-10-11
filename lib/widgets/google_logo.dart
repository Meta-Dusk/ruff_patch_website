import 'dart:math' as math;
import 'package:flutter/material.dart';

class GoogleLogo extends StatelessWidget {
  final double size;

  const GoogleLogo({super.key, this.size = 20.0});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _GoogleLogoPainter(),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Offset center = Offset(radius, radius);
    final double strokeWidth = size.width * 0.22;
    final Rect rect = Rect.fromCircle(
      center: center,
      radius: radius - strokeWidth / 2,
    );

    final Paint bluePaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Paint greenPaint = Paint()
      ..color = const Color(0xFF34A853)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Paint yellowPaint = Paint()
      ..color = const Color(0xFFFBBC05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Paint redPaint = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Red: Top arc
    canvas.drawArc(rect, -math.pi * 0.75, math.pi * 0.5, false, redPaint);

    // Yellow: Bottom-left arc
    canvas.drawArc(rect, -math.pi * 1.25, math.pi * 0.5, false, yellowPaint);

    // Green: Bottom arc
    canvas.drawArc(rect, -math.pi * 1.75, math.pi * 0.5, false, greenPaint);

    // Blue: Right arc
    canvas.drawArc(rect, -math.pi * 0.25, math.pi * 0.35, false, bluePaint);

    // Blue horizontal crossbar
    final Paint blueBarPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;

    final Rect barRect = Rect.fromLTRB(
      radius - strokeWidth * 0.2,
      radius - strokeWidth / 2,
      size.width - strokeWidth * 0.1,
      radius + strokeWidth / 2,
    );
    canvas.drawRect(barRect, blueBarPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

