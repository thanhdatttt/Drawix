import 'dart:typed_data';
import 'dart:ui';
import 'package:drawix_app/models/shape.dart';

class Rectangle extends Shape {
  Rectangle({
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
      canvas.drawRect(rect, fillPaint!);
    }
    canvas.drawRect(rect, strokePaint);
  }

  @override
  ByteData serialize() {
    return ByteData(0);
  }

  @override
  ShapeType get type => ShapeType.rectangle;
}