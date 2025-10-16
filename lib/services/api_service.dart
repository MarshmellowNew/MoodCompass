import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  // ИСПРАВЛЕНО: Перешли на HTTPS-совместимый API (Cat Facts)
  Future<String> fetchRandomFact() async {
    final url = Uri.parse('https://catfact.ninja/fact'); // HTTPS-совместимый API

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Ответ приходит в виде JSON
        final data = json.decode(response.body);
        return data['fact'] ?? 'Факт не получен.';
      } else {
        // Запасной вариант при ошибке сервера
        return 'Не удалось получить факт (Сервер: ${response.statusCode})';
      }
    } catch (e) {
      // Запасной вариант при ошибке сети
      return 'Ошибка сети. Проверьте подключение: $e';
    }
  }
}