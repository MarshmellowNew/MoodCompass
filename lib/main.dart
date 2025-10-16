import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
import 'screens/history_screen.dart';

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
        '/history': (context) => const HistoryScreen(),
      },
    );
  }
}



