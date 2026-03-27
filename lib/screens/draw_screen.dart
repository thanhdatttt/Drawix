import 'package:drawix_app/models/shape.dart';
import 'package:drawix_app/painters/draw_painter.dart';
import 'package:drawix_app/providers/draw_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawScreen extends StatelessWidget {
  const DrawScreen({super.key});

  // color names
  String _colorName(Color color) {
    const names = {
      0xFFFFFFFF: 'White',
      0xFF009688: 'Teal',
      0xFF64FFDA: 'Teal Accent',
      0xFFFF5252: 'Red',
      0xFFFF4081: 'Pink',
      0xFFFFC107: 'Amber',
      0xFFFFAB40: 'Orange',
      0xFF40C4FF: 'Light Blue',
      0xFFE040FB: 'Purple',
      0xFF69FF47: 'Green',
      0xFFEEFF41: 'Lime',
      0xFFFF6E40: 'Deep Orange',
    };
    return names[color.toARGB32()] ?? 'Color';
  }

  static const colors = [
      Colors.white,
      Colors.teal,
      Colors.tealAccent,
      Colors.redAccent,
      Colors.pinkAccent,
      Colors.amber,
      Colors.orangeAccent,
      Colors.lightBlueAccent,
      Colors.purpleAccent,
      Colors.greenAccent,
      Colors.limeAccent,
      Colors.deepOrangeAccent,
    ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DrawProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Stack(
        children: [
          // canvas
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanStart: (details) => provider.startDrawing(details.localPosition),
              onPanUpdate: (details) => provider.updateDrawing(details.localPosition),
              onPanEnd: (details) => provider.endDrawing(),
              child: CustomPaint(
                size: Size.infinite,
                painter: DrawPainter(
                  shapes: provider.shapes,
                  currentShape: provider.currentShape,
                ),
              ),
            ),
          ),

          // tool bar
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: _buildToolbar(context, provider),
          ),

          // stroke slider
          Positioned(
            bottom: 30,
            right: 20,
            child: _buildStrokeControl(provider),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar(BuildContext context, DrawProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10)],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Shape tools
            _toolIcon(provider, ShapeType.point,     Icons.circle,                 tooltip: 'Point'),
            _toolIcon(provider, ShapeType.line,      Icons.horizontal_rule,        tooltip: 'Line'),
            _toolIcon(provider, ShapeType.rectangle, Icons.rectangle_outlined,     tooltip: 'Rectangle'),
            _toolIcon(provider, ShapeType.square,    Icons.square_outlined,        tooltip: 'Square'),
            _toolIcon(provider, ShapeType.ellipse,   Icons.panorama_fish_eye,      tooltip: 'Ellipse'),
            _toolIcon(provider, ShapeType.circle,    Icons.circle_outlined,        tooltip: 'Circle'),

            const SizedBox(width: 4),
            const VerticalDivider(color: Colors.white24, width: 16, thickness: 1),
            const SizedBox(width: 4),

            // Colors
            ...colors.map((color) => _colorPicker(provider, color)),

            const SizedBox(width: 4),
            const VerticalDivider(color: Colors.white24, width: 16, thickness: 1),
            const SizedBox(width: 4),

            // Clear
            Tooltip(
              message: 'Clear canvas',
              child: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.white70),
                onPressed: () => provider.clearCanvas(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toolIcon(DrawProvider provider, ShapeType type, IconData icon, {String tooltip = ''}) {
    final isSelected = provider.selectedType == type;
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon, color: isSelected ? Colors.tealAccent : Colors.white70),
        onPressed: () => provider.setSelectedType(type),
      ),
    );
  }

  Widget _colorPicker(DrawProvider provider, Color color) {
    final isSelected = provider.selectedColor == color;
    return Tooltip(
      message: _colorName(color),
      child: GestureDetector(
        onTap: () => provider.setSelectedColor(color),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: isSelected
                ? Border.all(color: Colors.white24, width: 4)
                : Border.all(color: Colors.white, width: 1),
          ),
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
              min: 1,
              max: 20,
              activeColor: Colors.tealAccent,
              onChanged: (val) => provider.setStrokeWidth(val),
            ),
          ),
        ],
      ),
    );
  }
}