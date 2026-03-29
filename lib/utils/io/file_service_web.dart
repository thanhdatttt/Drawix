import 'dart:js_interop';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:web/web.dart' as web;

// used on web

Future<String> saveToPath(Uint8List bytes, String path) async {
  await saveFile(bytes, defaultName: path.split('/').last);
  return path; // return the original path unchanged
}

Future<String?> saveFile(Uint8List bytes,
    {String defaultName = 'drawing.drwx'}) async {
  final blob = web.Blob(
    [bytes.toJS].toJS,
    web.BlobPropertyBag(type: 'application/octet-stream'),
  );
  final url = web.URL.createObjectURL(blob);

  final anchor = web.document.createElement('a') as web.HTMLAnchorElement
    ..href = url
    ..download = defaultName;

  web.document.body!.appendChild(anchor);
  anchor.click();
  web.document.body!.removeChild(anchor);
  web.URL.revokeObjectURL(url);

  return null; // no path on web
}

Future<({Uint8List bytes, String? path})?> openFile() async {
  final result = await FilePicker.platform.pickFiles(
    dialogTitle: 'Open drawing',
    type: FileType.custom,
    allowedExtensions: ['drwx'],
    withData: true,
  );
  if (result == null || result.files.isEmpty) return null;
  final bytes = result.files.first.bytes;
  if (bytes == null) return null;
  return (bytes: bytes, path: null); // web never has a path
}