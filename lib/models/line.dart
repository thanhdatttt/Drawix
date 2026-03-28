import 'dart:ui';
import 'package:drawix_app/models/shape.dart';

class Line extends Shape {
  Line({
    required super.startPoint,
    required super.endPoint,
    required super.strokeColor,
    required super.strokeWidth,
  }) : super(fillColor: null);

  @override
  void draw(Canvas canvas) {
    canvas.drawLine(startPoint, endPoint, strokePaint);
  }

  @override
  ShapeType get type => ShapeType.line;
}