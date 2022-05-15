import 'package:flutter/material.dart';
import 'dart:math' as Math;

class NavCustomPainter extends CustomPainter {
  late double loc;
  late double s;
  Color color;
  TextDirection textDirection;

  NavCustomPainter(
      double startingLoc, int itemsLength, this.color, this.textDirection) {
    final span = 1.0 / itemsLength;
    s = 0.2;
    double l = startingLoc + (span - s) / 2;
    loc = textDirection == TextDirection.rtl ? 0.8 - l : l;
  }
  double degToRad(num deg) => deg * (Math.pi / 180.0);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo((loc + s * .07) * size.width, 0)
      ..lineTo((loc + s * .07) * size.width, size.height * .175)
      ..arcToPoint(
        Offset((loc + s * 0.25) * size.width, size.height * .35),
        radius: Radius.circular(15.0),
        clockwise: false,
      )
      ..lineTo((loc + s * 0.75) * size.width, size.height * .35)
      ..arcToPoint(
        Offset((loc + s - s * .07) * size.width, size.height * .175),
        radius: Radius.circular(15.0),
        clockwise: false,
      )
      ..lineTo((loc + s - s * .07) * size.width, 0.0)

      ///Another experiment
      // ..arcTo(
      //   Rect.fromLTWH(loc * size.width, 0, .5*(loc + s) * size.width, size.height),
      //   degToRad(0),
      //   degToRad(-90),
      //   false,
      // )

      /// A good way but not the best
      // ..cubicTo(
      //   (loc + s * 0.05) * size.width,
      //   size.height * 0.7,
      //   (loc + s) * size.width,
      //   size.height * 0.7,
      //   (loc + s) * size.width,
      //   0,
      // )
      // ..cubicTo(
      //   (loc + s * 0.20) * size.width,
      //   size.height * 0.05,
      //   loc * size.width,
      //   size.height * 0.60,
      //   (loc + s * 0.50) * size.width,
      //   size.height * 0.60,
      // )
      // ..cubicTo(
      //   (loc + s) * size.width,
      //   size.height * 0.60,
      //   (loc + s - s * 0.20) * size.width,
      //   size.height * 0.05,
      //   (loc + s + 0.1) * size.width,
      //   0,
      // )
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return this != oldDelegate;
  }
}
