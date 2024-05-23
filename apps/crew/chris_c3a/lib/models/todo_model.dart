import 'package:chris_c3a/models/identifier_model.dart';

import '/models/model.dart';

class Todo extends IdentifierModel {
  final String title;
  final String description;
  bool isDone;

  // Constructor
  Todo({
    String? id,
    required this.title,
    required this.description,
    this.isDone = false,
  }) : super(id ?? '');

  // creates a copy of this todo with the given fields replaced
  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? isDone,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
    );
  }

  // Map to/from Firebase document
  Todo.fromMap(Map<String, dynamic> map, super.id)
      : title = map['title'],
        description = map['description'],
        isDone = map['isDone'] ?? false;

  Map<String, dynamic> toMap() => {
        'title': title,
        'description': description,
        'isDone': isDone,
      };
}
