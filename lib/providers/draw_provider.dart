import 'package:drawix_app/models/shape.dart';
import 'package:flutter/material.dart';

class DrawProvider extends ChangeNotifier {
  final List<Shape> _shapes = [];
  List<Shape> get shapes => _shapes;

  Shape? _currentShape;
  Shape? get currentShape => _currentShape;

  // default toolbox
  ShapeType _selectedType = ShapeType.line;
  Color _selectedColor = Colors.black;
  Color? _selectedFillColor;
  double _strokeWidth = 2.0;

  // toolbox getters
  ShapeType get selectedType => _selectedType;
  Color get selectedColor => _selectedColor;
  double get strokeWidth => _strokeWidth;

  // toolbox setters
  set selectedType(ShapeType type) {
    _selectedType = type;
    notifyListeners();
  }
  set selectedColor(Color color) {
    _selectedColor = color;
    notifyListeners();
  }
  set strokeWidth(double width) {
    _strokeWidth = width;
    notifyListeners();
  }
}