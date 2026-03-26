import 'dart:typed_data';
import 'dart:ui';
import 'package:drawix_app/models/shape.dart';

class Square extends Shape {
  Square({
    required super.startPoint,
    required super.endPoint,
    required super.strokeColor,
    required super.strokeWidth,
    super.fillColor,
  });


  @override
  void draw(Canvas canvas) {
    double width = (endPoint.dx - startPoint.dx).abs();
    double height = (endPoint.dy - startPoint.dy).abs();
    double side = width < height ? width : height;

    final rect = Rect.fromLTWH(
      startPoint.dx, 
      startPoint.dy, 
      (endPoint.dx > startPoint.dx ? 1 : -1) * side, 
      (endPoint.dy > startPoint.dy ? 1 : -1) * side
    );

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
  ShapeType get type => ShapeType.square;
}