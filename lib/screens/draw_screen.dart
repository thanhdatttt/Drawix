import 'package:drawix_app/models/shape.dart';
import 'package:drawix_app/painters/draw_painter.dart';
import 'package:drawix_app/providers/draw_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawScreen extends StatelessWidget {
  const DrawScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // provider
    final provider = Provider.of<DrawProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Stack(
        children: [
          // canvas
          GestureDetector(
            onPanStart: (details) => provider.startDrawing(details.globalPosition),
            onPanUpdate: (details) => provider.updateDrawing(details.globalPosition),
            onPanEnd: (details) => provider.endDrawing(),
            child: CustomPaint(
              painter: DrawPainter(
                shapes: provider.shapes,
                currentShape: provider.currentShape
              ),
              child: Container(color: Colors.transparent,),
            ),
          ),

          // tool bar
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: _buildToolbar(context, provider),
          ),
          
          // slider
          Positioned(
            bottom: 30,
            right: 20,
            child: _buildStrokeControl(provider),
          ),
        ],
      ),
    );
  }

  // tool bar ui
  Widget _buildToolbar(BuildContext context, DrawProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10)],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _toolIcon(provider, ShapeType.line, Icons.horizontal_rule),
            _toolIcon(provider, ShapeType.rectangle, Icons.crop_square),
            _toolIcon(provider, ShapeType.circle, Icons.circle_outlined),
            const VerticalDivider(color: Colors.white24),
            _colorPicker(provider, Colors.teal),
            _colorPicker(provider, Colors.redAccent),
            _colorPicker(provider, Colors.amber),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.white70),
              onPressed: () => provider.clearCanvas(),
            ),
          ],
        ),
    );
  }

  // icon tool ui
  Widget _toolIcon(DrawProvider provider, ShapeType type, IconData icon) {
    bool isSelected = provider.selectedType == type;
    return IconButton(
      icon: Icon(icon, color: isSelected ? Colors.tealAccent : Colors.white70),
      onPressed: () => provider.setSelectedType(type),
    );
  }

  // color picker
  Widget _colorPicker(DrawProvider provider, Color color) {
    bool isSelected = provider.selectedColor == color;
    return GestureDetector(
      onTap: () => provider.setSelectedColor(color),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
        ),
      ),
    );
  }

  Widget _buildStrokeControl(DrawProvider provider) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const Icon(Icons.line_weight, size: 18),
          Expanded(
            child: Slider(
              value: provider.strokeWidth,
              min: 1, max: 20,
              activeColor: Colors.tealAccent,
              onChanged: (val) => provider.setStrokeWidth(val),
            ),
          ),
        ],
      ),
    );
  }
}

