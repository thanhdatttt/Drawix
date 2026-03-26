import 'package:flutter/material.dart';
import 'dart:typed_data';

enum ShapeType {
  point, line, ellipse, circle, square, rectangle,
}

abstract class Shape {
  Offset startPoint;
  Offset endPoint;

  ShapeType get type;
  Color strokeColor;
  Color? fillColor;
  double strokeWidth;

  Shape({
    required this.startPoint,
    required this.endPoint,
    required this.strokeColor,
    this.fillColor,
    required this.strokeWidth,
  });

  // draw shape
  void draw(Canvas canvas);

  // paint for stroke
  Paint get strokePaint => Paint()
    ..color = strokeColor
    ..strokeWidth = strokeWidth
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  // paint for fill
  Paint? get fillPaint => fillColor != null 
    ? (Paint()..color = fillColor!..style = PaintingStyle.fill) 
    : null;

  // convert to byte data
  ByteData serialize();
}