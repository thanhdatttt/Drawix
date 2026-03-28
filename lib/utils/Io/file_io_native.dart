import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

// save file
Future<String?> saveFile(Uint8List bytes, {String filename = 'drawing.drwx'}) async {
  if (Platform.isAndroid || Platform.isIOS) {
    return _saveMobile(bytes, filename);
  } else {
    return _saveDesktop(bytes, filename);
  }
}

// save for mobile
Future<String?> _saveMobile(Uint8List bytes, String filename) async {
  Directory dir;
  if (Platform.isAndroid) {
    // android: save into downloads (document if not have)
    final dirs = await getExternalStorageDirectories(
      type: StorageDirectory.downloads,
    );
    dir = dirs?.first ?? await getApplicationDocumentsDirectory();
  } else {
    // ios: save into documents
    dir = await getApplicationDocumentsDirectory();
  }

  final file = File('${dir.path}/$filename');
  await file.writeAsBytes(bytes, flush: true);
  return file.path;
}

// save for desktop
Future<String?> _saveDesktop(Uint8List bytes, String filename) async {
  final path = await FilePicker.platform.saveFile(
    dialogTitle: 'Save Drawix drawing',
    fileName:    filename,
    type:        FileType.custom,
    allowedExtensions: ['drwx'],
  );
  if (path == null) return null; // cancel

  final dest = path.endsWith('.drwx') ? path : '$path.drwx';
  await File(dest).writeAsBytes(bytes, flush: true);
  return dest;
}

// open file
Future<Uint8List?> openFile() async {
  final result = await FilePicker.platform.pickFiles(
    dialogTitle:       'Open Drawix drawing',
    type:              FileType.custom,
    allowedExtensions: ['drwx'],
    withData:          true,  // read bytes directly
  );
  if (result == null || result.files.isEmpty) return null;

  final picked = result.files.first;
  // fallback for mobile: read from the returned bytes
  if (picked.bytes != null) return picked.bytes!;
  // fallback for desktop: read from the returned path
  if (picked.path != null) return File(picked.path!).readAsBytes();

  return null;
}