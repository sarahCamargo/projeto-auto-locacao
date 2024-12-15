import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static final PrefsService _instance = PrefsService._internal();

  factory PrefsService() {
    return _instance;
  }

  PrefsService._internal();

  Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  Future<String?> getFilePath() async {
    final prefs = await _getPrefs();
    return prefs.getString('docx_file_path');
  }

  Future<void> saveFilePath(String path) async {
    final prefs = await _getPrefs();
    await prefs.setString('docx_file_path', path);
  }

  Future<void> saveFiles(List<Map<String, String>> files) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('files', json.encode(files));
  }

  Future<String> saveFileToInternalStorage(String filePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = filePath.split('/').last;
    final newPath = '${directory.path}/$fileName';

    final file = File(filePath);
    final newFile = File(newPath);
    await file.copy(newFile.path);

    return newPath;
  }

  Future<void> clearFilePath() async {
    final prefs = await _getPrefs();
    await prefs.remove('docx_file_path');
  }

  Future<String?> getDefaultFilePath() async {
    final directory = await getDownloadsDirectory();
    return directory?.path;
  }

  Future<String> getTempDirectory() async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  Future<List<Map<String, String>>> getFiles() async {
    final prefs = await SharedPreferences.getInstance();
    final filesString = prefs.getString('files');
    if (filesString != null) {
      final List<dynamic> decoded = json.decode(filesString);
      return decoded.map((item) {
        return Map<String, String>.from(item);
      }).toList();
    }
    return [];
  }

}
