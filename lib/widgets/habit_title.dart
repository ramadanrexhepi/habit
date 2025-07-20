import 'package:flutter/material.dart';
import '../models/habit.dart';

class HabitTile extends StatelessWidget {
  final Habit habit;
  final VoidCallback onToggle;

  const HabitTile({super.key, required this.habit, required this.onToggle});

  Widget buildStreakChain(BuildContext context, Habit habit) {
    final now = DateTime.now();
    List<Widget> dots = [];

    for (int i = 6; i >= 0; i--) {
      final day = DateTime(now.year, now.month, now.day - i);
      final completed = habit.completionHistory.any(
        (d) => d.year == day.year && d.month == day.month && d.day == day.day,
      );

      dots.add(
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: completed ? 14 : 10,
          height: completed ? 14 : 10,
          decoration: BoxDecoration(
            color: completed
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.withOpacity(0.3),
            shape: BoxShape.circle,
            boxShadow: completed
                ? [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                      blurRadius: 6,
                      spreadRadius: 1,
                    )
                  ]
                : [],
          ),
        ),
      );
    }

    return Row(children: dots);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        title: Text(
          habit.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(habit.category),
            const SizedBox(height: 4),
            Text('🔥 Current Streak: ${habit.currentStreak}'),
            Text('🏅 Longest Streak: ${habit.longestStreak}'),
            const SizedBox(height: 8),
            buildStreakChain(context, habit), // <- fixed context passing
          ],
        ),
        trailing: Checkbox(
          value: habit.isCompleted,
          onChanged: (_) => onToggle(),
        ),
      ),
    );
  }
}
