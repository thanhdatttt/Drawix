import 'dart:ui';
import 'package:drawix_app/models/shape.dart';

class Ellipse extends Shape {
  Ellipse({
    required super.startPoint,
    required super.endPoint,
    required super.strokeColor,
    required super.strokeWidth,
    super.fillColor,
  });

  @override
  void draw(Canvas canvas) {
    final rect = Rect.fromPoints(startPoint, endPoint);
    if (fillPaint != null) {
      canvas.drawOval(rect, fillPaint!);
    }
    canvas.drawOval(rect, strokePaint);
  }

  @override
  ShapeType get type => ShapeType.ellipse;
}