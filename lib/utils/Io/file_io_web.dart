import 'dart:html' as html;
import 'dart:async';
import 'dart:typed_data';

Future<String?> saveFile(Uint8List bytes, {String filename = 'drawing.drwx'}) {
  final blob = html.Blob([bytes], 'application/octet-stream');
  final url  = html.Url.createObjectUrlFromBlob(blob);
  html.AnchorElement(href: url)
    ..setAttribute('download', filename)
    ..click();
  html.Url.revokeObjectUrl(url);
  return Future.value(null); // no path concept on web
}

Future<Uint8List?> openFile() {
  final completer = Completer<Uint8List?>();

  final input = html.FileUploadInputElement()
    ..accept = '.drwx'
    ..style.display = 'none';

  html.document.body!.append(input);

  input.onChange.listen((_) async {
    final file = input.files?.first;
    input.remove();

    if (file == null) { completer.complete(null); return; }

    final reader = html.FileReader();
    reader.readAsArrayBuffer(file);
    reader.onLoad.listen((_) {
      final buffer = reader.result as ByteBuffer;
      completer.complete(buffer.asUint8List());
    });
    reader.onError.listen((_) => completer.complete(null));
  });

  input.click();

  Future.delayed(const Duration(minutes: 10), () {
    if (!completer.isCompleted) completer.complete(null);
  });

  return completer.future;
}