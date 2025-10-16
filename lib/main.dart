import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
import 'screens/history_screen.dart';
import 'screens/stats_screen.dart';

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
        // мягкий "мятный" (teal) цвет
        primaryColor: const Color(0xFF64B5F6), // Голубой
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blueGrey,
          accentColor: const Color(0xFFB39DDB), // Пастельный фиолетовый для акцентов
        ),
        scaffoldBackgroundColor: const Color(0xFFFAFAFA), // Светло-серый фон
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0.5, // Небольшая тень
          centerTitle: true,
        ),

        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black54),
        ),
      ),
      debugShowCheckedModeBanner: false,
      // Настраиваем маршруты для навигации
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(),
        '/history': (context) => const HistoryScreen(),
        '/stats': (context) => const StatsScreen(),
      },
    );
  }
}



