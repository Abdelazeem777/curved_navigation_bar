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
    final isTablet = size.width > 600;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);

    //Draw curve
    final curveStartXPoint = (loc + s * .12) * size.width + (isTablet ? 30 : 0);
    path.lineTo(curveStartXPoint, 0);
    path.lineTo(curveStartXPoint, size.height * .2);
    path.arcToPoint(
      Offset(curveStartXPoint + 15, size.height * .4),
      radius: Radius.circular(15.0),
      clockwise: false,
    );

    final curveEndXPoint =
        (loc + s - s * .12) * size.width - (isTablet ? 30 : 0);
    path.lineTo(curveEndXPoint - 15, size.height * .4);
    path.arcToPoint(
      Offset(curveEndXPoint, size.height * .2),
      radius: Radius.circular(15.0),
      clockwise: false,
    );
    path.lineTo(curveEndXPoint, 0.0);

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return this != oldDelegate;
  }
}
