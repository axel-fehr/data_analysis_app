import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

// Note: Code from this source: https://flutter.dev/docs/cookbook/persistence/reading-writing-files

class LogsStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/logs.txt');
  }

  Future<int> readLog() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  void writeLog(bool value) async {
    final file = await _localFile;
    print('log saved to disk');
    // Write the file
    file.writeAsString('$value');
  }
}
