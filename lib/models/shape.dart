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

  // shape record size
  static const int recordSize = 50;

  // serialize data
  ByteData serialize() {
    final bd = ByteData(recordSize);
    int o = 0;

    // serialize data
    bd.setUint8(o, type.index);                              o += 1;
    bd.setFloat64(o, startPoint.dx,  Endian.little);         o += 8;
    bd.setFloat64(o, startPoint.dy,  Endian.little);         o += 8;
    bd.setFloat64(o, endPoint.dx,    Endian.little);         o += 8;
    bd.setFloat64(o, endPoint.dy,    Endian.little);         o += 8;
    bd.setUint32(o,  strokeColor.toARGB32(), Endian.little); o += 4;
    bd.setFloat64(o, strokeWidth,    Endian.little);         o += 8;
    bd.setUint8(o,   fillColor != null ? 1 : 0);             o += 1;
    bd.setUint32(o,  fillColor?.toARGB32() ?? 0, Endian.little);

    return bd;
  } 
}