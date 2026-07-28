class Reminder {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final String category;
  final String repetition;
  final bool notificationEnabled;

  const Reminder({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.category,
    required this.repetition,
    required this.notificationEnabled,
  });

  Reminder copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dateTime,
    String? category,
    String? repetition,
    bool? notificationEnabled,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      category: category ?? this.category,
      repetition: repetition ?? this.repetition,
      notificationEnabled:
          notificationEnabled ?? this.notificationEnabled,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
      'category': category,
      'repetition': repetition,
      'notificationEnabled': notificationEnabled,
    };
  }

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      dateTime: DateTime.tryParse(
            json['dateTime'] as String? ?? '',
          ) ??
          DateTime.now(),
      category: json['category'] as String? ?? 'Allgemein',
      repetition: json['repetition'] as String? ?? 'Einmalig',
      notificationEnabled:
          json['notificationEnabled'] as bool? ?? true,
    );
  }
}