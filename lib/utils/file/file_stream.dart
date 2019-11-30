import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileStream {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<String> readContent(String filename) async {
    final path = await _localPath;
    try {
      final file = await File('$path/$filename');
      // Read the file
      String contents = await file.readAsString();
      // Returning the contents of the file
      print("Contents :" + contents);

      return contents;
    } catch (e) {
      // If encountering an error, return
      return 'Error!';
    }
  }

  void writeContent(String dir, String filename, String data) async {
    final path = await _localPath;
    final file = await File('$path/$dir/$filename');
    final myDir = new Directory('$path/$dir');
    myDir.exists().then((isThere) {
      if (!isThere) {
        myDir.create(recursive: true);
      }
    });
    print("File Name:" + filename);
    print("Contents:" + data);
    file.writeAsString('$data');
  }
}
