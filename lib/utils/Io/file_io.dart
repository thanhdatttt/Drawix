import 'dart:typed_data';
import 'package:drawix_app/utils/Io/file_io_native.dart';

// file io for .drwx
class FileIo {
  static Future<String?> save(Uint8List bytes, {
    String filename = 'drawing.drwx',
  }) => saveFile(bytes, filename: filename);

  static Future<Uint8List?> open() => openFile();
}