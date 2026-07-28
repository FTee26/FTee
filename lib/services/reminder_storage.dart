import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/reminder.dart';

class ReminderStorage {
  static const String _storageKey = 'ftee_reminders';

  Future<List<Reminder>> loadReminders() async {
    final preferences = await SharedPreferences.getInstance();
    final storedValue = preferences.getString(_storageKey);

    if (storedValue == null || storedValue.isEmpty) {
      return [];
    }

    try {
      final decodedValue = jsonDecode(storedValue);

      if (decodedValue is! List) {
        return [];
      }

      final reminders = decodedValue
          .whereType<Map>()
          .map(
            (item) => Reminder.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();

      reminders.sort(
        (first, second) =>
            first.dateTime.compareTo(second.dateTime),
      );

      return reminders;
    } catch (_) {
      return [];
    }
  }

  Future<void> saveReminders(List<Reminder> reminders) async {
    final preferences = await SharedPreferences.getInstance();

    final encodedValue = jsonEncode(
      reminders.map((reminder) => reminder.toJson()).toList(),
    );

    await preferences.setString(_storageKey, encodedValue);
  }

  Future<void> clearReminders() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_storageKey);
  }
}