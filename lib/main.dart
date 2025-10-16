import 'package:flutter/material.dart';

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
      // Настраиваем маршруты для навигации
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(),
        '/history': (context) => const HistoryScreen(), // Наш второй экран
      },
    );
  }
}

// ----------------------------------------------------
// 1. ГЛАВНЫЙ ЭКРАН (ЛР4)
// ----------------------------------------------------

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Как ваше настроение?'),
        actions: [
          // Кнопка для перехода к Истории (навигация)
          IconButton(
            icon: const Icon(Icons.history_toggle_off_outlined),
            onPressed: () {
              // Переход на экран /history
              Navigator.pushNamed(context, '/history');
            },
            tooltip: 'История Настроений',
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Здесь будет верстка кнопок выбора настроения.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

// ----------------------------------------------------
// 2. ЭКРАН ИСТОРИИ (Заглушка для ЛР4)
// ----------------------------------------------------

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('История Настроений'),
      ),
      body: const Center(
        child: Text(
          'Здесь будет список сохраненных записей.',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}