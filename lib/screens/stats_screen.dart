// lib/screens/stats_screen.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/mood_entry.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  // Функция для подготовки данных для круговой диаграммы
  Map<String, int> _calculateMoodCounts() {
    final counts = <String, int>{};
    for (var entry in moodHistory) {
      counts[entry.mood] = (counts[entry.mood] ?? 0) + 1;
    }
    return counts;
  }

  // Создание секций для диаграммы
  List<PieChartSectionData> _buildSections(Map<String, int> counts) {
    if (counts.isEmpty) return [];

    final total = counts.values.fold(0, (sum, count) => sum + count);
    final List<Color> colors = [
      Colors.green.shade400, // Радость
      Colors.blue.shade300,  // Спокойствие
      Colors.grey.shade500,  // Грусть
      Colors.red.shade400,   // Энергия
      Colors.purple.shade300 // Другие
    ];
    int colorIndex = 0;

    return counts.entries.map((entry) {
      final percentage = (entry.value / total) * 100;
      final color = colors[colorIndex++ % colors.length];

      return PieChartSectionData(
        color: color,
        value: entry.value.toDouble(),
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 80,
        titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        badgeWidget: Text(entry.key, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        badgePositionPercentageOffset: 0.9,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final moodCounts = _calculateMoodCounts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Статистика Настроений'),
      ),
      body: moodCounts.isEmpty
          ? const Center(child: Text('Нет данных для статистики.'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Распределение настроений', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: PieChart(
                PieChartData(
                  sections: _buildSections(moodCounts),
                  borderData: FlBorderData(show: false),
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                  // Убираем стандартный заголовок
                  //sectionsTitleMargin: 0,
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Добавление легенды (опционально, так как уже есть на диаграмме)
            Wrap(
              spacing: 10,
              children: moodCounts.keys.map((key) {
                return Chip(
                  label: Text('$key (${moodCounts[key]})'),
                  backgroundColor: _buildSections(moodCounts).firstWhere((element) => (element.badgeWidget as Text).data!.contains(key)).color,
                  labelStyle: const TextStyle(color: Colors.white),
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}