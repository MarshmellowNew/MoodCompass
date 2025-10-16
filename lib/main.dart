import 'package:flutter/material.dart';
import 'mood_entry.dart';

void main() {
  runApp(const MoodCompassApp());
}

class MoodCompassApp extends StatelessWidget {
  const MoodCompassApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Эмоциональный Компас',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      debugShowCheckedModeBanner: false,
      // Настраиваем маршруты для навигации
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(),
        '/history': (context) => const HistoryScreen(), // второй экран
      },
    );
  }
}

// ----------------------------------------------------
// 1. ГЛАВНЫЙ ЭКРАН
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
  final Map<String, String> _moods = {
    'Радость': '😃',
    'Спокойствие': '😌',
    'Грусть': '😔',
    'Энергия': '💪',
  };

  void _saveMoodEntry() {
    if (_selectedMood == null) return;

    final newEntry = MoodEntry(
      mood: _selectedMood!,
      emoji: _moods[_selectedMood]!,
      note: _noteController.text.isNotEmpty ? _noteController.text : null,
      timestamp: DateTime.now(),
    );

    // Добавляем запись в начало списка
    moodHistory.insert(0, newEntry);

    // Очищаем форму
    setState(() {
      _selectedMood = null;
      _noteController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Настроение "${newEntry.mood}" сохранено!')),
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
              decoration: const InputDecoration(
                labelText: 'Краткая заметка (опционально)',
                hintText: 'Что повлияло на ваше настроение?',
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
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

// ----------------------------------------------------
// ЭКРАН ИСТОРИИ - HistoryScreen (Обновление для отображения данных)
// ----------------------------------------------------

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
          return ListTile(
            leading: Text(entry.emoji, style: const TextStyle(fontSize: 24)),
            title: Text(entry.toString()),
            // Отображение заметки, если она есть
            subtitle: entry.note != null && entry.note!.isNotEmpty
                ? Text('Заметка: ${entry.note!}')
                : const Text('Заметки нет'),
          );
        },
      ),
    );
  }
}