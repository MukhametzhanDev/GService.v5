import 'package:shared_preferences/shared_preferences.dart';

class CacheSearchTitleData {
  static Future<void> incrementHistoryData(value) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('historyData') ?? [];
    for (var element in history) {
      if (element == value) {
        value = "";
      }
    }
    if (value.isNotEmpty) {
      if (history.length >= 6) {
        history.removeAt(0);
        history.insert(history.length, value);
      } else {
        history.add(value);
      }
    }
    prefs.setStringList('historyData', history);
  }

  static Future<void> removeHistoryData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('historyData');
  }

  static Future<void> removeTitle(value) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('historyData') ?? [];
    history.remove(value);
    prefs.setStringList('historyData', history);
  }
}
