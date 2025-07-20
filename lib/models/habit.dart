import 'package:flutter/material.dart';


class Habit {
  String name;
  String category;
  bool isCompleted;
  int currentStreak;
  int longestStreak;
  DateTime? lastCompletedDate;
  List<DateTime> completionHistory;
  TimeOfDay? reminderTime;


  Habit({
  required this.name,
  required this.category,
  this.isCompleted = false,
  this.currentStreak = 0,
  this.longestStreak = 0,
  this.lastCompletedDate,
  this.completionHistory = const [],
  this.reminderTime,
});

  void updateStreak() {
    final today = DateTime.now();

    if (lastCompletedDate == null) {
      currentStreak = 1;
    } else {
      final daysMissed = today.difference(lastCompletedDate!).inDays;

      if (daysMissed == 1) {
        currentStreak += 1;
      } else if (daysMissed == 2) {
        // Grace period: streak freeze
        currentStreak += 1;
      } else if (daysMissed > 2) {
        currentStreak = 1;
      }
      // if daysMissed == 0, do not update streak again
    }

    if (currentStreak > longestStreak) {
      longestStreak = currentStreak;
    }

    lastCompletedDate = today;
    completionHistory = [...completionHistory, today];
  }
}
