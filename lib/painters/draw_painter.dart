import 'package:drawix_app/models/shape.dart';
import 'package:flutter/material.dart';

class DrawPainter extends CustomPainter {
  final List<Shape> shapes;
  Shape? currentShape;

  DrawPainter({
    required this.shapes,
    this.currentShape,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    // draw previous shapes
    for (var shape in shapes) {
      shape.draw(canvas);
    }

    // draw current shape (if any)
    if (currentShape != null) {
      currentShape!.draw(canvas);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // repaint when shapes change
    return true;
  }

  
}