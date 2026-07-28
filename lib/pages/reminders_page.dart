import 'package:flutter/material.dart';

import '../models/reminder.dart';
import '../services/reminder_storage.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  final ReminderStorage _storage = ReminderStorage();

  List<Reminder> _reminders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    final reminders = await _storage.loadReminders();

    if (!mounted) {
      return;
    }

    setState(() {
      _reminders = reminders;
      _isLoading = false;
    });
  }

  Future<void> _saveReminders() async {
    _reminders.sort(
      (first, second) =>
          first.dateTime.compareTo(second.dateTime),
    );

    await _storage.saveReminders(_reminders);

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _openReminderDialog({
    Reminder? existingReminder,
  }) async {
    final result = await showModalBottomSheet<Reminder>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return ReminderEditor(
          existingReminder: existingReminder,
        );
      },
    );

    if (result == null) {
      return;
    }

    final existingIndex = _reminders.indexWhere(
      (reminder) => reminder.id == result.id,
    );

    if (existingIndex >= 0) {
      _reminders[existingIndex] = result;
    } else {
      _reminders.add(result);
    }

    await _saveReminders();
  }

  Future<void> _deleteReminder(Reminder reminder) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Erinnerung löschen?'),
          content: Text(
            'Möchtest du „${reminder.title}“ wirklich löschen?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Abbrechen'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Löschen'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    _reminders.removeWhere(
      (item) => item.id == reminder.id,
    );

    await _saveReminders();
  }

  Color _categoryColor(String category) {
    switch (category) {
      case 'Familie':
        return const Color(0xFFFF668A);
      case 'Arbeit':
        return const Color(0xFF4A9DFF);
      case 'Feuerwehr':
        return const Color(0xFFFF6A4B);
      default:
        return const Color(0xFFA477FF);
    }
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Familie':
        return Icons.family_restroom_rounded;
      case 'Arbeit':
        return Icons.work_outline_rounded;
      case 'Feuerwehr':
        return Icons.local_fire_department_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
    );

    final difference = date.difference(today).inDays;

    if (difference == 0) {
      return 'Heute';
    }

    if (difference == 1) {
      return 'Morgen';
    }

    if (difference == -1) {
      return 'Gestern';
    }

    return '${dateTime.day.toString().padLeft(2, '0')}.'
        '${dateTime.month.toString().padLeft(2, '0')}.'
        '${dateTime.year}';
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')} Uhr';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0D12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0D12),
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Erinnerungen',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          if (_reminders.isNotEmpty)
            IconButton(
              tooltip: 'Neue Erinnerung',
              onPressed: _openReminderDialog,
              icon: const Icon(Icons.add_rounded),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openReminderDialog,
        icon: const Icon(Icons.add_alarm_rounded),
        label: const Text('Neue Erinnerung'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _reminders.isEmpty
              ? _EmptyReminderView(
                  onCreateReminder: _openReminderDialog,
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(
                    18,
                    10,
                    18,
                    110,
                  ),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(bottom: 18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF35255E),
                            Color(0xFF1E2037),
                          ],
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.notifications_active_rounded,
                            color: Color(0xFFFFC857),
                            size: 44,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_reminders.length} '
                                  '${_reminders.length == 1 ? 'Erinnerung' : 'Erinnerungen'}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Alle Einträge werden auf diesem Gerät gespeichert.',
                                  style: TextStyle(
                                    color: Colors.white.withValues(
                                      alpha: 0.62,
                                    ),
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    ..._reminders.map(
                      (reminder) {
                        final color = _categoryColor(
                          reminder.category,
                        );

                        final isPast = reminder.dateTime.isBefore(
                          DateTime.now(),
                        );

                        return Dismissible(
                          key: ValueKey(reminder.id),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (_) async {
                            await _deleteReminder(reminder);
                            return false;
                          },
                          background: Container(
                            margin: const EdgeInsets.only(bottom: 13),
                            padding:
                                const EdgeInsets.only(right: 24),
                            alignment: Alignment.centerRight,
                            decoration: BoxDecoration(
                              color: Colors.red.shade700,
                              borderRadius:
                                  BorderRadius.circular(24),
                            ),
                            child: const Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.white,
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 13),
                            decoration: BoxDecoration(
                              color: const Color(0xFF181B23),
                              borderRadius:
                                  BorderRadius.circular(24),
                              border: Border.all(
                                color: color.withValues(
                                  alpha: 0.22,
                                ),
                              ),
                            ),
                            child: InkWell(
                              borderRadius:
                                  BorderRadius.circular(24),
                              onTap: () {
                                _openReminderDialog(
                                  existingReminder: reminder,
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(17),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 52,
                                      height: 52,
                                      decoration: BoxDecoration(
                                        color: color.withValues(
                                          alpha: 0.16,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(
                                          17,
                                        ),
                                      ),
                                      child: Icon(
                                        _categoryIcon(
                                          reminder.category,
                                        ),
                                        color: color,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  reminder.title,
                                                  style:
                                                      TextStyle(
                                                    color: isPast
                                                        ? Colors
                                                            .white54
                                                        : Colors
                                                            .white,
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight
                                                            .w700,
                                                  ),
                                                ),
                                              ),
                                              if (reminder
                                                  .notificationEnabled)
                                                Icon(
                                                  Icons
                                                      .notifications_active_rounded,
                                                  color: color,
                                                  size: 19,
                                                ),
                                            ],
                                          ),
                                          if (reminder.description
                                              .trim()
                                              .isNotEmpty) ...[
                                            const SizedBox(height: 6),
                                            Text(
                                              reminder.description,
                                              maxLines: 2,
                                              overflow: TextOverflow
                                                  .ellipsis,
                                              style: TextStyle(
                                                color: Colors.white
                                                    .withValues(
                                                  alpha: 0.53,
                                                ),
                                                height: 1.3,
                                              ),
                                            ),
                                          ],
                                          const SizedBox(height: 11),
                                          Wrap(
                                            spacing: 8,
                                            runSpacing: 7,
                                            children: [
                                              _InfoChip(
                                                icon: Icons
                                                    .calendar_today_rounded,
                                                label: _formatDate(
                                                  reminder.dateTime,
                                                ),
                                              ),
                                              _InfoChip(
                                                icon: Icons
                                                    .schedule_rounded,
                                                label: _formatTime(
                                                  reminder.dateTime,
                                                ),
                                              ),
                                              if (reminder
                                                      .repetition !=
                                                  'Einmalig')
                                                _InfoChip(
                                                  icon: Icons
                                                      .repeat_rounded,
                                                  label: reminder
                                                      .repetition,
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Icon(
                                      Icons.chevron_right_rounded,
                                      color: Colors.white.withValues(
                                        alpha: 0.35,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.055),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white54,
            size: 15,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyReminderView extends StatelessWidget {
  final VoidCallback onCreateReminder;

  const _EmptyReminderView({
    required this.onCreateReminder,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 105,
              height: 105,
              decoration: BoxDecoration(
                color: const Color(0xFFFFC857)
                    .withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: Color(0xFFFFC857),
                size: 54,
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Noch keine Erinnerungen',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Erstelle deine erste persönliche Erinnerung mit Datum und Uhrzeit.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.56),
                fontSize: 15,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 25),
            FilledButton.icon(
              onPressed: onCreateReminder,
              icon: const Icon(Icons.add_alarm_rounded),
              label: const Text('Erinnerung erstellen'),
            ),
          ],
        ),
      ),
    );
  }
}

class ReminderEditor extends StatefulWidget {
  final Reminder? existingReminder;

  const ReminderEditor({
    super.key,
    this.existingReminder,
  });

  @override
  State<ReminderEditor> createState() =>
      _ReminderEditorState();
}

class _ReminderEditorState extends State<ReminderEditor> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late String _selectedCategory;
  late String _selectedRepetition;
  late bool _notificationEnabled;

  final List<String> _categories = [
    'Allgemein',
    'Familie',
    'Arbeit',
    'Feuerwehr',
  ];

  final List<String> _repetitions = [
    'Einmalig',
    'Täglich',
    'Wöchentlich',
    'Monatlich',
    'Jährlich',
  ];

  @override
  void initState() {
    super.initState();

    final reminder = widget.existingReminder;
    final initialDateTime = reminder?.dateTime ??
        DateTime.now().add(const Duration(hours: 1));

    _titleController = TextEditingController(
      text: reminder?.title ?? '',
    );

    _descriptionController = TextEditingController(
      text: reminder?.description ?? '',
    );

    _selectedDate = DateTime(
      initialDateTime.year,
      initialDateTime.month,
      initialDateTime.day,
    );

    _selectedTime = TimeOfDay.fromDateTime(initialDateTime);
    _selectedCategory = reminder?.category ?? 'Allgemein';
    _selectedRepetition =
        reminder?.repetition ?? 'Einmalig';
    _notificationEnabled =
        reminder?.notificationEnabled ?? true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(
        const Duration(days: 365),
      ),
      lastDate: DateTime.now().add(
        const Duration(days: 3650),
      ),
      helpText: 'Datum auswählen',
      cancelText: 'Abbrechen',
      confirmText: 'Übernehmen',
    );

    if (selectedDate == null) {
      return;
    }

    setState(() {
      _selectedDate = selectedDate;
    });
  }

  Future<void> _selectTime() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      helpText: 'Uhrzeit auswählen',
      cancelText: 'Abbrechen',
      confirmText: 'Übernehmen',
    );

    if (selectedTime == null) {
      return;
    }

    setState(() {
      _selectedTime = selectedTime;
    });
  }

  void _saveReminder() {
    final title = _titleController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Bitte gib einen Titel für die Erinnerung ein.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final combinedDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final reminder = Reminder(
      id: widget.existingReminder?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      description: _descriptionController.text.trim(),
      dateTime: combinedDateTime,
      category: _selectedCategory,
      repetition: _selectedRepetition,
      notificationEnabled: _notificationEnabled,
    );

    Navigator.pop(context, reminder);
  }

  String _formatDate() {
    return '${_selectedDate.day.toString().padLeft(2, '0')}.'
        '${_selectedDate.month.toString().padLeft(2, '0')}.'
        '${_selectedDate.year}';
  }

  String _formatTime() {
    return '${_selectedTime.hour.toString().padLeft(2, '0')}:'
        '${_selectedTime.minute.toString().padLeft(2, '0')} Uhr';
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset =
        MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight:
            MediaQuery.of(context).size.height * 0.92,
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        14,
        20,
        20 + bottomInset,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF14171E),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 45,
                height: 5,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Text(
              widget.existingReminder == null
                  ? 'Neue Erinnerung'
                  : 'Erinnerung bearbeiten',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              autofocus: widget.existingReminder == null,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Titel',
                hintText: 'Zum Beispiel Übungsdienst',
                prefixIcon: Icon(Icons.title_rounded),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _descriptionController,
              textCapitalization: TextCapitalization.sentences,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Beschreibung',
                hintText: 'Optional weitere Informationen',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.notes_rounded),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Zeitpunkt',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _SelectionButton(
                    icon: Icons.calendar_month_rounded,
                    label: 'Datum',
                    value: _formatDate(),
                    onTap: _selectDate,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SelectionButton(
                    icon: Icons.schedule_rounded,
                    label: 'Uhrzeit',
                    value: _formatTime(),
                    onTap: _selectTime,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Kategorie',
                prefixIcon: Icon(Icons.category_rounded),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              initialValue: _selectedRepetition,
              decoration: const InputDecoration(
                labelText: 'Wiederholung',
                prefixIcon: Icon(Icons.repeat_rounded),
              ),
              items: _repetitions.map((repetition) {
                return DropdownMenuItem(
                  value: repetition,
                  child: Text(repetition),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  _selectedRepetition = value;
                });
              },
            ),
            const SizedBox(height: 14),
            SwitchListTile(
              value: _notificationEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationEnabled = value;
                });
              },
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 4,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              tileColor: Colors.white.withValues(alpha: 0.045),
              secondary: const Icon(
                Icons.notifications_active_rounded,
              ),
              title: const Text(
                'Mitteilung aktivieren',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: const Text(
                'Der tatsächliche Push-Versand wird im nächsten Schritt eingerichtet.',
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton.icon(
                onPressed: _saveReminder,
                icon: const Icon(Icons.save_rounded),
                label: Text(
                  widget.existingReminder == null
                      ? 'Erinnerung speichern'
                      : 'Änderungen speichern',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _SelectionButton({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.045),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.07),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: const Color(0xFFA477FF),
              size: 22,
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}