import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../widgets/habit_title.dart';
import '../services/notification_service.dart';
import 'calendar_heatmap_screen.dart';
import 'habit_creation_screen.dart'; 
import 'account_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Habit> habits = [
    Habit(
      name: 'Drink Water',
      category: 'Health',
      completionHistory: [
        DateTime(2025, 7, 16),
        DateTime(2025, 7, 17),
        DateTime(2025, 7, 18),
      ],
    ),
    Habit(
      name: 'Read Book',
      category: 'Learning',
      completionHistory: [
        DateTime(2025, 7, 15),
        DateTime(2025, 7, 17),
      ],
    ),
    Habit(
      name: 'Workout',
      category: 'Fitness',
      completionHistory: [],
    ),
  ];

  void toggleHabit(int index) {
    setState(() {
      final habit = habits[index];
      habit.isCompleted = !habit.isCompleted;

      if (habit.isCompleted) {
        habit.updateStreak();
        habit.completionHistory.add(DateTime.now()); // ✅ log today's date
      }
    });
  }

  void testReminder() {
    final now = DateTime.now();
    final scheduled = DateTime(now.year, now.month, now.day, now.hour, now.minute + 1);

    NotificationService.showScheduledNotification(
      id: 1,
      title: 'Habit Reminder',
      body: 'Don’t forget to do "${habits[0].name}"!',
      scheduledTime: scheduled,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today\'s Habits'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            tooltip: 'Calendar Heatmap',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CalendarHeatmapScreen(habits: habits),
                ),
              );
            },
          ),
           IconButton(
      icon: const Icon(Icons.account_circle),
      tooltip: 'My Account',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AccountScreen(), // You'll define this screen
          ),
        );
      },
    ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: habits.length,
              itemBuilder: (context, index) {
                return HabitTile(
                  habit: habits[index],
                  onToggle: () => toggleHabit(index),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: testReminder,
            icon: const Icon(Icons.notifications_active),
            label: const Text('Test Reminder'),
          ),
          const SizedBox(height: 20),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
      onPressed: () async {
        final newHabit = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HabitCreationScreen(),
          ),
        );

        if (newHabit != null && newHabit is Habit) {
          setState(() {
            habits.add(newHabit);
          });
        }
      },
      icon: const Icon(Icons.add),
      label: const Text('New Habit'),
    ),

    );
  }
}
