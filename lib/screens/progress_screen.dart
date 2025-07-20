import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/habit.dart';

class ProgressScreen extends StatelessWidget {
  final List<Habit> habits;

  const ProgressScreen({super.key, required this.habits});

  List<double> getWeeklyCompletionData() {
    final now = DateTime.now();
    List<double> counts = List.filled(7, 0);

    for (var habit in habits) {
      for (var date in habit.completionHistory) {
        final diff = now.difference(date).inDays;
        if (diff >= 0 && diff < 7) {
          int index = 6 - diff; // reverse to align with week (Mon–Sun)
          counts[index]++;
        }
      }
    }

    return counts;
  }

  @override
  Widget build(BuildContext context) {
    final weeklyData = getWeeklyCompletionData();

    return Scaffold(
      appBar: AppBar(title: const Text('Habit Progress')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Weekly Habit Completion',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            AspectRatio(
              aspectRatio: 1.7,
              child: BarChart(
                BarChartData(
                  barGroups: List.generate(weeklyData.length, (index) {
                    return BarChartGroupData(x: index, barRods: [
                      BarChartRodData(
                        toY: weeklyData[index],
                        color: Theme.of(context).colorScheme.primary,
                        width: 16,
                        borderRadius: BorderRadius.circular(4),
                      )
                    ]);
                  }),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(days[value.toInt()], style: const TextStyle(fontSize: 12)),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Total Completions: ${weeklyData.reduce((a, b) => a + b).toInt()}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
