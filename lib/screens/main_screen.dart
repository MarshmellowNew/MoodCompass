// ----------------------------------------------------
// 1. ГЛАВНЫЙ ЭКРАН
// ----------------------------------------------------
import 'package:flutter/material.dart';
import '../models/mood_entry.dart';
import '../services/api_service.dart';

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
  final Map<String, String> _moods = {
    'Радость': '😃',
    'Спокойствие': '😌',
    'Грусть': '😔',
    'Энергия': '💪',
  };

  void _saveMoodEntry() async {
    if (_selectedMood == null) return;

    // 1. Показываем индикатор загрузки
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Сохранение... Получаем факт с API...')),
    );

    // 2. Получаем факт асинхронно
    final apiService = ApiService();
    final fact = await apiService.fetchRandomFact();

    // 3. Создаем запись с полученным фактом
    final newEntry = MoodEntry(
      mood: _selectedMood!,
      emoji: _moods[_selectedMood]!,
      note: _noteController.text.isNotEmpty ? _noteController.text : null,
      timestamp: DateTime.now(),
      apiFact: fact,
    );

    // 4. Добавляем в историю
    moodHistory.insert(0, newEntry);

    // 5. Очищаем форму и показываем успех
    setState(() {
      _selectedMood = null;
      _noteController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Запись настроения "${newEntry.mood}" сохранена.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Как ваше настроение?'),
        actions: [
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
                  childAspectRatio: 2.5, // Соотношение сторон
                ),
                itemCount: _moods.length,
                itemBuilder: (context, index) {
                  String moodName = _moods.keys.elementAt(index);
                  String moodEmoji = _moods.values.elementAt(index);

                  // Кнопка-карточка для выбора настроения
                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        // Обновляем состояние при выборе
                        _selectedMood = moodName;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      // Стилизация: выделение выбранной кнопки
                      backgroundColor: _selectedMood == moodName
                          ? Colors.blueGrey.shade700
                          : Colors.grey.shade100,
                      foregroundColor: _selectedMood == moodName
                          ? Colors.white
                          : Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: _selectedMood == moodName ? 4 : 1,
                    ),
                    child: Text(
                      '$moodEmoji $moodName',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                labelText: 'Краткая заметка (опционально)',
                hintText: 'Что повлияло на ваше настроение?',
                border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),

                //  Кнопка стирания
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _noteController.clear();
                    // Дополнительно можно вызвать setState, если нужно, чтобы кнопка исчезала
                    // setState(() {});
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Кнопка "Сохранить"
            ElevatedButton(
              onPressed: _selectedMood == null ? null : _saveMoodEntry,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
                backgroundColor: Colors.blueGrey,
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