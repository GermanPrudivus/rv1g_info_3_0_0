import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/theme_colors.dart';

class ScannerBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = blue // Corner lines color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.h;

    // Calculate the rectangle's position in the middle
    final rectWidth = size.width;
    final rectHeight = size.height;
    final rectLeft = (size.width - rectWidth) / 2;
    final rectTop = (size.height - rectHeight) / 2;

    // Draw four corner lines
    final cornerLineLength = 55.h;

    // Top left corner
    canvas.drawLine(
      Offset(rectLeft, rectTop),
      Offset(rectLeft + cornerLineLength, rectTop),
      paint,
    );
    canvas.drawLine(
      Offset(rectLeft, rectTop),
      Offset(rectLeft, rectTop + cornerLineLength),
      paint,
    );

    // Top right corner
    canvas.drawLine(
      Offset(rectLeft + rectWidth, rectTop),
      Offset(rectLeft + rectWidth - cornerLineLength, rectTop),
      paint,
    );
    canvas.drawLine(
      Offset(rectLeft + rectWidth, rectTop),
      Offset(rectLeft + rectWidth, rectTop + cornerLineLength),
      paint,
    );

    // Bottom left corner
    canvas.drawLine(
      Offset(rectLeft, rectTop + rectHeight),
      Offset(rectLeft + cornerLineLength, rectTop + rectHeight),
      paint,
    );
    canvas.drawLine(
      Offset(rectLeft, rectTop + rectHeight),
      Offset(rectLeft, rectTop + rectHeight - cornerLineLength),
      paint,
    );

    // Bottom right corner
    canvas.drawLine(
      Offset(rectLeft + rectWidth, rectTop + rectHeight),
      Offset(rectLeft + rectWidth - cornerLineLength, rectTop + rectHeight),
      paint,
    );
    canvas.drawLine(
      Offset(rectLeft + rectWidth, rectTop + rectHeight),
      Offset(rectLeft + rectWidth, rectTop + rectHeight - cornerLineLength),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}