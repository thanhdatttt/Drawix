import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:drawix_app/models/shape.dart';

class Point extends Shape {
  Point({
    required super.startPoint,
    required super.strokeColor,
    required super.strokeWidth,
  }) : super(endPoint: startPoint, fillColor: null);

  @override
  void draw(Canvas canvas) {
    canvas.drawPoints(ui.PointMode.points, [startPoint], strokePaint);
  }

  @override
  ByteData serialize() {
    return ByteData(0);
  }

  @override
  ShapeType get type => ShapeType.point;
}