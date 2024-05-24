class TodoItem {
  final String id;
  final String title;
  final String description;
  bool isDone;

  TodoItem({
    required this.id,
    required this.title,
    required this.description,
    required this.isDone,
  });

  factory TodoItem.fromFirestore(Map<String, dynamic> data, String documentId) {
    return TodoItem(
      id: documentId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      isDone: data['isDone'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'isDone': isDone,
    };
  }
}
