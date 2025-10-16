// ----------------------------------------------------
// ЭКРАН ИСТОРИИ - HistoryScreen
// ----------------------------------------------------
import 'package:flutter/material.dart';
import '../models/mood_entry.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('История Настроений'),
      ),
      // Отображение коллекции элементов из moodHistory
      body: ListView.builder(
        itemCount: moodHistory.length,
        itemBuilder: (context, index) {
          final entry = moodHistory[index];

          // Определяем, что показать в subtitle
          String subtitleText = entry.note != null && entry.note!.isNotEmpty
              ? 'Заметка: ${entry.note!}\n'
              : 'Заметки нет\n';

          // Добавляем факт от API
          subtitleText += 'API Факт: ${entry.apiFact ?? "Не получен"}';

          return ListTile(
            leading: Text(entry.emoji, style: const TextStyle(fontSize: 24)),
            title: Text(entry.toString()),
            // Используем RichText для отображения заметки и факта
            subtitle: Text(subtitleText),
            isThreeLine: true, // Включаем поддержку трех строк для отображения API-факта
          );
        },
      ),
    );
  }
}