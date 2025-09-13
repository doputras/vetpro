import 'dart:io';

import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';

class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();

    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future<void> deleteDocument(String name) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    if (await file.exists()) {
      await file.delete();
    }
  }

  static Future downloadDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    Directory? dir = await DownloadsPath.downloadsDirectory();
    if (dir != null) {
      final file = File('${dir.path}/$name');

      await file.writeAsBytes(bytes);
    }
  }

  static Future openFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }
}
