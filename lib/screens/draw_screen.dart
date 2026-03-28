import 'package:drawix_app/models/shape.dart';
import 'package:drawix_app/painters/draw_painter.dart';
import 'package:drawix_app/providers/draw_provider.dart';
import 'package:drawix_app/utils/draw_serializer.dart';
import 'package:drawix_app/utils/Io/file_io.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const List<Color> _kPalette = [
  Colors.white,       Colors.teal,       Colors.tealAccent,
  Colors.redAccent,   Colors.pinkAccent, Colors.amber,
  Colors.orangeAccent,Colors.lightBlueAccent, Colors.purpleAccent,
  Colors.greenAccent, Colors.limeAccent, Colors.deepOrangeAccent,
];

const Map<int, String> _kColorNames = {
  0xFFFFFFFF: 'White',    0xFF009688: 'Teal',       0xFF64FFDA: 'Teal Accent',
  0xFFFF5252: 'Red',      0xFFFF4081: 'Pink',        0xFFFFC107: 'Amber',
  0xFFFFAB40: 'Orange',   0xFF40C4FF: 'Light Blue',  0xFFE040FB: 'Purple',
  0xFF69FF47: 'Green',    0xFFEEFF41: 'Lime',        0xFFFF6E40: 'Deep Orange',
};

class DrawScreen extends StatelessWidget {
  const DrawScreen({super.key});

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
              onPanStart:  (d) => provider.startDrawing(d.localPosition),
              onPanUpdate: (d) => provider.updateDrawing(d.localPosition),
              onPanEnd:    (_) => provider.endDrawing(),
              child: CustomPaint(
                size: Size.infinite,
                painter: DrawPainter(
                  shapes: provider.shapes,
                  currentShape: provider.currentShape,
                ),
              ),
            ),
          ),

          // toolbars
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: _buildToolbar(context, provider),
          ),

          // stroke width control
          Positioned(
            bottom: 30,
            right: 20,
            child: _buildStrokeControl(provider),
          ),
        ],
      ),
    );
  }

  // toolbar ui
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // shape tools
            _toolIcon(provider, ShapeType.point,     Icons.circle,                 'Point'),
            _toolIcon(provider, ShapeType.line,      Icons.horizontal_rule,        'Line'),
            _toolIcon(provider, ShapeType.rectangle, Icons.rectangle_outlined,     'Rectangle'),
            _toolIcon(provider, ShapeType.square,    Icons.square_outlined,        'Square'),
            _toolIcon(provider, ShapeType.ellipse,   Icons.panorama_fish_eye,      'Ellipse'),
            _toolIcon(provider, ShapeType.circle,    Icons.circle_outlined,        'Circle'),

            _divider(),

            // stroke colors
            _sectionLabel(Icons.edit, 'Stroke'),
            ..._kPalette.map((c) => _strokeSwatch(provider, c)),

            _divider(),

            // fill colors
            _sectionLabel(Icons.format_color_fill, 'Fill'),
            _noFillSwatch(provider),
            ..._kPalette.map((c) => _fillSwatch(provider, c)),

            _divider(),

            // file controls
            _fileButton(
              icon: Icons.save_outlined,
              tooltip: 'Save drawing (.drwx)',
              onTap: () => _save(context, provider),
            ),
            _fileButton(
              icon: Icons.folder_open_outlined,
              tooltip: 'Open drawing (.drwx)',
              onTap: () => _open(context, provider),
            ),

            _divider(),

            // clear canvas
            Tooltip(
              message: 'Clear canvas',
              child: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.white70),
                onPressed: provider.clearCanvas,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // file handler

  void _save(BuildContext context, DrawProvider provider) async {
    try {
      final bytes = DrawSerializer.encode(provider.shapes);
      final path  = await FileIo.save(bytes);
      final msg   = path != null ? 'Saved to $path' : 'Drawing saved as drawing.drwx';
      _snack(context, msg, Icons.check_circle_outline);
    } catch (e) {
      _snack(context, 'Save failed: \$e', Icons.error_outline, isError: true);
    }
  }

  void _open(BuildContext context, DrawProvider provider) async {
    try {
      final bytes = await FileIo.open();
      if (bytes == null) return; // user cancelled
      provider.loadDrawing(bytes);
      _snack(context, 'Drawing loaded (${provider.shapes.length} shapes)', Icons.check_circle_outline);
    } on FormatException catch (e) {
      _snack(context, e.message, Icons.error_outline, isError: true);
    } catch (e) {
      _snack(context, 'Open failed: $e', Icons.error_outline, isError: true);
    }
  }

  void _snack(BuildContext context, String msg, IconData icon, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(msg)),
        ]),
        backgroundColor: isError ? Colors.red[800] : const Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // helpers
  Widget _divider() => const Padding(
    padding: EdgeInsets.symmetric(horizontal: 4),
    child: VerticalDivider(color: Colors.white24, width: 16, thickness: 1),
  );

  Widget _sectionLabel(IconData icon, String label) => Tooltip(
    message: label,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Icon(icon, size: 16, color: Colors.white38),
    ),
  );

  Widget _toolIcon(DrawProvider provider, ShapeType type, IconData icon, String tooltip) {
    final isSelected = provider.selectedType == type;
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon, color: isSelected ? Colors.tealAccent : Colors.white70),
        onPressed: () => provider.setSelectedType(type),
      ),
    );
  }

  // stroke color ui
  Widget _strokeSwatch(DrawProvider provider, Color color) {
    final isSelected = provider.selectedColor == color;
    return Tooltip(
      message: _kColorNames[color.toARGB32()] ?? 'Color',
      child: GestureDetector(
        onTap: () => provider.setSelectedColor(color),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: 22, height: 22,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: isSelected
                ? Border.all(color: Colors.white, width: 2)
                : Border.all(color: Colors.white24, width: 1),
          ),
        ),
      ),
    );
  }

  // fill color ui
  Widget _fillSwatch(DrawProvider provider, Color color) {
    final isSelected = provider.selectedFillColor == color;
    return Tooltip(
      message: _kColorNames[color.toARGB32()] ?? 'Color',
      child: GestureDetector(
        onTap: () => provider.setSelectedFillColor(color),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: 22, height: 22,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
            border: isSelected
                ? Border.all(color: Colors.white, width: 2)
                : Border.all(color: Colors.white24, width: 1),
          ),
        ),
      ),
    );
  }

  // no fill color ui
  Widget _noFillSwatch(DrawProvider provider) {
    final isSelected = provider.selectedFillColor == null;
    return Tooltip(
      message: 'No fill',
      child: GestureDetector(
        onTap: () => provider.setSelectedFillColor(null),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: 22, height: 22,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: isSelected ? Colors.white : Colors.white38,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: CustomPaint(painter: _CrossPainter()),
        ),
      ),
    );
  }

  // file button ui
  Widget _fileButton({required IconData icon, required String tooltip, required VoidCallback onTap}) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon, color: Colors.white70),
        onPressed: onTap,
      ),
    );
  }

  // stroke width control ui
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
          const Icon(Icons.line_weight, size: 18, color: Colors.white70),
          Expanded(
            child: Slider(
              value: provider.strokeWidth,
              min: 1, max: 20,
              activeColor: Colors.tealAccent,
              onChanged: provider.setStrokeWidth,
            ),
          ),
        ],
      ),
    );
  }
}

// draw a red cross to indicate no fill.
class _CrossPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.redAccent
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(3, 3), Offset(size.width - 3, size.height - 3), paint);
    canvas.drawLine(Offset(size.width - 3, 3), Offset(3, size.height - 3), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}