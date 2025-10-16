import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  // Асинхронная функция для получения случайного факта о числе
  Future<String> fetchRandomFact() async {
    // API: http://numbersapi.com/random/trivia
    final url = Uri.parse('http://numbersapi.com/random/trivia');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Ответ приходит как чистый текст (не JSON)
        return response.body;
      } else {
        // Если запрос не удался
        return 'Не удалось получить факт (код: ${response.statusCode})';
      }
    } catch (e) {
      // Ошибка сети
      return 'Ошибка сети при получении факта: $e';
    }
  }
}