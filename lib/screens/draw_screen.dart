import 'package:drawix_app/models/shape.dart';
import 'package:drawix_app/painters/draw_painter.dart';
import 'package:drawix_app/providers/draw_provider.dart';
import 'package:drawix_app/utils/draw_serializer.dart';
import 'package:drawix_app/utils/io/file_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const List<Color> _kPalette = [
  Colors.white,        Colors.teal,           Colors.tealAccent,
  Colors.redAccent,    Colors.pinkAccent,     Colors.amber,
  Colors.orangeAccent, Colors.lightBlueAccent, Colors.purpleAccent,
  Colors.greenAccent,  Colors.limeAccent,     Colors.deepOrangeAccent,
];

const Map<int, String> _kColorNames = {
  0xFFFFFFFF: 'White',    0xFF009688: 'Teal',      0xFF64FFDA: 'Teal Accent',
  0xFFFF5252: 'Red',      0xFFFF4081: 'Pink',       0xFFFFC107: 'Amber',
  0xFFFFAB40: 'Orange',   0xFF40C4FF: 'Light Blue', 0xFFE040FB: 'Purple',
  0xFF69FF47: 'Green',    0xFFEEFF41: 'Lime',       0xFFFF6E40: 'Deep Orange',
};

class DrawScreen extends StatelessWidget {
  const DrawScreen({super.key});

  // save and open file handler
  Future<void> _save(BuildContext context, DrawProvider provider) async {
    if (provider.shapes.isEmpty) {
      _snack(context, 'Nothing to save — canvas is empty.');
      return;
    }

    try {
      final bytes = DrawSerializer.encode(provider.shapes);

      if (provider.currentFilePath != null) {
        // overwrite the file that is currently open
        await FileService.saveToPath(bytes, provider.currentFilePath!);
        if (!context.mounted) return;
        _snack(context, 'Saved.');
      } else {
        // no file open yet, save new file
        final path = await FileService.saveAs(bytes, defaultName: 'drawing.drwx');
        if (!context.mounted) return;
        if (path != null) {
          provider.setCurrentFilePath(path);
          _snack(context, 'Saved → $path');
        } else {
          // web: download was triggered, or user cancelled on desktop.
          _snack(context, 'Download started.');
        }
      }
    } catch (e) {
      if (context.mounted) _snack(context, 'Save failed: $e', error: true);
    }
  }

  Future<void> _open(BuildContext context, DrawProvider provider) async {
    try {
      final result = await FileService.open();
      if (result == null) return; // user cancelled

      // Pass the path so the provider remembers it for subsequent saves.
      provider.loadDrawing(result.bytes, filePath: result.path);

      if (!context.mounted) return;
      _snack(context, 'Drawing loaded.');
    } on FormatException catch (e) {
      if (context.mounted) _snack(context, 'Invalid file: ${e.message}', error: true);
    } catch (e) {
      if (context.mounted) _snack(context, 'Open failed: $e', error: true);
    }
  }

  Future<void> _exportPNG(BuildContext context,DrawProvider provider) async {
    final size = MediaQuery.of(context).size; 
    provider.exportPNG(size);
  }

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

          // toolbar
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: _buildToolbar(context, provider),
          ),

          // stroke width slider
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
            _toolIcon(provider, ShapeType.point,     Icons.circle,            'Point'),
            _toolIcon(provider, ShapeType.line,      Icons.horizontal_rule,   'Line'),
            _toolIcon(provider, ShapeType.rectangle, Icons.rectangle_outlined, 'Rectangle'),
            _toolIcon(provider, ShapeType.square,    Icons.square_outlined,   'Square'),
            _toolIcon(provider, ShapeType.ellipse,   Icons.panorama_fish_eye,  'Ellipse'),
            _toolIcon(provider, ShapeType.circle,    Icons.circle_outlined,   'Circle'),

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

            // file buttons
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

            // export png
            Tooltip(
              message: "Export to PNG",
              child: IconButton(
                icon: const Icon(Icons.image, color: Colors.white70),
                onPressed: () => _exportPNG(context, provider),
              ),
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

  // helpers
  void _snack(BuildContext context, String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error ? Colors.redAccent : Colors.lightGreenAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

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


  // buttons ui
  Widget _toolIcon(DrawProvider p, ShapeType type, IconData icon, String tip) {
    final isSelected = p.selectedType == type;
    return Tooltip(
      message: tip,
      child: IconButton(
        icon: Icon(icon, color: isSelected ? Colors.tealAccent : Colors.white70),
        onPressed: () => p.setSelectedType(type),
      ),
    );
  }

  Widget _strokeSwatch(DrawProvider p, Color color) {
    final isSelected = p.selectedColor == color;
    return Tooltip(
      message: _kColorNames[color.toARGB32()] ?? 'Color',
      child: GestureDetector(
        onTap: () => p.setSelectedColor(color),
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

  Widget _fillSwatch(DrawProvider p, Color color) {
    final isSelected = p.selectedFillColor == color;
    return Tooltip(
      message: _kColorNames[color.toARGB32()] ?? 'Color',
      child: GestureDetector(
        onTap: () => p.setSelectedFillColor(color),
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

  Widget _noFillSwatch(DrawProvider p) {
    final isSelected = p.selectedFillColor == null;
    return Tooltip(
      message: 'No fill',
      child: GestureDetector(
        onTap: () => p.setSelectedFillColor(null),
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

  Widget _fileButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon, color: Colors.white70),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildStrokeControl(DrawProvider p) {
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
              value: p.strokeWidth,
              min: 1, max: 20,
              activeColor: Colors.tealAccent,
              onChanged: p.setStrokeWidth,
            ),
          ),
        ],
      ),
    );
  }
}

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