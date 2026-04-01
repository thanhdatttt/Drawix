import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:drawix_app/models/circle.dart';
import 'package:drawix_app/models/ellipse.dart';
import 'package:drawix_app/models/line.dart';
import 'package:drawix_app/models/rectangle.dart';
import 'package:drawix_app/models/shape.dart';
import 'package:drawix_app/models/square.dart';
import 'package:drawix_app/utils/draw_serializer.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import '../models/point.dart';

class DrawProvider extends ChangeNotifier {
  final List<Shape> _shapes = [];
  List<Shape> get shapes => _shapes;

  Shape? _currentShape;
  Shape? get currentShape => _currentShape;

  String? _currentFilePath;
  String? get currentFilePath => _currentFilePath;

  // default toolbox
  ShapeType _selectedType = ShapeType.line;
  Color _selectedColor = Colors.teal;
  Color? _selectedFillColor;
  double _strokeWidth = 2.0;

  // toolbox getters
  ShapeType get selectedType => _selectedType;
  Color get selectedColor => _selectedColor;
  Color? get selectedFillColor => _selectedFillColor;
  double get strokeWidth => _strokeWidth;

  // toolbox setters
  void setSelectedType(ShapeType type) {
    _selectedType = type;
    notifyListeners();
  }
  
  void setSelectedColor(Color color) {
    _selectedColor = color;
    notifyListeners();
  }

  void setSelectedFillColor(Color? color) {
    _selectedFillColor = color;
    notifyListeners();
  }

  void setStrokeWidth(double width) {
    _strokeWidth = width;
    notifyListeners();
  }

  // draw logic
  void startDrawing(Offset startPoint) {
    _currentShape = _createShape(startPoint, startPoint);
    notifyListeners();
  }

  void updateDrawing(Offset endPoint) {
    if (_currentShape != null) {
      _currentShape!.endPoint = endPoint;
      notifyListeners();
    }
  }

  void endDrawing() {
    if (_currentShape != null) {
      _shapes.add(_currentShape!);
      _currentShape = null;
      notifyListeners();
    }
  }

  Shape? _createShape(Offset startPoint, Offset endPoint) {
    switch (_selectedType) {
      case ShapeType.point:
        return Point(startPoint: startPoint, strokeColor: _selectedColor, strokeWidth: _strokeWidth);
      case ShapeType.line:
        return Line(startPoint: startPoint, endPoint: endPoint, strokeColor: _selectedColor, strokeWidth: _strokeWidth);
      case ShapeType.square:
        return Square(startPoint: startPoint, endPoint: endPoint, strokeColor: _selectedColor, strokeWidth: _strokeWidth, fillColor: _selectedFillColor);
      case ShapeType.rectangle:
        return Rectangle(startPoint: startPoint, endPoint: endPoint, strokeColor: _selectedColor, strokeWidth: _strokeWidth, fillColor: _selectedFillColor);
      case ShapeType.ellipse:
        return Ellipse(startPoint: startPoint, endPoint: endPoint, strokeColor: _selectedColor, strokeWidth: _strokeWidth, fillColor: _selectedFillColor);
      case ShapeType.circle:
        return Circle(startPoint: startPoint, endPoint: endPoint, strokeColor: _selectedColor, strokeWidth: _strokeWidth, fillColor: _selectedFillColor);
    }
  }

  // clear canvas
  void clearCanvas() {
    _shapes.clear();
    // _currentFilePath = null;
    notifyListeners();
  }

  // set which file is current
  void setCurrentFilePath(String? path) {
    if (_currentFilePath == path) return;
    _currentFilePath = path;
    notifyListeners();
  }

  // load drawing
  void loadDrawing(Uint8List bytes, {String? filePath}) {
    final loaded = DrawSerializer.decode(bytes);
    _shapes.clear();
    _shapes.addAll(loaded);
    _currentShape = null;
    _currentFilePath = filePath;
    notifyListeners();
  }

  // export drawing to png
  Future<void> exportPNG(Size canvasSize) async {
    if (_shapes.isEmpty) return;
    
    // init picture recorder
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, canvasSize.width, canvasSize.height));

    // draw background and shapes
    final bgPaint = Paint()..color = const Color(0xFF121212);
    canvas.drawRect(Rect.fromLTWH(0, 0, canvasSize.width, canvasSize.height), bgPaint);
    for (var shape in _shapes) {
      shape.draw(canvas);
    }

    // end draw
    final picture = recorder.endRecording();
    final image = await picture.toImage(canvasSize.width.toInt(), canvasSize.height.toInt());

    // encode to byte and save png
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List? pngBytes = byteData?.buffer.asUint8List();
    if (pngBytes != null) {
      await FileSaver.instance.saveFile(
        name: 'Drawix_${DateTime.now().millisecondsSinceEpoch}',
        bytes: pngBytes,
        fileExtension: 'png',
        mimeType: MimeType.png,
      );
    }
  }
}