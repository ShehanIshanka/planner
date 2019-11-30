import 'dart:convert';

import 'package:planner/utils/file/file_stream.dart';

class JsonSerDe {
  FileStream _fileStream = new FileStream();

  void toJson(String dir, String filename, Map<String, dynamic> jsonMap) {
    String jsonString = jsonEncode(jsonMap);
    _fileStream.writeContent(dir, filename, jsonString);
  }

  Future<Map<String, dynamic>> fromJson(String filename) async {
    String fileContent;
    await _fileStream.readContent(filename).then((c) {
      fileContent = c;
    });
    Map<String, dynamic> jsonMap = jsonDecode(fileContent);
    return jsonMap;
  }
}
