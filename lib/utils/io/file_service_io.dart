import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:path_provider/path_provider.dart';

// used for android, ios, macos, windows, linux

Future<String> saveToPath(Uint8List bytes, String path) async {
  await File(path).writeAsBytes(bytes, flush: true);
  return path;
}

// save file
Future<String?> saveFile(Uint8List bytes, {String defaultName = 'drawing.drwx'}) async {
  final bool isDesktop = defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux;

  if (isDesktop) {
    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Save drawing',
      fileName: defaultName,
      type: FileType.custom,
      allowedExtensions: ['drwx'],
    );
    if (path == null) return null; // user cancelled
    await File(path).writeAsBytes(bytes, flush: true);
    return path;
  } else {
    // Mobile: write to Documents directory
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$defaultName');
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }
}

// open file
Future<({Uint8List bytes, String? path})?> openFile() async {
  final result = await FilePicker.platform.pickFiles(
    dialogTitle: 'Open drawing',
    type: FileType.custom,
    allowedExtensions: ['drwx'],
    withData: true,
  );
  if (result == null || result.files.isEmpty) return null;

  final picked = result.files.first;
  if (picked.path != null) {
    final bytes = await File(picked.path!).readAsBytes();
    return (bytes: bytes, path: picked.path);
  }
  // Fallback: bytes were loaded in memory.
  if (picked.bytes != null) {
    return (bytes: picked.bytes!, path: null);
  }

  return null;
}