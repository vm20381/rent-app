import 'package:cloud_firestore/cloud_firestore.dart';

class ToDo {
  String id;
  String task;
  bool isDone;
  String userId;
  String userName;

  ToDo({
    required this.id,
    required this.task,
    this.isDone = false,
    required this.userId,
    required this.userName,
  });

  factory ToDo.fromFirestore(Map<String, dynamic> data, String documentId) {
    return ToDo(
      id: documentId,
      task: data['task'] ?? '',
      isDone: data['isDone'] ?? false,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'task': task,
      'isDone': isDone,
      'userId': userId,
      'userName': userName,
    };
  }
}
