import 'dart:typed_data';
import 'file_service_io.dart'
    if (dart.library.html) 'file_service_web.dart'
    as platform;

// saving and opening .drwx files.
class FileService {
  // save to old file
  static Future<String> saveToPath(Uint8List bytes, String path) {
    return platform.saveToPath(bytes, path);
  }

  // save to new file
  static Future<String?> saveAs(Uint8List bytes,
      {String defaultName = 'drawing.drwx'}) {
    return platform.saveFile(bytes, defaultName: defaultName);
  }

  // open file
  static Future<({Uint8List bytes, String? path})?> open() {
    return platform.openFile();
  }
}