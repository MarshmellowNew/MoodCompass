import 'package:flutter/material.dart';
import '../models/mood_entry.dart';
import '../services/api_service.dart';
import 'history_screen.dart'; // Для навигации
import 'stats_screen.dart'; // Для навигации

// ----------------------------------------------------
// ГЛАВНЫЙ ЭКРАН
// ----------------------------------------------------

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Выбранное настроение (изначально null)
  String? _selectedMood;
  final TextEditingController _noteController = TextEditingController();

  // Категории настроений
  final Map<String, String> _moods = const {
    'Радость': '😃',
    'Спокойствие': '😌',
    'Грусть': '😔',
    'Энергия': '💪',
  };

  // 1. Отдельная функция для фактического сохранения (ЛР5 и ЛР6)
  void _saveAndCommitEntry() async {
    if (_selectedMood == null || !mounted) return;

    // Показываем индикатор загрузки
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Сохранение... Получаем факт с API...')),
    );

    // Получаем факт асинхронно
    final apiService = ApiService();
    final fact = await apiService.fetchRandomFact();

    // Создаем запись с полученным фактом
    final newEntry = MoodEntry(
      mood: _selectedMood!,
      emoji: _moods[_selectedMood]!,
      note: _noteController.text.isNotEmpty ? _noteController.text : null,
      timestamp: DateTime.now(),
      apiFact: fact,
    );

    // Добавляем в историю
    moodHistory.insert(0, newEntry);

    // Очищаем форму и показываем успех
    setState(() {
      _selectedMood = null;
      _noteController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Запись настроения "${newEntry.mood}" сохранена.')),
    );
  }

  // 2. Функция, которая показывает окно подтверждения (Пункт 6)
  void _showConfirmationDialog() {
    if (_selectedMood == null) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Подтверждение записи'),
          content: Text('Вы уверены, что хотите сохранить настроение "${_selectedMood}"?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Отмена', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop(); // Закрыть диалог
              },
            ),
            ElevatedButton(
              child: const Text('Сохранить'),
              onPressed: () {
                Navigator.of(context).pop(); // Закрыть диалог
                _saveAndCommitEntry(); // Запустить сохранение
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Как ваше настроение?'),
        actions: [
          // Кнопка Статистики
          IconButton(
            icon: const Icon(Icons.pie_chart_outline),
            onPressed: () {
              Navigator.pushNamed(context, '/stats');
            },
            tooltip: 'Статистика Настроений',
          ),
          // Кнопка Истории
          IconButton(
            icon: const Icon(Icons.history_toggle_off_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/history');
            },
            tooltip: 'История Настроений',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Секция выбора настроения (Grid)
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 кнопки в ряд
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.5, // Изменили соотношение для вертикального отображения эмодзи
                ),
                itemCount: _moods.length,
                itemBuilder: (context, index) {
                  String moodName = _moods.keys.elementAt(index);
                  String moodEmoji = _moods.values.elementAt(index);

                  // Кнопка-карточка для выбора настроения (Пункт 4 - Дизайн)
                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedMood = moodName;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      // Стилизация: Чистый дизайн карточек
                      backgroundColor: _selectedMood == moodName
                          ? Theme.of(context).colorScheme.secondary.withOpacity(0.8) // Цвет акцента при выборе
                          : Colors.white, // Белый фон
                      foregroundColor: _selectedMood == moodName
                          ? Colors.white
                          : Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(
                          color: _selectedMood == moodName
                              ? Theme.of(context).colorScheme.secondary
                              : Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      elevation: _selectedMood == moodName ? 6 : 1, // Тень только при выборе
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(moodEmoji, style: const TextStyle(fontSize: 28)),
                        const SizedBox(height: 4),
                        Text(
                          moodName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _selectedMood == moodName ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Текстовое поле для заметки
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: 'Краткая заметка',
                hintText: 'Что повлияло на ваше настроение?',
                border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),

                // Кнопка стирания (Пункт 7)
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _noteController.clear();
                    // Вызываем setState для обновления, если нужно, чтобы кнопка clear исчезала при пустом поле.
                    // setState(() {});
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Кнопка "Сохранить"
            ElevatedButton(
              onPressed: _selectedMood == null ? null : _showConfirmationDialog, // Вызываем диалог
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
                backgroundColor: Theme.of(context).colorScheme.secondary, // Используем акцентный цвет
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Сохранить Запись'),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}