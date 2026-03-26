import 'dart:typed_data';
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
  ByteData serialize() {
    return ByteData(0);
  }

  @override
  ShapeType get type => ShapeType.line;
}