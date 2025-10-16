class MoodEntry {
  final String mood;
  final String emoji;
  final String? note;
  final DateTime timestamp;
  final String? apiFact;

  MoodEntry({
    required this.mood,
    required this.emoji,
    this.note,
    required this.timestamp,
    this.apiFact,
  });

  // Преобразование объекта в Map (для JSON)
  Map<String, dynamic> toJson() => {
    'mood': mood,
    'emoji': emoji,
    'note': note,
    'timestamp': timestamp.toIso8601String(), // Сохраняем как строку
    'apiFact': apiFact,
  };

  // Создание объекта из Map (из JSON)
  factory MoodEntry.fromJson(Map<String, dynamic> json) => MoodEntry(
    mood: json['mood'] as String,
    emoji: json['emoji'] as String,
    note: json['note'] as String?,
    timestamp: DateTime.parse(json['timestamp'] as String), // Читаем обратно
    apiFact: json['apiFact'] as String?,
  );

  // Временное форматирование для отображения в списке
  @override
  String toString() {
    return '${timestamp.day}.${timestamp.month}.${timestamp.year} ${timestamp.hour}:${timestamp.minute} - $mood $emoji';
  }
}

// Временное хранилище данных (пока без сохранения на диске)
List<MoodEntry> moodHistory = [];