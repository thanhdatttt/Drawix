import 'dart:typed_data';
import 'package:drawix_app/models/circle.dart';
import 'package:drawix_app/models/ellipse.dart';
import 'package:drawix_app/models/line.dart';
import 'package:drawix_app/models/point.dart';
import 'package:drawix_app/models/rectangle.dart';
import 'package:drawix_app/models/shape.dart';
import 'package:drawix_app/models/square.dart';
import 'package:flutter/material.dart';

// encode to .drwx file and decode from .drwx file

class DrawSerializer {
  static const List<int> _magic = [0x44, 0x52, 0x57, 0x58]; // "D R W X"
  static const int _version = 2;
  static const int _headerSize = 9; 

  static Shape _decodeShape(ByteData bd, int offset) {
    int o = offset;

    // shape data
    final typeIndex = bd.getUint8(o);                          o += 1;
    final sx        = bd.getFloat64(o, Endian.little);         o += 8;
    final sy        = bd.getFloat64(o, Endian.little);         o += 8;
    final ex        = bd.getFloat64(o, Endian.little);         o += 8;
    final ey        = bd.getFloat64(o, Endian.little);         o += 8;
    final strokeInt = bd.getUint32(o, Endian.little);          o += 4;
    final sw        = bd.getFloat64(o, Endian.little);         o += 8;
    final hasFill   = bd.getUint8(o) == 1;                     o += 1;
    final fillInt   = bd.getUint32(o, Endian.little);

    final start  = Offset(sx, sy);
    final end    = Offset(ex, ey);
    final stroke = Color(strokeInt);
    final fill   = hasFill ? Color(fillInt) : null;

    switch (ShapeType.values[typeIndex]) {
      case ShapeType.point:
        return Point(
          startPoint: start,
          strokeColor: stroke,
          strokeWidth: sw,
        );
      case ShapeType.line:
        return Line(
          startPoint: start,
          endPoint: end,
          strokeColor: stroke,
          strokeWidth: sw,
        );
      case ShapeType.rectangle:
        return Rectangle(
          startPoint: start,
          endPoint: end,
          strokeColor: stroke,
          strokeWidth: sw,
          fillColor: fill,
        );
      case ShapeType.square:
        return Square(
          startPoint: start,
          endPoint: end,
          strokeColor: stroke,
          strokeWidth: sw,
          fillColor: fill,
        );
      case ShapeType.ellipse:
        return Ellipse(
          startPoint: start,
          endPoint: end,
          strokeColor: stroke,
          strokeWidth: sw,
          fillColor: fill,
        );
      case ShapeType.circle:
        return Circle(
          startPoint: start,
          endPoint: end,
          strokeColor: stroke,
          strokeWidth: sw,
          fillColor: fill,
        );
    }
  }

  // encode
  static Uint8List encode(List<Shape> shapes) {
    final total = _headerSize + shapes.length * Shape.recordSize;
    final buf = ByteData(total);
    int o = 0;

    // magic
    for (final b in _magic) { 
      buf.setUint8(o++, b); 
    }
    // version
    buf.setUint8(o++, _version);
    // shape count
    buf.setUint32(o, shapes.length, Endian.little); o += 4;

    // shapes
    for (final shape in shapes) {
      final record = shape.serialize();
      for (int i = 0; i < Shape.recordSize; i++) {
        buf.setUint8(o++, record.getUint8(i));
      }
    }

    return buf.buffer.asUint8List();
  }

  // decode
  static List<Shape> decode(Uint8List bytes) {
    if (bytes.length < _headerSize) {
      throw const FormatException('File is too small to be a valid .drwx file.');
    }

    // validate magic
    for (int i = 0; i < _magic.length; i++) {
      if (bytes[i] != _magic[i]) {
        throw const FormatException('Not a Drawix file (invalid magic bytes).');
      }
    }

    final bd = ByteData.sublistView(bytes);

    // validate version
    final version = bd.getUint8(4);
    if (version != _version) {
      throw FormatException('Unsupported file version $version.');
    }

    // validate size
    final count = bd.getUint32(5, Endian.little);
    final expectedSize = _headerSize + count * Shape.recordSize;
    if (bytes.length < expectedSize) {
      throw FormatException(
          'File is truncated: expected $expectedSize bytes, got ${bytes.length}.');
    }

    final shapes = <Shape>[];
    for (int i = 0; i < count; i++) {
      shapes.add(_decodeShape(bd, _headerSize + i * Shape.recordSize));
    }
    return shapes;
  }
}