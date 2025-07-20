import 'package:flutter/material.dart';
import '../models/habit.dart';

class HabitCreationScreen extends StatefulWidget {
  const HabitCreationScreen({super.key});

  @override
  State<HabitCreationScreen> createState() => _HabitCreationScreenState();
}

class _HabitCreationScreenState extends State<HabitCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _selectedCategory = 'Health';
  bool _reminderOn = false;
  TimeOfDay? _reminderTime;

  final List<String> _categories = ['Health', 'Fitness', 'Learning', 'Work', 'Hobby'];

  void _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _reminderTime = picked;
      });
    }
  }

  void _saveHabit() {
    if (_formKey.currentState!.validate()) {
      final habit = Habit(
        name: _nameController.text.trim(),
        category: _selectedCategory,
        reminderTime: _reminderOn ? _reminderTime : null,
      );

      Navigator.pop(context, habit);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Habit')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Habit Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Please enter a name'
                    : null,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(cat),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedCategory = value!),
              ),
              const SizedBox(height: 20),
              SwitchListTile(
                title: const Text('Set Reminder'),
                value: _reminderOn,
                onChanged: (value) => setState(() => _reminderOn = value),
              ),
              if (_reminderOn)
                ListTile(
                  title: Text(
                    _reminderTime != null
                        ? 'Reminder Time: ${_reminderTime!.format(context)}'
                        : 'Pick Reminder Time',
                  ),
                  trailing: const Icon(Icons.access_time),
                  onTap: _pickTime,
                ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _saveHabit,
                icon: const Icon(Icons.save),
                label: const Text('Save Habit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
