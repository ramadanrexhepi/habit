import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import '../models/habit.dart';

class CalendarHeatmapScreen extends StatelessWidget {
  final List<Habit> habits;

  const CalendarHeatmapScreen({super.key, required this.habits});

  @override
  Widget build(BuildContext context) {
    Map<DateTime, int> data = {};

    for (var habit in habits) {
      for (var date in habit.completionHistory) {
        final key = DateTime(date.year, date.month, date.day);
        data[key] = (data[key] ?? 0) + 1;
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Habit Calendar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: HeatMapCalendar(
          datasets: data,
          colorMode: ColorMode.color,
          colorTipCount: 4,
          defaultColor: Colors.grey[300]!,
          colorsets: <int, Color>{
            1: Colors.teal[200]!,
            2: Colors.teal[400]!,
            3: Colors.teal[600]!,
            4: Colors.teal[700]!,
          },
        ),
      ),
    );
  }
}
