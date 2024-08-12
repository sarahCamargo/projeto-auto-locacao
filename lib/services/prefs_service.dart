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
}
