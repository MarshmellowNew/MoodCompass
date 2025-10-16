import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/mood_entry.dart';

class StorageService {
  static const String _key = 'moodHistoryList';

  // 1. Загрузка данных из хранилища
  Future<List<MoodEntry>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);

    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      // Преобразуем List<Map> в List<MoodEntry>
      return jsonList.map((json) => MoodEntry.fromJson(json)).toList();
    }
    return []; // Возвращаем пустой список, если ничего нет
  }

  // 2. Сохранение данных в хранилище
  Future<void> saveHistory(List<MoodEntry> history) async {
    final prefs = await SharedPreferences.getInstance();
    // Преобразуем List<MoodEntry> в List<Map> -> в JSON-строку
    final jsonList = history.map((entry) => entry.toJson()).toList();
    final jsonString = json.encode(jsonList);
    await prefs.setString(_key, jsonString);
  }
}