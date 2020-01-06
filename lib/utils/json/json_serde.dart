import 'dart:convert';

import 'package:planner/utils/file/file_stream.dart';

class JsonSerDe {
  FileStream _fileStream = new FileStream();

  Future toJson(String dir, String filename, Map<String, dynamic> jsonMap) async {
    String jsonString = jsonEncode(jsonMap);
    await _fileStream.writeContent(dir, filename, jsonString);
  }

  Future<Map<String, dynamic>> fromJson(String filename) async {
    String fileContent;
    await _fileStream.readContent(filename).then((c) {
      fileContent = c;
    });
    if (fileContent == "Error!") {
      return null;
    }
    Map<String, dynamic> jsonMap = jsonDecode(fileContent);
    return jsonMap;
  }
}
