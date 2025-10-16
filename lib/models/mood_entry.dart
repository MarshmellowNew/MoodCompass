class MoodEntry {
  final String mood;
  final String emoji;
  final String? note; // Заметка опциональна
  final DateTime timestamp;
  final String? apiFact;

  MoodEntry({
    required this.mood,
    required this.emoji,
    this.note,
    required this.timestamp,
    this.apiFact,
  });

  // Временное форматирование для отображения в списке
  @override
  String toString() {
    return '${timestamp.day}.${timestamp.month}.${timestamp.year} ${timestamp.hour}:${timestamp.minute} - $mood $emoji';
  }
}

// Временное хранилище данных (пока без сохранения на диске)
List<MoodEntry> moodHistory = [];